# common.sh - Shared PSX patcher functions
# Usage: source ../scripts/common.sh


require_target() {
  local target="${1:-}"

  if [[ -z "$target" ]]; then
    echo "Error: Missing required target (original) PSX-EXE argument." >&2
    echo "Usage: $0 <path/to/original_PSX-EXE>" >&2
    return 1
  fi

  if [[ ! -f "$target" ]]; then
    echo "Error: Target PSX-EXE '$target' does not exist or is not a regular file." >&2
    return 1
  fi
  return 0
}


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


apply_patch_src() {
  local origfile="$1"
  local outfile="$2"
  local origsha="$3"

  echo Using asm in src/ to patch $origfile to $outfile
  echo "$origsha  $origfile" | shasum --check

  cp $origfile $outfile

  echo Files:
  ls -1 src/*.s | sed 's/^/    /'
  echo

  for src in src/*.s; do
    inject_asm $src $outfile
  done

  echo Output file: $outfile
}
