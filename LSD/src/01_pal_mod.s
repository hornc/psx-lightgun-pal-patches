.org 0x21c4
.set noreorder
.set noat
# Set PAL mode:
lui $at, 0x8002
li  $a0, 0x09
sb  $a0, 0x1b70($at)
# v0.1 minimal PAL mode
# TODO: lower the image as it sits right at
# the top of the screen
