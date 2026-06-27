#!/bin/bash
set -e
origfile=$1
outfile=${origfile}_mod


inject_asm() {
  local ASM="$1"
  local EXE_PATH="$2"
  OFFSET_HEX=$(sed -En '/\.org\s+(0x[0-9a-fA-F]+)/{s//\1/p;q}' $ASM)
  TMP_OBJ=tmp_patch.o
  TMP_BIN=tmp_patch.bin

  echo Compilng $ASM to $TMP_OBJ
  llvm-mc -filetype=obj -triple=mipsel-sony-psx -mcpu=mips1 <(sed -E '/^\s*\.org/d' $ASM) -o $TMP_OBJ

  echo Extracting bytes to $TMP_BIN
  #llvm-objdump -d "$TMP_OBJ" | \
  #  sed -n 's/^.*: \(\([0-9a-f]\{2\} \)\{4\}\).*/\1/p' | \
  #  xxd -r -p > "$TMP_BIN"
  # Above version has unnecessary conversion steps, but was useful for manual hex editing...

  llvm-objcopy -O binary --only-section=.text "$TMP_OBJ" "$TMP_BIN"

  echo Patching $EXE_PATH
  dd if="$TMP_BIN" of="$EXE_PATH" bs=1 seek=$(($OFFSET_HEX)) conv=notrunc status=noxfer
  echo
  rm "$TMP_OBJ" "$TMP_BIN"
}


echo Using asm in src/ to patch $origfile to $outfile
echo "37f984b09f10f47e4788af71839ecbabd91da4b3  $origfile" | shasum --check  # US Elemental Gearbolt PS-X EXE

cp $origfile $outfile

echo Files:
ls src/*.s
echo

for src in src/*.s; do
  inject_asm $src $outfile
done

echo Output file: $outfile
