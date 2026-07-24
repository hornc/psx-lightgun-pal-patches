#!/bin/bash

echo Attempting to initialise a new PSX patch directory in $PWD


if ! command -v psxrip &> /dev/null; then
  echo "Error: 'psxrip' (from https://github.com/cebix/psximager) is not installed or not in PATH." >&2
  exit 1
fi

# Get .BIN / .CUE
shopt -s nullglob
bin_files=(*.bin *.BIN)
cue_files=(*.cue *.CUE)
shopt -u nullglob

# Check exactly one of each:
for ext in bin cue; do
  declare -n files="${ext}_files"
  if [[ ${#files[@]} -ne 1 ]]; then
    echo "Error: Expected exactly 1 .${ext} file, found ${#files[@]}." >&2
    exit 1
  fi
done

bin_path="${bin_files[0]}"
cue_path="${cue_files[0]}"
base="${cue_path%.*}"

echo BASE: $base

TMP_DIR="$(mktemp -d -t psxrip_XXXXXX)"

cleanup() {
  rm -rf -- "$TMP_DIR"
  rm -f  -- "$TMP_DIR".cat
  rm -f  -- "$TMP_DIR".sys
}
trap cleanup EXIT

# Extract all files from BIN to locate the .EXE
psxrip "$cue_path" $TMP_DIR

psxexe=$(fgrep "BOOT =" "$TMP_DIR/SYSTEM.CNF" | sed "s/BOOT[^\\]*.\([^;]\+\).*/\1/")
echo PSX-EXE found: $psxexe
cp "$TMP_DIR/$psxexe" .
shasum=$(shasum $psxexe)
echo SHASUM: $shasum

# Create sub-project .gitignore:
echo $psxexe >> .gitignore

mkdir -p src
patch_file="src/00_patch.s"

# Create patch template
if [[ ! -f "$patch_file" ]]; then
  cat << 'EOF' > "$patch_file"
.org 0x????
.set noreorder
.set noat

EOF
  echo "Created template: $patch_file"
fi

# Probably don't want to do this; just work off the orignal BIN/CUE?
#sed "s/${bin_path}/${base}_mod.bin/" "$cue_path" > "${base}_mod.cue"
#cp "$bin_path" "${base}_mod.bin"

# TODO:
# create patcher.sh boilerplate ...

