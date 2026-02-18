# Compliance Development Environment Image
FROM ubuntu:24.04

COPY ./riscv_bins/ /opt/riscv

# SET ENVIRONMENT VARIABLES
# This allows the user to actualy invoke all of the commands that we compile in this docker image, and tells the build processes where they can find the riscv toolchain.
ENV RISCV=/opt/riscv
ENV PATH=$PATH:$RISCV/bin


# UPDATE / UPGRADE
# This step ensures that the docker image is fully up to date and is ready for dependency installation.
RUN apt-get update 
RUN apt-get install -y python3 python3-pip git device-tree-compiler


RUN git clone https://github.com/riscv-software-src/riscv-isa-sim.git
WORKDIR riscv-isa-sim
RUN mkdir build
WORKDIR build
RUN ../configure 
RUN make -j 10
RUN make install
#RUN apt-get install -y verilator
#
### RISCOF
RUN pip install git+https://github.com/riscv/riscof.git@d38859f --break-system-packages
RUN pip uninstall --yes  riscv_isac --break-system-packages
RUN pip install  git+https://github.com/riscv-software-src/riscv-isac@dev --break-system-packages
WORKDIR /

ENTRYPOINT ["/bin/bash"]


