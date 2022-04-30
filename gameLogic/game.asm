################################################################################
# game.asm
# The tic tac toe game itself. Woah.
################################################################################

# frame addrs
def ADDR_FRAME_START 			0
def ADDR_FRAME_END 				307199

# dmem addrs
def ADDR_SAVE_R0 				0
def ADDR_SAVE_R1 				1
def ADDR_SAVE_R2 				2
def ADDR_SAVE_R3 				3
def ADDR_SAVE_R4 				4
def ADDR_SAVE_R5 				5
def ADDR_SAVE_R6 				6
def ADDR_SAVE_R7 				7
def ADDR_USER_INPUT_AVAILABLE 	8
def ADDR_GRID_CODE 				9

# grid codes
def GC1 						1 
def GC2 						2
def GC3 						3
def GC4 						4
def GC5 						5
def GC6 						6
def GC7							7
def GC8 						8
def GC9							9

# global constants
def MONITOR_WIDTH				640
def MONITOR_HEIGHT				480
def BLACK						0
def WHITE						1

_ENTER
################################################################################
# Start here.
MOV R0 MAIN						# jump to main
J R0
################################################################################

_HANDLER
################################################################################
# The one and only interrupt handler. Saves selected grid space to memory.
# Asserts the new userInputAvailable flag.
RES								# resume operation
################################################################################

_DRAW_X
################################################################################
# Draws an x starting at the given location. Given location should be the top
# left corner of the drawing
# PARAM R0 = addr of pixel to start drawing at
# PARAM R1 = return addr
# R2 = maxAddr
# R3 = increment
# R4 = loop addr
# R5 = comparison result
# R6 = neighbor addr
# R7 = flexible operator

def X_BACK_INC						641
def X_FORWORD_INC					639
def X_MAX_ADDR_OFFSET_BACK			70510	# add this to starting addr of \ to get max addr of \		
def X_START_ADDR_OFFSET_FORWARD		-70400 	# add this to the ending addr of \ to get the starting addr of /
def X_MAX_ADDR_OFFSET_FORWARD		-110		# add this to the ending addr of \ to get the ending addr of /

# draw \ (back slash)
# initialize the for loop
MOV R2 X_MAX_ADDR_OFFSET_BACK	# compute ending addr of \
ADD R2 R2 R0					# based on starting addr of \
MOV R3 X_BACK_INC				# set increment to move pixel addr diagonally \
MOV R4 DRAW_X_BACK_FOR			# prepare looping addr
_DRAW_X_BACK_FOR
# draw a row of 5 pixels centered at addr
MOV R7 2						# prepare for subtraction
SUB R6 R0 R7					# get addr of -2 neighbor
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
ADD R0 R0 R3					# increment addr
SUB R5 R0 R2					# if(addr <= maxAddr)
BRLE R5 R4						# keep looping

# draw / (forward slash)
# initialize the for loop
MOV R7 X_START_ADDR_OFFSET_FORWARD		# compute starting addr of /
ADD R0 R2 R7							# based on ending addr of \
MOV R7 X_MAX_ADDR_OFFSET_FORWARD		# compute ending addr of /
ADD R2 R2 R7							# based on ending addr of \
MOV R3 X_FORWORD_INC			# set increment (decrease horizontal coord once for each vertical increase)
MOV R4 DRAW_X_FORWORD_FOR		# prepare looping addr
_DRAW_X_FORWORD_FOR
# draw a row of 5 pixels centered at addr
MOV R7 2						# prepare for subtraction
SUB R6 R0 R7					# get addr of -2 neighbor
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
ADD R0 R0 R3					# increment addr
SUB R5 R0 R2					# if(addr <= maxAddr)
BRLE R5 R4						# keep looping

J R1							# return
################################################################################

_DRAW_O
################################################################################
# Draws an x starting at the given location. Given location should be the top
# left corner of the drawing
# PARAM R0 = addr of pixel to start drawing at
# PARAM R1 = return addr
# R2 = max addr
# R3 = increment
# R4 = loop addr
# R5 = comparison result
# R6 = neighbor addr
# R7 = flexible operator

def O_WIDTH						110		# in addrs
def O_HEIGHT					70400	# in addrs

