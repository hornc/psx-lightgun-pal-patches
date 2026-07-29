.org 0x0c04
.set noreorder
.set noat
# Write data to force PAL mode by blanking
# the check at 8003_fc00
lui $at, 0x8004
sw  $0, -0x400($at)
# FlushCache() because we modified in mem instructions:
li  $t0, 0xa0
li  $t1, 0x44
jr  $t0  # $ra is already set from the code we hijacked
nop
