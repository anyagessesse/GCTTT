# key addresses
def ADDR_FRAME_START 0
def ADDR_FRAME_END 307199
def ADDR_CONTEXT 307260
def ADDR_USER_INPUT_AVAILABLE 307200
def ADDR_GRID_CODE 307204
def ADDR_COLOR 307208

# grid codes
def GC1 			1 
def GC2 			2
def GC3 			3
def GC4 			4
def GC5 			5
def GC6 			6
def GC7				7
def GC8 			8
def GC9				9
def GC1_COLOR 		246612020 # yellow
def GC2_COLOR 		162756771 # pale green
def GC3_COLOR 		49364098 # navy blue
def GC4_COLOR 		164718791 # violet
def GC5_COLOR 		241228951 # pink
def GC6_COLOR		219319373 # orange
def GC7_COLOR		192986132 # red
def GC8_COLOR		236182639 # lemon lime
def GC9_COLOR		63071385 # turquoise
def BLACK			0

# frame.asm
# Used to test the virtual machine. Makes the screen blue.
# 
#	*NOTE - R7 is the interrupt register and shouldn't be used elsewhere.

MOV R0 MAIN					# enter
J R0			

_HANDLER
# change color we are sending to the screen based on the grid code
# perform context save
MOV R7, ADDR_CONTEXT
ST R0, R7, 0				# save R0
ST R1, R7, 1				# save R1
ST R2, R7, 2				# save R2

# set userInputAvailable flag in memory to true
MOV R7, ADDR_USER_INPUT_AVAILABLE
MOV R0, 1
ST R0, R7, 0

# set grid code in memory to interrupt value from special purpose register
MOV R7, ADDR_GRID_CODE
LDC R0
ST R0, R7, 0

# set color according to grid code
# R0 = actual grid code
# R1 = comparative grid code
# R2 = color to save
# R7 = address
_IF_GC1						# if(R1 == GC1) set color
MOV R1, GC1
SUB R1, R1, R0
MOV R7, ELSE_IF_GC2
BRNE R1, R7
MOV R2, GC1_COLOR
MOV R7, ENDIF
J R7
_ELSE_IF_GC2				# if(R1 == GC2) set color
MOV R1, GC2
SUB R1, R1, R0
MOV R7, ELSE_IF_GC3
BRNE R1, R7
MOV R2, GC2_COLOR
MOV R7, ENDIF
J R7
_ELSE_IF_GC3				# if(R1 == GC3) set color
MOV R1, GC3
SUB R1, R1, R0
MOV R7, ELSE_IF_GC4
BRNE R1, R7
MOV R2, GC3_COLOR
MOV R7, ENDIF
J R7
_ELSE_IF_GC4				# if(R1 == GC4) set color
MOV R1, GC4
SUB R1, R1, R0
MOV R7, ELSE_IF_GC5
BRNE R1, R7
MOV R2, GC4_COLOR
MOV R7, ENDIF
J R7
_ELSE_IF_GC5				# if(R1 == GC5) set color
MOV R1, GC5
SUB R1, R1, R0
MOV R7, ELSE_IF_GC6
BRNE R1, R7
MOV R2, GC5_COLOR
MOV R7, ENDIF
J R7
_ELSE_IF_GC6				# if(R1 == GC6) set color
MOV R1, GC6
SUB R1, R1, R0
MOV R7, ELSE_IF_GC7
BRNE R1, R7
MOV R2, GC6_COLOR
MOV R7, ENDIF
J R7
_ELSE_IF_GC7				# if(R1 == GC7) set color
MOV R1, GC7
SUB R1, R1, R0
MOV R7, ELSE_IF_GC8
BRNE R1, R7
MOV R2, GC7_COLOR
MOV R7, ENDIF
J R7
_ELSE_IF_GC8				# if(R1 == GC8) set color
MOV R1, GC8
SUB R1, R1, R0
MOV R7, ELSE_IF_GC9
BRNE R1, R7
MOV R2, GC8_COLOR
MOV R7, ENDIF
J R7
_ELSE_IF_GC9				# if(R1 == GC9) set color
MOV R1, GC9
SUB R1, R1, R0
MOV R7, ELSE
BRNE R1, R7
MOV R2, GC9_COLOR
MOV R7, ENDIF
J R7
_ELSE						# else set color to black
MOV R2, BLACK
_ENDIF						# store color to memory
MOV R7, ADDR_COLOR			
ST R2, R7, 0

# perform context restore
MOV R7, ADDR_CONTEXT
LD R0, R7, 0				# restore R0
LD R1, R7, 1				# restore R1
LD R2, R7, 2				# restore R2

# resume operation
RES

_MAIN

_DRAW_FRAME
# initialize for loop
MOV R1 ADDR_FRAME_START		# R1 = addr
MOV R2 ADDR_FRAME_END		# R2 = maxAddr
MOV R4 FOR					# R4 = FOR
MOV R6 1					# R6 = increment

# begin looping
_FOR
# get color
MOV R0, ADDR_COLOR
LD R3, R0, 0

# color pixel at current address
ST R3, R1, 0

# increment addr
ADD R1, R1, R6

# decide whether or not to keep looping
SUB R5, R1, R2 				# R5 = addr-maxAddr as long as R5 is <= 0, we have not yet reached max addr
BRLE R5, R4					# if(addr-maxAddr <= 0) keep looping

# start back frome the beginning of the frame
MOV R0, DRAW_FRAME
J R0


_EXIT
HALT