# draw the top of the O
# initialize the for loop
MOV R2 O_WIDTH					# compute ending addr 
ADD R2 R2 R0					# based on starting addr
MOV R3 1						# set increment to move pixel addr horizontally ->
MOV R4 DRAW_O_TOP_FOR			# prepare looping addr
_DRAW_O_TOP_FOR
# draw a column of 5 pixels centered at addr
MOV R7 1280						# prepare for subtraction
SUB R6 R0 R7					# get addr of -2 neighbor
SP R6 WHITE						# color -2 neighbor
MOV R7 640						# prepare for addition
ADD R6 R6 R7					# get addr of -1 neighbor
SP R6 WHITE						# color -1 neighbor
ADD R6 R6 R7					# get addr of the pixel
SP R6 WHITE						# color the pixel
ADD R6 R6 R7					# get addr of +1 neighbor
SP R6 WHITE						# color +1 neighbor
ADD R6 R6 R7					# get addr of +2 neighbor
SP R6 WHITE						# color +2 neighbor

# prepare for next loop
ADD R0 R0 R3					# increment addr
SUB R5 R0 R2					# if(addr <= maxAddr)
BRLE R5 R4						# keep looping

# draw the right side of the O
# initialize the for loop
OR R0 R2 R2						# restore starting addr 
MOV R2 O_HEIGHT					# compute ending addr 
ADD R2 R2 R0					# based on starting addr
MOV R3 640						# set increment to move pixel addr vertically v
MOV R4 DRAW_O_RIGHT_FOR			# prepare looping addr
_DRAW_O_RIGHT_FOR
# draw a row of 5 pixels centered at addr
MOV R7 2						# prepare for subtraction
SUB R6 R0 R7					# get addr of -2 neighbor
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
ADD R0 R0 R3					# increment addr
SUB R5 R0 R2					# if(addr <= maxAddr)
BRLE R5 R4						# keep looping

# draw the bottom of the O
# initialize the for loop
OR R0 R2 R2						# restore starting addr 
MOV R2 O_WIDTH					# compute ending addr 
SUB R0 R0 R2					# based on starting addr
ADD R2 R0 R2
MOV R3 1						# set increment to move pixel addr horizontally ->
MOV R4 DRAW_O_BOT_FOR			# prepare looping addr
_DRAW_O_BOT_FOR
# draw a column of 5 pixels centered at addr
MOV R7 1280						# prepare for subtraction
SUB R6 R0 R7					# get addr of -2 neighbor
SP R6 WHITE						# color -2 neighbor
MOV R7 640						# prepare for addition
ADD R6 R6 R7					# get addr of -1 neighbor
SP R6 WHITE						# color -1 neighbor
ADD R6 R6 R7					# get addr of the pixel
SP R6 WHITE						# color the pixel
ADD R6 R6 R7					# get addr of +1 neighbor
SP R6 WHITE						# color +1 neighbor
ADD R6 R6 R7					# get addr of +2 neighbor
SP R6 WHITE						# color +2 neighbor

# prepare for next loop
ADD R0 R0 R3					# increment addr
SUB R5 R0 R2					# if(addr <= maxAddr)
BRLE R5 R4						# keep looping

# draw the left side of the O
# initialize the for loop
OR R0 R2 R2						# restore starting addr 
MOV R2 O_HEIGHT					# compute ending addr 
SUB R0 R0 R2					# based on starting addr
ADD R2 R0 R2
MOV R3 640						# set increment to move pixel addr vertically v
MOV R4 DRAW_O_LEFT_FOR			# prepare looping addr
_DRAW_O_LEFT_FOR
# draw a row of 5 pixels centered at addr
MOV R7 2						# prepare for subtraction
SUB R6 R0 R7					# get addr of -2 neighbor
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
ADD R0 R0 R3					# increment addr
SUB R5 R0 R2					# if(addr <= maxAddr)
BRLE R5 R4						# keep looping

J R1							# return
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


_MAIN


_DRAW_BACKGROUND
################################################################################
# draw the background
# R0 = pixel addr
# R1 = increment
# R3 = comparative stop address (stop after)
# R4 = comparison result
# R5 = loop addr

