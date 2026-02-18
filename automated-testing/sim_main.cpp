// DESCRIPTION: Verilator: --protect-lib example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2019 by Todd Strader.
// SPDX-License-Identifier: CC0-1.0
//======================================================================

// See examples/tracing_c for notes on tracing
        //sim_time++;
        //
#include <iomanip>
#include <cstdint>

#include <iostream>
#include <fstream>
#include <cassert>
#include <vector>
#include <string>
#include <stdexcept>


#include <elf.h>


// Include common routines
#include <verilated.h>

#include "Vriscv_ooc_top_level_wrapper.h"
#include "Vriscv_ooc_top_level_wrapper___024root.h"


using namespace std;
Vriscv_ooc_top_level_wrapper* top;
VerilatedContext* contextp;

#define my_assert(expr) \
    if (!(expr)) throw std::runtime_error("Assertion failed: " #expr)

void ftick() {

    top->clk_i = 0;                           
    top->eval();                               
    top->clk_i = 1;                           
    top->eval();                               
}



int main(int argc, char** argv, char** env) {
    string testelf = "";
    string output = "";
    int gran = -1;
    uint32_t begin_signature = -1;
    uint32_t end_signature = -1;
    uint32_t tohost = -1;
    for(int i=1;i<argc;i++) {
        string arg(argv[i]);
        auto pos = arg.find("=");
        if(pos == string::npos) {
            testelf = arg;
        } else {
            std::string key = arg.substr(0, pos);
            std::string value = arg.substr(pos+1, arg.length());
            if(key == "+signature") {
                output = value;
            } else if( key.compare("+signature-granularity") == 0){
                gran = stoi(value);
            } else if( key.compare("-tohost") == 0){
                tohost = stol(value, nullptr, 16);
            } else if( key.compare("-begin_signature") == 0){
                begin_signature = stol(value, nullptr, 16);
            } else if( key.compare("-end_signature") == 0){
                end_signature = stol(value, nullptr, 16);
            } else {
                cerr << "wrong argument: "<< arg << endl;
                return 1;
            }
        }
    }
    assert(testelf != "");
    assert(output != "");
    assert(gran != -1);
    assert(tohost != -1);
    assert(begin_signature != -1);
    assert(end_signature != -1);

      ifstream elff(testelf, ios::in | ios::binary);
      //ifstream elff("soft.elf", ios::in | ios::binary);

      if(!elff.is_open()) {
          cerr << "File didnt open" << endl;
          return 1;
      }
      //Read header 
      Elf32_Ehdr header;
      elff.read(reinterpret_cast<char*>(&header), sizeof(header));
      assert(header.e_shstrndx != SHN_UNDEF);
      assert(header.e_shstrndx != SHN_XINDEX);
        
      // Read program  header table
      elff.seekg(header.e_phoff);
      Elf32_Phdr* pheads = new Elf32_Phdr[header.e_phnum];
      assert(sizeof(Elf32_Phdr) == header.e_phentsize);
      for(int i=0;i<header.e_phnum;i++) {
          elff.read(reinterpret_cast<char*>(&pheads[i]), header.e_phentsize);
      }
      
      assert(header.e_phnum == 3);
      // Read inst and data blocks from a program header
      Elf32_Phdr inst_block  = pheads[1];
      Elf32_Phdr data_block  = pheads[2];

      size_t inst_sz = (inst_block.p_memsz+3)/4;
      size_t data_sz = (data_block.p_memsz+3)/4;
      vector<uint32_t> inst_bytes(inst_sz, 0);
      vector<uint32_t> data_bytes(data_sz, 0);
      
      elff.seekg(inst_block.p_offset);
      for(int i=0; i<(inst_block.p_filesz+3)/4;  i++) {
        elff.read(reinterpret_cast<char*>(&inst_bytes.at(i)), sizeof(uint32_t));
      }
    
      elff.seekg(data_block.p_offset);
      for(int i=0; i<(data_block.p_filesz+3)/4;  i++) {
        elff.read(reinterpret_cast<char*>(&data_bytes.at(i)), sizeof(uint32_t));
      }



    elff.close();
    // Construct context to hold simulation time, etc
    contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);


    top = new Vriscv_ooc_top_level_wrapper{contextp};

    top->boot_addr_i = header.e_entry;

    top->rst_ni = 1;
    ftick();
    top->rst_ni = 0;
    ftick();
    top->rst_ni = 1;
    ftick();

    top->fetch_enable_i=1;
    top->instr_rdata_i = 0;
    top->instr_rvalid_i = 0;
    top->instr_gnt_i= 0;

    top->data_gnt_i = 0;
    top->data_rvalid_i = 0;
    int breaks = 0;

    int early_ret = 0;
    //TODO: respond to back to back reads (and writes?)
    ofstream ofs(output);
    int cycles = 20000;
    try {
        for(int i=0;i<cycles;i++) {
            ftick();

            if(top->instr_req_o ) {
                ftick();
                ftick();
                ftick();
                ftick();
                //Refactor firs inside a loop
                uint32_t full_add;
                uint32_t addr;
                full_add = top->instr_addr_o;

                if(full_add<inst_block.p_vaddr){
                    cerr << "Inst err: " << hex <<full_add << "<" << hex << inst_block.p_vaddr << endl;
                    return 1;
                    my_assert(full_add>=inst_block.p_vaddr);
                }
                addr = (full_add - inst_block.p_vaddr);
                top->instr_gnt_i = 1;

                ftick();
                top->instr_rvalid_i = 1;
                top->instr_rdata_i = inst_bytes.at(addr/4);
                top->instr_gnt_i = 0;
                ftick();
                top->instr_rvalid_i = 0;
                ftick();

            }

            if(top->data_req_o) {
                uint8_t mask = top->data_be_o;
                uint32_t input = top->data_wdata_o;
                uint8_t write = top->data_we_o;

                vector<uint32_t>* curr_bytes;
                uint32_t addr;
                uint32_t full_addr = top->data_addr_o;
                curr_bytes = &data_bytes;
                my_assert(full_addr >= data_block.p_vaddr);
                addr = (full_addr-data_block.p_vaddr);
                top->data_gnt_i = 1;
                ftick();

                uint32_t byte_mask = 0;
                uint8_t mask_cp = mask;
                for(int j=0;j<4;j++){
                    byte_mask = byte_mask << 8;
                    if(mask_cp & 8) 
                        byte_mask+=255;
                    mask_cp = mask_cp << 1;
                }
                if(write) {
                    if(full_addr == tohost) {
                        break;
                    }
                    uint32_t old_value = curr_bytes->at(addr/4);
                    curr_bytes->at(addr/4) = (~byte_mask & old_value) | (byte_mask & input);
                } else {
                    top->data_rdata_i = curr_bytes->at(addr/4) & byte_mask;
                }
                top->data_rvalid_i = 1;
                top->data_gnt_i = 0;
                ftick();
                top->data_rvalid_i = 0;
                ftick();

            }
            if(i ==  cycles-1) {
                ofs << "Add more cycles" << endl;
                break;
            }

        }
    } catch (const std::out_of_range& e) {
         ofs << "Out of range: " << e.what() << endl;
    } catch (const std::runtime_error& e) {
        ofs << "Runtime error: " << e.what() << endl;
    }
    ftick();
    top->final(); 

    delete top;
    top = nullptr;
    delete contextp;
    contextp = nullptr;
    
    begin_signature -= data_block.p_vaddr;
    end_signature -= data_block.p_vaddr;
    assert((end_signature-begin_signature)%4==0);
    assert(begin_signature%4==0);
    int steps = (end_signature-begin_signature)/4;
    int start = begin_signature/4;
    for(int i=0;i<steps;i++) {
        ofs << hex << setw(8) << setfill('0') << data_bytes.at(start+i) << '\n';
    }

    ofs.close();
    return 0;
}
