# LSD: Dream Emulator

This is _not_ a light-gun game, but I've used the same patching tool chain to make an NTSC -> PAL mod.

This patches the English fan-translation to PAL.
The translation patch is expected to be applied first.

The same patch will likely work on the Japanese version, but this is untested. The shasum will have to be changed for `patcher.sh` to make the changes.

### Patch Status: DONE (alpha)

| Game                                                                     | Publisher/Dev                         | Date | Players | NTSC | PAL | Regions             |
| :---                                                                     | :---                                  | :--- | :---:   | :--: |:---:| :---:               |
| [LSD: Dream Emulator](https://en.wikipedia.org/wiki/LSD:_Dream_Emulator) | Asmik Ace / OutSide Directors Company | 1998 | 1       | ✔    | ✖   | Jp, Fan translation |

### Mod Features
| PAL  | Y-Centred |
| :---:| :---:     |
| ✔    | ✔         |

### Testing
| Mednafen | Duckstation | PAL PSX |
| :---:    | :---:       | :---:   |
| ✔        | ✔           | ✔       |
