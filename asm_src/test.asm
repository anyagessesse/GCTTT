# test.asm - used to test the assembler

# macros
def isBad			1		# true if bad, otherwise false	
def FRAME_WIDTH		640 	# measured in pixels
def FRAME_HEIGHT	480		# measured in pixels
def DEPTH			-96

MOV R0 MAIN			# enter
J R0				
_HANDLER			# start of interrupt handler
MOV R0 isBad

_MAIN				# start of main program
MOV	R0, 0			# initialize registers
MOV R1, 1
MOV R2, 2
MOV R3, 3
MOV R4, 4
MOV R5, 5
MOV R6, 6
MOV R7, 7

ADD R0, R0, R1		# use one of each instruction
SUB R0, R7, R0		
AND R0, R2, R3
OR R0, R2, R3
NOT R0, R7
XOR R0, R4, R5
SU R0, R4
SL R0, R4
SHRA R0, R1, R2
SHRL R0, R2, R3
ROR R0, R3, R4
SHL R0, R4, R5
ROL R0, R5, R6
MV0	R0, 1
MV1 R0, 1
MV2 R0, 1
MV3 R0, 1
BRLT R0, R1
BRGT R0, R2
BRLE R0, R3
BRGE R0, R4
BREQ R0, R5
BRNE R0, R6
J R0
LD R0, R1, 4
ST R0, R1, 8
LDC R0
NOP
HALT				# end