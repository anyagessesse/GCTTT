_DRAW_X
################################################################################
# Draws an x icon in the center of the screen
# PARAM R0 = return addr
# R1 = pixel addr
# R2 = maxAddr
# R3 = increment
# R4 = loop addr
# R5 = comparison result
# R6 = neighbor addr
# R7 = flexible operator

def BLACK						0 
def WHITE						1  
def ADDR_X_BACK_START			109691
def ADDR_X_BACK_END				198149
def ADDR_X_FORWARD_START		109829
def ADDR_X_FORWARD_END			198011

# draw \ (back slash)
# initialize the for loop
MOV R1 ADDR_X_BACK_START		# get starting addr
MOV R2 ADDR_X_BACK_END			# get ending addr
MOV R3 641						# set increment to move pixel addr diagonally \
MOV R4 DRAW_FOR_BACK			# prepare looping addr
_DRAW_FOR_BACK
# draw a row of 5 pixels centered at addr
MOV R7 2						# prepare for subtraction
SUB R6 R1 R7					# get addr of -2 neighbor
SP R6 WHITE						# color -2 neighbor
MOV R7 1						# prepare for addition
ADD R6 R6 R7					# get addr of -1 neighbor
SP R6 WHITE						# color -1 neighbor
ADD R6 R6 R7					# get addr of the pixel
SP R6 WHITE						# color the pixel
ADD R6 R6 R7					# get addr of +1 neighbor
SP R6 WHITE						# color +1 neighbor
ADD R6 R6 R7					# get addr of +2 neighbor
SP R6 WHITE						# color +2 neighbor

# prepare for next loop
ADD R1 R1 R3					# increment addr
SUB R5 R1 R2					# if(addr <= maxAddr)
BRLE R5 R4						# keep looping

# draw / (forward slash)
# initialize the for loop
MOV R1 ADDR_X_FORWARD_START		# get starting addr
MOV R2 ADDR_X_FORWARD_END		# get ending addr
MOV R3 639						# set increment (decrease horizontal coord once for each vertical increase)
MOV R4 DRAW_FOR_FORWARD			# prepare looping addr
_DRAW_FOR_FORWARD
# draw a row of 5 pixels centered at addr
MOV R7 2						# prepare for subtraction
SUB R6 R1 R7					# get addr of -2 neighbor
SP R6 WHITE						# color -2 neighbor
MOV R7 1						# prepare for addition
ADD R6 R6 R7					# get addr of -1 neighbor
SP R6 WHITE						# color -1 neighbor
ADD R6 R6 R7					# get addr of the pixel
SP R6 WHITE						# color the pixel
ADD R6 R6 R7					# get addr of +1 neighbor
SP R6 WHITE						# color +1 neighbor
ADD R6 R6 R7					# get addr of +2 neighbor
SP R6 WHITE						# color +2 neighbor

# prepare for next loop
ADD R1 R1 R3					# increment addr
SUB R5 R1 R2					# if(addr <= maxAddr)
BRLE R5 R4						# keep looping

HALT							# done
################################################################################