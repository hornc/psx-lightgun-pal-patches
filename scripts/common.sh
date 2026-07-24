# common.sh - Shared PSX patcher functions
# Usage: source ../scripts/common.sh

inject_asm() {
  local ASM="$1"
  local EXE_PATH="$2"
  OFFSET_HEX=$(sed -En '/\.org\s+(0x[0-9a-fA-F]+)/{s//\1/p;q}' $ASM)
  TMP_OBJ=tmp_patch.o
  TMP_BIN=tmp_patch.bin

  echo Compilng $ASM to $TMP_OBJ
  llvm-mc -filetype=obj -triple=mipsel-sony-psx -mcpu=mips1 <(sed -E '/^\s*\.org/d' $ASM) -o $TMP_OBJ

  echo Extracting bytes to $TMP_BIN

  llvm-objcopy -O binary --only-section=.text "$TMP_OBJ" "$TMP_BIN"

  echo Patching $EXE_PATH
  dd if="$TMP_BIN" of="$EXE_PATH" bs=1 seek=$(($OFFSET_HEX)) conv=notrunc status=noxfer
  echo
  rm "$TMP_OBJ" "$TMP_BIN"
}
