#!/bin/bash
set -e
origexe="SLPS_015.56"
outexe=${origexe}_mod
origsha="76322eeade5ebb22dca57fdeac7d68c30f06308d"

source ../scripts/common.sh

apply_patch_src $origexe $outexe $origsha

echo Inject modifed PS-X EXE back into .bin:
psxinject "LSD - Dream Emulator (Japan)_mod.bin" $origexe $outexe
