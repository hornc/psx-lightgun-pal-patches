#!/bin/bash
set -e
origfile=$1  # PSX EXE!
outfile=${origfile}_mod
origsha="76322eeade5ebb22dca57fdeac7d68c30f06308d"

source ../scripts/common.sh

echo Using asm in src/ to patch $origfile to $outfile
echo "$origsha  $origfile" | shasum --check  # en translation of LSD - Dream Emulator (Japan) SLPS_015.56

apply_patch_src $origfile $outfile


echo Inject modifed PS-X EXE back into .bin:
psxinject "LSD - Dream Emulator (Japan).bin" $origfile $outfile
