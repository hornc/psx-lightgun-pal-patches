#!/bin/bash
set -e
origexe="SCUS_944.08"
outexe=${origexe}_mod
origsha="8dba0a14f401e9553ffb4d82faaa7c6b65f19ed9"

source ../scripts/common.sh

apply_patch_src $origexe $outexe $origsha

echo Inject modifed PS-X EXE back into .bin:
psxinject "Project - Horned Owl (USA)_mod.bin" $origexe $outexe
