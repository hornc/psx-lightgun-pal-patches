.org 0x0c04
.set noreorder
.set noat
# Write data to force PAL mode by blanking
# the check at 8003_fc00
lui $at, 0x8004
sw  $0, -0x400($at)
# Set Justifier Y-offset
# hw at 0x8008_aac4 = 0xYYXX
# for un-shifted screen, y offset = 0x42
lui $at, 0x8009
li  $t1, 0x4200
sh  $t1, -0x553c($at)
# FlushCache() because we modified in mem instructions:
li  $t0, 0xa0
li  $t1, 0x44
jr  $t0  # $ra is already set from the code we hijacked
nop      # FlushCache() will return to the main program
