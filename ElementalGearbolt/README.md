# Elemental Gearbolt

Patches this NTSC only game for PAL consoles,
and adjusts the lightgun geometry for Justifier and GunGon controllers.


### Check / prepare source data
1. Copy or extract `SLUS_006.54` from the game disc / BIN

USA NTSC version PS-X EXE target:
```bash
shasum slus_006.54
37f984b09f10f47e4788af71839ecbabd91da4b3  slus_006.54
```


### Compile the patch fragments
```bash
llvm-mc -filetype=obj -triple=mipsel-sony-psx src/palmod.s -mcpu=mips1 -o palmod.o
llvm-objdump -d palmod.o
```


### Insert the binary payload into the EXE



### Use `psxinject` to re-insert the modified PS-X EXE back into the CD Mode2 bin file:
```bash
./psxinject "Elemental Gearbolt (USA)_palmod.bin" SLUS_006.54 slus_006.54
```


### Run the modified BIN/CUE using an emulator (Mednafen):
```bash
mednafen Elemental\ Gearbolt\ \(USA\)_palmod.cue
```

Alternatively, burn the BIN/CUE to disc and run on a PAL model PSX.


### Generate the .ppf patch from the result
```bash
makeppf3 c "Elemental Gearbolt (USA).bin" "Elemental Gearbolt (USA)_palmod.bin" "patch/Gearbolt_PAL_Lightgun_Fix.ppf"
```
