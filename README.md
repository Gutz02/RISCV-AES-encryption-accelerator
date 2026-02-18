# RISC-V AES Encryption Accelerator (Zkne) — ri5cy / RISCY Core

Course project (TU Delft CESE4040) that accelerates AES-128 by integrating the RISC-V **Zkne** cryptography extension into a lightweight **2-stage in-order RISCY/ri5cy** core and pairing it with compiler-level optimizations.

## What we built
- Added a unified **AES hardware unit (ZKN execution unit)** to execute **aes32esi / aes32esmi** in a single-cycle datapath, sharing S-box + ShiftRows + XOR and enabling MixColumns only when needed (area saving). 
- Updated the core **decode / datapath** to correctly fetch, decode, and route the new AES instructions to the ZKN unit.
- Implemented a small **128B direct-mapped write-through data cache** to reduce repeated key/state memory latency (1-cycle tag check overhead).
- Evaluated throughput, power, and energy/byte on FPGA; achieved up to **47.2× throughput** at **90 MHz** for the chosen HW+compiler configuration.

## My contributions (Dario)
- **Compiler/LLVM pipeline for AES**:
  - Wrote C/inline-ASM macros to emit **aes32esmi/aes32esi** and configured **clang** target + `-march=rv32gczkne`.
  - Used LLVM `opt` passes (**mem2reg, loop-unroll, simplifycfg**) to remove loop-carried dependencies and produce long straight-line AES instruction sequences.
    <img width="947" height="302" alt="image" src="https://github.com/user-attachments/assets/4f82f596-9b1a-49ee-8ff0-291814f42241" />
      Instruction count for occurrence in different files, each optimized with a different transformation flag. Main.c would correspond to the initial provided code with no aes32 instruction, while the other     correspond to MAIN HW AES.C
    <img width="703" height="279" alt="image" src="https://github.com/user-attachments/assets/50865455-4dc9-4ab0-a7f6-37f4d5e88023" />
      For visualization purposes, the y axis has been set to a logarithmic scale. Loads to memory would correspond to the misses due to cache, ergo the loads that go through to memory.
- **Hardware integration support**:
  - Helped with the **decoder/front-end updates** required to route Zkne AES ops to the new ZKN unit.

## Results (from the report)
- Throughput: baseline software AES vs HW AES + loop unroll + cache reached **39.5 kb/s** at **90 MHz** (8.4 kb/s baseline), i.e., **47.2×** improvement.
- Energy per byte (90 MHz): reported using Vivado+SAIF power estimates and cycle counts.
    <img width="725" height="376" alt="image" src="https://github.com/user-attachments/assets/17c34e68-0b39-4e29-908a-35ffb9362298" />
      Total joules per aes encryption, with a logarithmic scale where O2 and O3 optimization was found to have the lowest energy consumption.

## Notes
- Power/energy numbers are **estimate-based** (Vivado + SAIF) rather than direct board power measurement.
