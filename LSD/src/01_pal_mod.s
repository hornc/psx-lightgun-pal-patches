.org 0x12370
.set noreorder
.set noat
# v0.3 PAL mode with centered screen
# Set PAL mode:
ori $s2, $s2, 0x09  # was 0x01 for NTSC, 240x320
