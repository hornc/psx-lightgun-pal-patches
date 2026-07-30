# Elemental Gearbolt

Patches this NTSC only game for PAL consoles,
and adjusts the lightgun geometry for Justifier and GunGon controllers.

| Game                                                                   | Publisher/Dev                                                       | Date | Justifier |  GunCon | Players | NTSC | PAL | Regions |
| :---                                                                   | :---                                                                | :--- | :---:     | :---:   | :---:   | :---:|:---:| :---:   |
| [Elemental Gearbolt](https://en.wikipedia.org/wiki/Elemental_Gearbolt) | Working Designs / [Alfa](https://en.wikipedia.org/wiki/Alfa_System) | 1997 | X         |  X      | 2       | X    | -   | Jp,Na   |

### Mod Features
| PAL  | Y-Centred | Justifer | GunCon |
| :---:| :---:     | :---:    | :---:  |
| X    | X         | X        | X      |

### Testing
| Mednafen | Duckstation | PAL PSX, Justifer | PAL PSX, GunCon |
| :---:    | :---:       | :---:             | :---:           |
| X        | -           | X                 | -               |



## Instructions
### Check / prepare source data
1. Copy or extract `SLUS_006.54` from the game disc / BIN

USA NTSC version PS-X EXE target:
```bash
shasum SLUS_006.54
37f984b09f10f47e4788af71839ecbabd91da4b3  SLUS_006.54
```

### Compile and insert patch fragments in `src/` (using [custom llvm compiler and patcher script](patcher.sh)):
```bash
./patcher.sh
```

This will patch the original PS-X EXE `SLUS_006.54` to `SLUS_006.54_mod`

This script also uses `psxinject` from [psximager](https://github.com/cebix/psximager) to re-insert the modified PS-X EXE back into a copy of the CD Mode2 bin file.

### Run the modified BIN/CUE using an emulator (Mednafen):
```bash
mednafen "Elemental Gearbolt (USA)_mod.cue"
```

Alternatively, burn the BIN/CUE to disc and run on a PAL model PSX.


### Generate the .ppf patch from the result
```bash
makeppf3 c "Elemental Gearbolt (USA).bin" "Elemental Gearbolt (USA)_mod.bin" "patch/Gearbolt_PAL_Lightgun_Mod.ppf"
```
