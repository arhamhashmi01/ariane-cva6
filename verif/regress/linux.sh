# Copyright 2021 Thales DIS design services SAS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Jean-Roch COULON - Thales

# where are the tools
if ! [ -n "$RISCV" ]; then
  echo "Error: RISCV variable undefined"
  return
fi

if ! [ -n "$BBL_ROOT" ]; then
  echo "Error: BBL_ROOT variable undefined"
  echo "BBL_ROOT is the path to access bbl.o"
  echo "bbl.o is generated by using https://github.com/pulp-platform/ariane-sdk.git"
  return 1
fi

# setup sim env
source verif/sim/setup-env.sh

if ! [ -n "$DV_SIMULATORS" ]; then
  DV_SIMULATORS=veri-testharness
fi

cd verif/sim
cp $BBL_ROOT/bbl bbl.o
python3 cva6.py --target cv64a6_imafdc_sv39 --iss=$DV_SIMULATORS --iss_yaml=cva6.yaml --elf_tests bbl.o\
  --issrun_opts="+time_out=40000000 +debug_disable=1" --isspostrun_opts="ffffffe0005e5cd4"
cd -
