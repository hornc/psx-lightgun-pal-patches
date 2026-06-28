.org 0x0c04
.set noreorder
.set noat
# Write data to force PAL mode to 0x8005_12e8:
lui $at, 0x8005
li  $t1, 0x01
sb  $t1, 0x12e8($at)
# GunCon / base X/Y in memcard adjust:
lui $at, 0x8002
li  $t0, 0x24092207  # "addiu	$t1, $0, 0x2207"
sw  $t0, 0x7a8c($at)
li  $t1, 0xa429      # change sb to sh, and r0 to t1
sh  $t1, 0x7a92($at)
sw  $0, 0x7a98($at)  # clear sb $r0 -> ..f5
# Justifier X/Y adjust:
# Justifier X: 0x8005_29e4, set via hw at 0x8002_57e8
# Justifier Y: 0x8005_29ec, set via hw at 0x8002_57f0
li  $t0, 0xfff4
li  $t1, 0xffe0
sh  $t0, 0x57e8($at)
sh  $t1, 0x57f0($at)
# Justifier only offset fix:
#li  $t1, 0xffc0
#sh  $t1, 0x57f0($at)
# FlushCache() because we modified in mem instructions:
li  $t0, 0xa0
li  $t1, 0x44
jr  $t0  # $ra is already set from the code we hijacked
nop
