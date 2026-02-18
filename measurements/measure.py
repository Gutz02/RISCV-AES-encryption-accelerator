from pynq import Overlay
from pynq import PL
from pynq import MMIO
import pynq
import time
import numpy as np

# Set constants before running this file:
BASE_PATH = "/home/xilinx/arturs_folder"


zynq_system = Overlay(f"{BASE_PATH}/overlays/base_riscy.bit", download=False)

ins_mem       = MMIO(0x40000000, 0x8000)
data_mem      = MMIO(0x42000000, 0x8000)
riscv_control = MMIO(0x40008000, 0x1000)
reg_bank      = MMIO(0x40009000, 0x1000)
xadc          = MMIO(0x40010000, 0x1000)

#Register Bank Addresses:
end_of_test_addr = 0x0 #only bit 0 out of 32.
exec_clk_cycles = 0x4

#Data mem addresses:
end_seq_addr = 0x2000
c_result_check_addr = 0x2004
expected_result_addr = 0x2030
calculated_result_addr = 0x2040

def parse_coe_file(file_path):
    data_values = []
    with open(file_path, 'r') as file:
        lines = file.readlines()
        start_parsing = False
        
        for line in lines:
            line = line.strip()
            
            if start_parsing:
                values = line.split(',')
                data_values.extend([v.strip() for v in values if v.strip()])
            
            if "memory_initialization_vector=" in line:
                start_parsing = True
                line = line.split("=")[1]  # Get the values after '='
                values = line.split(',')
                data_values.extend([v.strip() for v in values if v.strip()])
                print(data_values)
    
    return data_values

def parse_and_process_file(filename, write_func):
    data_values = parse_coe_file(filename)
    count = 0
    offset = 0x0
    
    #print(f"Length of memory file: {len(data_values)} x 32-bits")
    while count < len(data_values):
        write_func(offset, int(data_values[count], 16))
        #print(f"Write {hex(offset)}: {hex(int(data_values[count], 16))}")
        offset += 0x4
        count += 1


if __name__ == "__main__":
    zynq_system.download()
    
    #reboot
    data = riscv_control.read(0x10)
    print(f"Read: {hex(data)}")
    riscv_control.write(0x10, 0x00000001)
    data = riscv_control.read(0x10)
    print(f"Read: {hex(data)}")
    riscv_control.write(0x10, 0x00000000)
    data = riscv_control.read(0x10)
    print(f"Read: {hex(data)}")
    
    mcs = pynq.ps.Clocks
    mcs.set_pl_clk(0,clk_mhz=90)
    
    parse_and_process_file(f"{BASE_PATH}/mem_files/code.coe", ins_mem.write_reg)
    parse_and_process_file(f"{BASE_PATH}/mem_files/data.coe", data_mem.write_reg)
    
    # Start execution
    
    data = riscv_control.read(0x10)
    print(f"Read: {hex(data)}")
    riscv_control.write(0x10, 0x0000_0010)
    data = riscv_control.read(0x10)
    print(f"Read: {hex(data)}")
    
    def decode(temp):
        return (temp*503.975)/4096-273.15
    
    throughput = 0
    print(f"Current clock {mcs.get_pl_clk(0)}")
    print("Divider 0: {}".format(mcs.PL_CLK_CTRLS[0][mcs.PL_CLK_ODIV0_FIELD]))
    print("Divider 1: {}".format(mcs.PL_CLK_CTRLS[0][mcs.PL_CLK_ODIV1_FIELD]))
    n = 400
    temps = np.zeros(n)
    old_max = 0
    max_temp = 0
    start = time.time()
    for i in range(n):
        time.sleep(0.1)
        data = data_mem.read(calculated_result_addr)
        if(data == 0xbaaaaaab):
            print(f"{hex(data)}")
            break
        throughput = data/(time.time()-start)
        temp = xadc.read(0x200)>>4
        max_temp = xadc.read(0x280)>>4
        if(max_temp>old_max):
            print(decode(max_temp))
        old_max = max_temp
        temps[i] = temp
    
    #print(temps)
    print(f"Final throughput: {throughput*16} bytes/s")
    print(f"Max temp: {decode(max_temp)}")
    print(f"AVG temp: {decode(temps.mean())}")


