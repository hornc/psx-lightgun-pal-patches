.set noreorder
j 0x80100400
nop
# Write data to force PAL mode to 0x800512e8
lui $t0, 0x8005
li  $t1, 0x01
sb  $t1, 0x12e8($t0)
# Write 0xffffffc0 to 0x800529ec OR write 0xffc0 hw to 0x800257f0
lui $t0, 0x8002
li  $t2, 0xffc0
sh  $t2, 0x57f0($t0)
jr  $ra
nop
