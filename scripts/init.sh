#!/bin/bash

echo Attempting to initialise a new PSX patch directory in $PWD


if ! command -v psxrip &> /dev/null; then
  echo "Error: 'psxrip' (from https://github.com/cebix/psximager) is not installed or not in PATH." >&2
  exit 1
fi

# Get .BIN / .CUE
shopt -s nullglob extglob
bin_files=(!(*_mod)@(.bin|.BIN))
cue_files=(!(*_mod)@(.cue|.CUE))
shopt -u nullglob extglob

# Check exactly one of each un-modded:
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


# Dump BIN filesystem:
TMP_DIR="$(mktemp -d -t psxrip_XXXXXX)"

cleanup() {
  rm -rf -- "$TMP_DIR"
  rm -f  -- "$TMP_DIR".cat
  rm -f  -- "$TMP_DIR".sys
}
trap cleanup EXIT

# Extract all files from BIN to locate the .EXE
psxrip "$cue_path" $TMP_DIR


# Get main PS-X EXE:
psxexe=$(fgrep "BOOT =" "$TMP_DIR/SYSTEM.CNF" | sed "s/BOOT[^\\]*.\([^;]\+\).*/\1/")
echo -e "\nPSX-EXE found: $psxexe"
cp "$TMP_DIR/$psxexe" .
shasum=$(shasum $psxexe)
# extract offsets from PS-X EXE
read exe_offset load_offset <<<$(xxd -e -s16 -l12 $psxexe | cut -f2,4 -d' ')
region=$(tail -c+114 $psxexe | head -c20 | tr -d '\0')
echo REGION: $region
echo LOAD: $load_offset EXE: $exe_offset
echo SHASUM: $shasum


# Create sub-project .gitignore:
if [[ ! -f .gitignore ]]; then
  echo $psxexe >> .gitignore
fi


# Create src dir, if not present
if [[ ! -d src ]]; then
  mkdir -p src
  patch_file="src/00_patch.s"

  cat << 'EOF' > "$patch_file"
.org 0x????
.set noreorder
.set noat

EOF
  echo "Created src/ dir and template: $patch_file"
fi


# Copy original .BIN/.CUE to _mod versions for modification and comparison
echo Creating ${base}_mod.bin and ${base}_mod.cue ...
sed "s/${bin_path}/${base}_mod.bin/" "$cue_path" > "${base}_mod.cue"
cp "$bin_path" "${base}_mod.bin"


echo Creating patcher.sh ...
cat << EOF > "patcher.sh"
#!/bin/bash
set -e
origexe="$psxexe"
outexe=\${origexe}_mod
origsha="$(cut -f1 -d' ' <<< $shasum)"

source ../scripts/common.sh

apply_patch_src \$origexe \$outexe \$origsha

echo Inject modifed PS-X EXE back into .bin:
psxinject "${base}_mod.bin" \$origexe \$outexe
EOF
chmod +x patcher.sh

