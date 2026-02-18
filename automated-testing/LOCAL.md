# Local commands 
Local commands required for setup.
Generate test files:
```bash
riscv_ctg -v debug -d ./arch-tests -r -cf dataset.cgf -cf rv32i.cgf -bi rv32i -p2
```

Generate a new design under test with spike:
```bash
riscof setup --dutname=spike
```
