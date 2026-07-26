.org 0x21c4
.set noreorder
.set noat
# v0.2 PAL mode with centered screen
# Set PAL mode:
lui $at, 0x8002
li  $a0, 0x09
sb  $a0, 0x1b70($at)
# set correct PAL screen offset:
sb  $t5, 0x1918($at)
# t5 happens to be set to 0x2B, which is exactly what we need to change
# GP1(07h) y1 to, from 0x10. The existing code adds 240 to y1 to get y2
