#!/bin/bash
set -e
origexe="SLUS_006.54"
outexe=${origexe}_mod
origsha="37f984b09f10f47e4788af71839ecbabd91da4b3"

source ../scripts/common.sh

apply_patch_src $origexe $outexe $origsha

echo Inject modifed PS-X EXE back into .bin:
psxinject "Elemental Gearbolt (USA)_mod.bin" $origexe $outexe
