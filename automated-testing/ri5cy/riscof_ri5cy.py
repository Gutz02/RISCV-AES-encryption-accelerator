import os
import re
import shutil
import subprocess
import shlex
import logging
import random
import string
from string import Template
import sys

import riscof.utils as utils
import riscof.constants as constants
from riscof.pluginTemplate import pluginTemplate

logger = logging.getLogger()

class ri5cy(pluginTemplate):
    __model__ = "ri5cy"

    #TODO: please update the below to indicate family, version, etc of your DUT.
    __version__ = "XXX"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        config = kwargs.get('config')

        # If the config node for this DUT is missing or empty. Raise an error. At minimum we need
        # the paths to the ispec and pspec files
        if config is None:
            print("Please enter input file paths in configuration.")
            raise SystemExit(1)

        # In case of an RTL based DUT, this would be point to the final binary executable of your
        # test-bench produced by a simulator (like verilator, vcs, incisive, etc). In case of an iss or
        # emulator, this variable could point to where the iss binary is located. If 'PATH variable
        # is missing in the config.ini we can hardcode the alternate here.
        self.dut_exe =  os.path.abspath("../obj_dir/Vriscv_ooc_top_level_wrapper")#os.path.join(config['PATH'] if 'PATH' in config else "","ri5cy")

        # Number of parallel jobs that can be spawned off by RISCOF
        # for various actions performed in later functions, specifically to run the tests in
        # parallel on the DUT executable. Can also be used in the build function if required.
        self.num_jobs = "10"#str(config['jobs'] if 'jobs' in config else 1)

        # Path to the directory where this python file is located. Collect it from the config.ini
        self.pluginpath=os.path.abspath(config['pluginpath'])

        # Collect the paths to the  riscv-config absed ISA and platform yaml files. One can choose
        # to hardcode these here itself instead of picking it from the config.ini file.
        self.isa_spec = os.path.abspath(config['ispec'])
        self.platform_spec = os.path.abspath(config['pspec'])

        #We capture if the user would like the run the tests on the target or
        #not. If you are interested in just compiling the tests and not running
        #them on the target, then following variable should be set to False
        if 'target_run' in config and config['target_run']=='0':
            self.target_run = False
        else:
            self.target_run = True

    def initialise(self, suite, work_dir, archtest_env):

       # capture the working directory. Any artifacts that the DUT creates should be placed in this
       # directory. Other artifacts from the framework and the Reference plugin will also be placed
       # here itself.
       self.work_dir = work_dir

       # capture the architectural test-suite directory.
       self.suite_dir = suite

       # Note the march is not hardwired here, because it will change for each
       # test. Similarly the output elf name and compile macros will be assigned later in the
       # runTests function
       self.compile_cmd = 'riscv{1}-unknown-elf-gcc -march={0} \
         -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -g\
         -T '+self.pluginpath+'/env/link.ld\
         -I '+self.pluginpath+'/env/\
         -I ' + archtest_env + ' {2} -o {3} {4}'

       # add more utility snippets here

    def build(self, isa_yaml, platform_yaml):

      # load the isa yaml as a dictionary in python.
      ispec = utils.load_yaml(isa_yaml)['hart0']

      # capture the XLEN value by picking the max value in 'supported_xlen' field of isa yaml. This
      # will be useful in setting integer value in the compiler string (if not already hardcoded);
      self.xlen = ('64' if 64 in ispec['supported_xlen'] else '32')

      # for ri5cy start building the '--isa' argument. the self.isa is dutnmae specific and may not be
      # useful for all DUTs
      self.isa = 'rv' + self.xlen
      self.isa += "imc_zkne"
      #if "I" in ispec["ISA"]:
      #    self.isa += 'i'
      #if "M" in ispec["ISA"]:
      #    self.isa += 'm'
      #if "F" in ispec["ISA"]:
      #    self.isa += 'f'
      #if "D" in ispec["ISA"]:
      #    self.isa += 'd'
      #if "C" in ispec["ISA"]:
      #    self.isa += 'c'

      #TODO: The following assumes you are using the riscv-gcc toolchain. If
      #      not please change appropriately
      self.compile_cmd = self.compile_cmd+' -mabi='+('lp64 ' if 64 in ispec['supported_xlen'] else 'ilp32 ')

    def runTests(self, testList):

      # Delete Makefile if it already exists.
      if os.path.exists(self.work_dir+ "/Makefile." + self.name[:-1]):
            os.remove(self.work_dir+ "/Makefile." + self.name[:-1])
      # create an instance the makeUtil class that we will use to create targets.
      make = utils.makeUtil(makefilePath=os.path.join(self.work_dir, "Makefile." + self.name[:-1]))

      # set the make command that will be used. The num_jobs parameter was set in the __init__
      # function earlier
      make.makeCommand = 'make -k -j' + self.num_jobs



      for testname in testList:
          testentry = testList[testname]
          test = testentry['test_path']
          test_dir = testentry['work_dir']
          elf = 'my.elf'
          sig_file = os.path.join(test_dir, self.name[:-1] + ".signature")
          compile_macros= ' -D' + " -D".join(testentry['macros'])
          cmd = self.compile_cmd.format(testentry['isa'].lower(), self.xlen, test, elf, compile_macros)
          execute = '@cd {0}; {1};'.format(testentry['work_dir'], cmd)
          make.add_target(execute)

      make.execute_all(self.work_dir)


      make = utils.makeUtil(makefilePath=os.path.join(self.work_dir, "Makefile.c" + self.name[:-1]))
      make.makeCommand = 'make -k -j' + self.num_jobs

      for testname in testList:
          testentry = testList[testname]
          test_dir = testentry['work_dir']
          elf = 'my.elf'
          sig_file = os.path.join(test_dir, self.name[:-1] + ".signature")

          if self.target_run:
            simcmd = self.dut_exe + ' +signature={1} +signature-granularity=4 {2}'.format(self.isa, sig_file, elf)
          else:
            simcmd = 'echo "NO RUN"'

          objd = ["riscv32-unknown-elf-objdump", "", "{0}/{1}".format(testentry['work_dir'], elf)]
          objd[1] = "-h"
          headers = subprocess.run(objd, capture_output=True, text=True)
          objd[1] = "-t"
          symbols = subprocess.run(objd, capture_output=True, text=True)
          pattern = r"tohost\s*[0-9a-fA-F]+\s*([0-9a-fA-F]+)"
          match = re.search(pattern, headers.stdout)
          assert match
          tohost = match.group(1)
          match = re.search(r"([0-9a-fA-F]+) g\s*\.data\s*\d+ begin_signature", symbols.stdout)
          assert match
          begin_signature = match.group(1)
          match = re.search(r"([0-9a-fA-F]+) g\s*.data\s*\d+ end_signature", symbols.stdout)
          assert match
          end_signature = match.group(1)

          execute = '@cd {0}; {1} -tohost={2} -begin_signature={3} -end_signature={4};'.format(testentry['work_dir'], simcmd, tohost, begin_signature, end_signature)

          make.add_target(execute)

      make.execute_all(self.work_dir)


      # if you would like to exit the framework once the makefile generation is complete uncomment the
      # following line. Note this will prevent any signature checking or report generation.
      #raise SystemExit

      # once the make-targets are done and the makefile has been created, run all the targets in
      # parallel using the make command set above.
      make.execute_all(self.work_dir)

      # if target runs are not required then we simply exit as this point after running all
      # the makefile targets.
      if not self.target_run:
          raise SystemExit(0)

