.org 0x21c4
.set noreorder
.set noat
# v0.2 PAL mode with centered screen
# Set PAL mode:
lui $at, 0x8002
li  $a0, 0x09
sb  $a0, 0x1b70($at)
