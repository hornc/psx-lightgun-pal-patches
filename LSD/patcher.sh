#!/bin/bash
set -e
origfile="SLPS_015.56"  # PS-X EXE
outfile=${origfile}_mod
origsha="76322eeade5ebb22dca57fdeac7d68c30f06308d"

source ../scripts/common.sh

apply_patch_src $origfile $outfile $origsha

echo Inject modifed PS-X EXE back into .bin:
psxinject "LSD - Dream Emulator (Japan).bin" $origfile $outfile
