################################################################################
# initialize registers
################################################################################
MV0 R0, 0	# R0 <- 0
NOP
NOP
NOP
NOP
MV1 R0, 0
NOP
NOP
NOP
NOP
MV2 R0, 0
NOP
NOP
NOP
NOP
MV3 R0, 0
NOP
NOP
NOP
NOP

MV0 R1, 1	# R1 <- 1
NOP
NOP
NOP
NOP
MV1 R1, 0
NOP
NOP
NOP
NOP
MV2 R1, 0
NOP
NOP
NOP
NOP
MV3 R1, 0
NOP
NOP
NOP
NOP

MV0 R2, 2	# R2 <- 2
NOP
NOP
NOP
NOP
MV1 R2, 0
NOP
NOP
NOP
NOP
MV2 R2, 0
NOP
NOP
NOP
NOP
MV3 R2, 0
NOP
NOP
NOP
NOP

MV0 R3, 3	# R3 <- 3
NOP
NOP
NOP
NOP
MV1 R3, 0
NOP
NOP
NOP
NOP
MV2 R3, 0
NOP
NOP
NOP
NOP
MV3 R3, 0
NOP
NOP
NOP
NOP

MV0 R4, 4	# R4 <- 4
NOP
NOP
NOP
NOP
MV1 R4, 0
NOP
NOP
NOP
NOP
MV2 R4, 0
NOP
NOP
NOP
NOP
MV3 R4, 0
NOP
NOP
NOP
NOP

MV0 R5, 3	# R5 <- 25
NOP
NOP
NOP
NOP
MV1 R5, 0
NOP
NOP
NOP
NOP
MV2 R5, 0
NOP
NOP
NOP
NOP
MV3 R5, 0
NOP
NOP
NOP
NOP

################################################################################
# operations
################################################################################
SU R0, R5
NOP
NOP
NOP
NOP

SL R0, R5
NOP
NOP
NOP
NOP

SHRA R0, R1, R2
NOP
NOP
NOP
NOP

SHRL R0, R2, R3
NOP
NOP
NOP
NOP

ROR R0, R3, R4
NOP
NOP
NOP
NOP

SHL R0, R4, R5
NOP
NOP
NOP
NOP

ROL R0, R5, R4
HALT

