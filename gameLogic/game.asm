# variable addresses
def ADDR_FRAME_START 			0
def ADDR_FRAME_END 				307199
def ADDR_SP_START				393216

# global constants
def MONITOR_WIDTH				640
def MONITOR_HEIGHT				480

_ENTER
################################################################################
# game.asm
# The tic tac toe game itself.
# 	*NOTE - R7 is off limits except inside the interrupt handler
# 	*NOTE - R6 acts as the stack pointer
MOV R6 ADDR_SP_START			# initialize stack pointer
MOV R0 MAIN						# jump to main
J R0
################################################################################

_HANDLER
################################################################################
# The one and only interrupt handler. Saves selected grid space to memory.
RES								# resume operation
################################################################################

_MULT
################################################################################
# multiplies two parameters
# can't handle multiplication by zero so don't do it
# RETURN R0 = a * b
# PARAM R1 = operand a (count)
# PARAM R2 = operand b (rep)
# PARAM R3 = return addr
# R4 = 1
# R5 = jump addr

# initialize the for loop
MOV R4 1						# we will be decrementing count by 1
MOV R0 0						# res = 0
_MULT_FOR
ADD R0 R0 R2					# res += b
MOV R5 MULT_FOR					# prepare looping addr
SUB R1 R1 R4					# count--
BRGT R1 R5						# if(count > 0) keep looping

_MULT_RETURN	
J R3							# return to sender
################################################################################


################################################################################

_MAIN

_DRAW_BACKGROUND
################################################################################
# draw the background
# R0 = pixel addr
# R1 = increment
# R2 = pixel color
# R3 = comparative stop address (stop after)
# R4 = comparison result
# R5 = branch addr

def BACKGROUND_COLOR			99761239

# initialize loop
MOV R0 ADDR_FRAME_START			# initialize addr to start of frame
MOV R1 1						# set increment amount to 1
MOV R2 BACKGROUND_COLOR			# set pixel color
MOV R3 ADDR_FRAME_END			# set address to stop after
_BACKGROUND_FOR
ST R2 R0 0						# update pixel in memory
ADD R0 R0 R1					# increment address
MOV R5 BACKGROUND_FOR			# prepare to loop back
SUB R4 R0 R3					# if(addr <= stopAddr)
BRLE R4 R5						# keep looping
################################################################################

_DRAW_GRID
################################################################################
# Draws the 3x3 grid used as the gameboard.
# R0 = pixel addr
# R1 = max pixel addr
# R2 = pixel color
# R3 = increment 
# R4 = wildcard
# R5 = flex addr

def ADDR_HORZ_UPPER				109561
def ADDR_HORZ_LOWER				195321
def ADDR_VERT_LEFT_START		26491
def ADDR_VERT_LEFT_END			280571
def ADDR_VERT_RIGHT_START		26625
def ADDR_VERT_RIGHT_END			280705
def LINE_LENGTH					398
def GRID_COLOR					0

# draw upper horizontal line
# initialize for loop to draw line of pixels
MOV R0 ADDR_HORZ_UPPER			# get starting addr
MOV R3 1						# set increment
MOV R1 LINE_LENGTH				# compute max addr = start+length-1
ADD R1 R1 R0
SUB R1 R1 R3
MOV R2 GRID_COLOR				# get pixel color
_DRAW_GRID_FOR_HORZ_UPPER
# draw from left to right
# colors 4 pixels in the vertical cross section before continuing on
MOV R4 MONITOR_WIDTH			# address offset
OR R5 R0 R0						# save pixel addr
ST R2 R0 0						# color pixel 0
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 1-
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 2
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 3
OR R0 R5 R5						# restore pixel addr
# get ready for next loop
ADD R0 R0 R3					# increment addr
MOV R5 DRAW_GRID_FOR_HORZ_UPPER # prepare to loop back
SUB R4 R0 R1					# if(addr <= maxAddr)
BRLE R4 R5						# keep looping

# draw lower horizontal line
# initialize for loop to draw line of pixels
MOV R0 ADDR_HORZ_LOWER			# get starting addr
MOV R3 1						# set increment
MOV R1 LINE_LENGTH				# compute max addr = start+length-1
ADD R1 R1 R0
SUB R1 R1 R3
MOV R2 GRID_COLOR				# get pixel color
_DRAW_GRID_FOR_HORZ_LOWER
# draw from left to right
# colors 4 pixels in the vertical cross section before continuing on
MOV R4 MONITOR_WIDTH			# address offset
OR R5 R0 R0						# save pixel addr
ST R2 R0 0						# color pixel 0
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 1
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 2
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 3
OR R0 R5 R5						# restore pixel addr
# get ready for next loop
ADD R0 R0 R3					# increment addr
MOV R5 DRAW_GRID_FOR_HORZ_LOWER # prepare to loop back
SUB R4 R0 R1					# if(addr <= maxAddr)
BRLE R4 R5						# keep looping

# drawe left vertical line
# initialize for loop to draw line of pixels
MOV R0 ADDR_VERT_LEFT_START		# get starting addr
MOV R1 ADDR_VERT_LEFT_END		# get max addr
MOV R3 MONITOR_WIDTH			# set increment
MOV R2 GRID_COLOR				# get pixel color
_DRAW_GRID_FOR_VERT_LEFT
# draw from top to bot
# colors 4 pixels in the horizontal cross section before continuing on
MOV R4 1						# address offset
OR R5 R0 R0						# save pixel addr
ST R2 R0 0						# color pixel 0
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 1
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 2
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 3
OR R0 R5 R5						# restore pixel addr
# get ready for next loop
ADD R0 R0 R3					# increment addr
MOV R5 DRAW_GRID_FOR_VERT_LEFT	# prepare to loop back
SUB R4 R0 R1					# if(addr <= maxAddr)
BRLE R4 R5						# keep looping

# draw right vertical line
# initialize for loop to draw line of pixels
MOV R0 ADDR_VERT_RIGHT_START	# get starting addr
MOV R1 ADDR_VERT_RIGHT_END		# get max addr
MOV R3 MONITOR_WIDTH			# set increment
MOV R2 GRID_COLOR				# get pixel color
_DRAW_GRID_FOR_VERT_RIGHT
# draw from top to bot
# colors 4 pixels in the horizontal cross section before continuing on
MOV R4 1						# address offset
OR R5 R0 R0						# save pixel addr
ST R2 R0 0						# color pixel 0
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 1
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 2
ADD R0 R0 R4					# jump addr to pixel below
ST R2 R0 0						# color pixel 3
OR R0 R5 R5						# restore pixel addr
# get ready for next loop
ADD R0 R0 R3					# increment addr
MOV R5 DRAW_GRID_FOR_VERT_RIGHT	# prepare to loop back
SUB R4 R0 R1					# if(addr <= maxAddr)
BRLE R4 R5						# keep looping
################################################################################

_WAIT_FOR_USER
################################################################################			


HALT							# exit