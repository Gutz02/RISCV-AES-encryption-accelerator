# RISC-V AES Encryption Accelerator (Zkne) — ri5cy / RISCY Core

Course project (TU Delft CESE4040) that accelerates AES-128 by integrating the RISC-V **Zkne** cryptography extension into a lightweight **2-stage in-order RISCY/ri5cy** core and pairing it with compiler-level optimizations. :contentReference[oaicite:0]{index=0}

## What we built
- Added a unified **AES hardware unit (ZKN execution unit)** to execute **aes32esi / aes32esmi** in a single-cycle datapath, sharing S-box + ShiftRows + XOR and enabling MixColumns only when needed (area saving). :contentReference[oaicite:1]{index=1}
- Updated the core **decode / datapath** to correctly fetch, decode, and route the new AES instructions to the ZKN unit. :contentReference[oaicite:2]{index=2}
- Implemented a small **128B direct-mapped write-through data cache** to reduce repeated key/state memory latency (1-cycle tag check overhead). :contentReference[oaicite:3]{index=3}
- Evaluated throughput, power, and energy/byte on FPGA; achieved up to **47.2× throughput** at **90 MHz** for the chosen HW+compiler configuration. :contentReference[oaicite:4]{index=4}

## My contributions (Dario)
- **Compiler/LLVM pipeline for AES**:
  - Wrote C/inline-ASM macros to emit **aes32esmi/aes32esi** and configured **clang** target + `-march=rv32gczkne`. :contentReference[oaicite:5]{index=5}
  - Used LLVM `opt` passes (**mem2reg, loop-unroll, simplifycfg**) to remove loop-carried dependencies and produce long straight-line AES instruction sequences. :contentReference[oaicite:6]{index=6}
- **Hardware integration support**:
  - Helped with the **decoder/front-end updates** required to route Zkne AES ops to the new ZKN unit. :contentReference[oaicite:7]{index=7} :contentReference[oaicite:8]{index=8}

## Results (from the report)
- Throughput: baseline software AES vs HW AES + loop unroll + cache reached **39.5 kb/s** at **90 MHz** (8.4 kb/s baseline), i.e., **47.2×** improvement. :contentReference[oaicite:9]{index=9}
- Energy per byte (90 MHz): reported using Vivado+SAIF power estimates and cycle counts. :contentReference[oaicite:10]{index=10}

## Verification
- Regression testing with **RISCOF** against a golden model (Spike), with RTL simulation via **Verilator** and automated CI reporting. :contentReference[oaicite:11]{index=11}

## Notes
- Power/energy numbers are **estimate-based** (Vivado + SAIF) rather than direct board power measurement. :contentReference[oaicite:12]{index=12}
