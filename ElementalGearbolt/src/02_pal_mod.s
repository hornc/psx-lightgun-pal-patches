.org 0x0c04
.set noreorder
.set noat
.set MANUAL_YSCREEN, 0

# Write data to force PAL mode to 0x8005_12e8:
lui $at, 0x8005
li  $t1, 0x01
sb  $t1, 0x12e8($at)

.if MANUAL_YSCREEN
    # Adjust GP1(0x07) further, if needed.
    # defaults to y1: 43, y2: 283 in PAL
    #             y1: 16, y2: 256 in NTSC
    lui $at, 0x8003
    li  $t0, 0x26420007   # "addiu $v0, $s2, 0x7", inc. y1 by 7
    li  $t1, 0x26240007   # "addiu $a0, $s1, 0x7", inc. y2 by 7
    sw  $t0, -0xf68($at)  # -> 0x8002_f098
    sw  $t1, -0xf60($at)  # -> 0x8002_f0a0
.endif

# GunCon Adjust:
# base Y:00 -> 22, X:02 -> 07 in memcard save:
lui $at, 0x8002
li  $t0, 0x24092207  # "addiu	$t1, $0, 0x2207"
sw  $t0, 0x7a8c($at)
li  $t1, 0xa429      # change sb to sh, and r0 to t1
sh  $t1, 0x7a92($at)
sw  $0, 0x7a98($at)  # clear sb $r0 -> ..f5
# Justifier X/Y adjust:
# Justifier X: 0x8005_29e4, set via hw at 0x8002_57e8
# Justifier Y: 0x8005_29ec, set via hw at 0x8002_57f0
li  $t0, 0xfff2
li  $t1, 0xffe7
sh  $t0, 0x57e8($at)
sh  $t1, 0x57f0($at)
# FlushCache() because we modified in mem instructions:
li  $t0, 0xa0
li  $t1, 0x44
jr  $t0  # $ra is already set from the code we hijacked
nop      # FlushCache() will return to the main program