# initialize loop
MOV R0 ADDR_FRAME_START			# initialize addr to start of frame
MOV R1 1						# set increment amount to 1
MOV R3 ADDR_FRAME_END			# set address to stop after
_BACKGROUND_FOR
SP R0 BLACK						# update pixel in memory
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
MOV R1 LINE_LENGTH				# compute maxAddr(start+length-1) = length
ADD R1 R1 R0					# maxAddr = length+start
SUB R1 R1 R3					# maxAddr = length+start-1
_DRAW_GRID_FOR_HORZ_UPPER
# draw from left to right
# colors 4 pixels in the vertical cross section before continuing on
MOV R4 MONITOR_WIDTH			# address offset
OR R5 R0 R0						# save pixel addr
SP R0 WHITE						# color pixel 0
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 1
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 2
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 3
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
_DRAW_GRID_FOR_HORZ_LOWER
# draw from left to right
# colors 4 pixels in the vertical cross section before continuing on
MOV R4 MONITOR_WIDTH			# address offset
OR R5 R0 R0						# save pixel addr
SP R0 WHITE						# color pixel 0
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 1
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 2
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 3
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
_DRAW_GRID_FOR_VERT_LEFT
# draw from top to bot
# colors 4 pixels in the horizontal cross section before continuing on
MOV R4 1						# address offset
OR R5 R0 R0						# save pixel addr
SP R0 WHITE						# color pixel 0
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 1
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 2
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 3
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
_DRAW_GRID_FOR_VERT_RIGHT
# draw from top to bot
# colors 4 pixels in the horizontal cross section before continuing on
MOV R4 1						# address offset
OR R5 R0 R0						# save pixel addr
SP R0 WHITE						# color pixel 0
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 1
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 2
ADD R0 R0 R4					# jump addr to pixel below
SP R0 WHITE						# color pixel 3
OR R0 R5 R5						# restore pixel addr
# get ready for next loop
ADD R0 R0 R3					# increment addr
MOV R5 DRAW_GRID_FOR_VERT_RIGHT	# prepare to loop back
SUB R4 R0 R1					# if(addr <= maxAddr)
BRLE R4 R5						# keep looping
################################################################################

_WAIT_FOR_USER
################################################################################

def ADDR_DRAW_PIECE_1_START		32771
def ADDR_DRAW_PIECE_1_END		103281	
def ADDR_DRAW_PIECE_2_START		32905
def ADDR_DRAW_PIECE_2_END		103415
def ADDR_DRAW_PIECE_3_START		33039
def ADDR_DRAW_PIECE_3_END		103549
def ADDR_DRAW_PIECE_4_START		118531
def ADDR_DRAW_PIECE_4_END		189041
def ADDR_DRAW_PIECE_5_START		118665
def ADDR_DRAW_PIECE_5_END		189175
def ADDR_DRAW_PIECE_6_START		118799
def ADDR_DRAW_PIECE_6_END		189308
def ADDR_DRAW_PIECE_7_START		204291
def ADDR_DRAW_PIECE_7_END		274801
def ADDR_DRAW_PIECE_8_START		204425
def ADDR_DRAW_PIECE_8_END		274935
def ADDR_DRAW_PIECE_9_START		204559
def ADDR_DRAW_PIECE_9_END		275069

# TEST - draw a game piece in all squares
# top left
MOV R0 ADDR_DRAW_PIECE_1_START	# prepare startAddr argument
MOV R1 RET_1					# prepare return addr
MOV R3 DRAW_X					# select function
J R3							# call function
_RET_1

# top center
MOV R0 ADDR_DRAW_PIECE_2_START	# prepare startAddr argument
MOV R1 RET_2					# prepare return addr
MOV R3 DRAW_O					# select function
J R3							# call function
_RET_2

# top right
MOV R0 ADDR_DRAW_PIECE_3_START	# prepare startAddr argument
MOV R1 RET_3					# prepare return addr
MOV R3 DRAW_X					# select function
J R3							# call function
_RET_3

# middle left
MOV R0 ADDR_DRAW_PIECE_4_START	# prepare startAddr argument
MOV R1 RET_4					# prepare return addr
MOV R3 DRAW_O					# select function
J R3							# call function
_RET_4

# middle center
MOV R0 ADDR_DRAW_PIECE_5_START	# prepare startAddr argument
MOV R1 RET_5					# prepare return addr
MOV R3 DRAW_X					# select function
J R3							# call function
_RET_5

# middle right
MOV R0 ADDR_DRAW_PIECE_6_START	# prepare startAddr argument
MOV R1 RET_6					# prepare return addr
MOV R3 DRAW_O					# select function
J R3							# call function
_RET_6

# bottom left
MOV R0 ADDR_DRAW_PIECE_7_START	# prepare startAddr argument
MOV R1 RET_7					# prepare return addr
MOV R3 DRAW_X					# select function
J R3							# call function
_RET_7

# bottom center
MOV R0 ADDR_DRAW_PIECE_8_START	# prepare startAddr argument
MOV R1 RET_8					# prepare return addr
MOV R3 DRAW_O					# select function
J R3							# call function
_RET_8

# bottom right
MOV R0 ADDR_DRAW_PIECE_9_START	# prepare startAddr argument
MOV R1 RET_9					# prepare return addr
MOV R3 DRAW_X					# select function
J R3							# call function
_RET_9


HALT							# exit