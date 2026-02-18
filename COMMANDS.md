myriscof1 
Build:
```bash
verilator -j 10  -Wno-WIDTH -Wno-UNUSED -Wno-LATCH -Wno-UNOPTFLAT -Wno-CASEINCOMPLETE -Wno-LITENDIAN -Wno-TIMESCALEMOD  -cc -DVL_TIME_CONTEXT  --build --exe -f filelist.f --top-module riscv_ooc_top_level_wrapper automated-testing/sim_main.cpp 
```
DOcker
```bash
docker run -it -v $(pwd):/mnt --workdir /mnt/automated-testing magisterbrownie/myriscof:latest
```
Run:
```bash
git config --global --add safe.directory /mnt
riscof -v debug run  --config=config.ini --suite=./arch-tests/ --env=./arch-tests/env 
```

Copy meme block:
```bash
cp software/bin_files/* hardware/src/sw/mem_files/
```
