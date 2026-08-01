.org 0x0c04
.set noreorder
.set noat

.set PALMOD_MODE, 2  # set PAL mode patch method.
                     # 2 is best because GP1(07h) is automatically adjusted

.if PALMOD_MODE == 1
    # Write data to force PAL mode by blanking
    # the mode check at 0x8003_fc00
    # leaves GP1(07h) screen centering as NTSC values:
    # 0x0704_0010
    # CMD: GP1(07h) - Vertical Display range (on Screen)
    # Vert: 16, 256 (cent: 0x88)
    lui $at, 0x8004
    sw  $0, -0x400($at)
.elseif PALMOD_MODE == 2
    # Set byte at 0x8008_9ee0 to 0x01 for PAL:
    # 0x8001_4f64 was addu $a0, $0, $0
    # this path causes GP1(07h) to be centered correctly for PAL:
    # displaypos(0x0704_6c2b)
    # CMD: GP1(07h) - Vertical Display range (on Screen)
    # Vert: 43, 283 (cent: 0xA3)
    lui $at, 0x8001
    lui $t1, 0x2404
    addiu $t1, $t1, 0x01  # $t1 = 0x2402_0001 (addiu $a0, $0, 0x01)
    sw $t1, 0x4f64($at)
.endif

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
