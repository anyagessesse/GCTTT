@ECHO off

REM Double click entry. Open menu.
IF "%~1" == "" GOTO menu

REM Recall entry. Start assembling
IF "%~1" == "asm" GOTO asm

REM Recall entry. Start re-assembling
IF "%~1" == "rsm" GOTO rsm

REM Improper invocation.
ECHO Improper invocation:
ECHO 	- Double click asm.bat in file explorer
ECHO 	- enter the command "./asm.bat" from the command line
GOTO exit

:menu
REM give user available options
ECHO /////////////////////////////////////////////////////////////////////////////////////////
ECHO // ASSMEBLER MENU                                                                      //
ECHO // 1 - BUILD - Recompile the assembler.                                                //
ECHO // 2 - ASSEMBLE                                                                        //
ECHO //       2.1 - ASSEMBLE TO BINARY - turn a .asm file to .o file.                        //
ECHO //       2.2 - ASSEMBLE TO HEX - turn a .asm file to a .hex file.                       //
ECHO // 3 - RE-ASSEMBLE - turn a .o file to a .rsm file.                                    //
ECHO // 0 - QUIT                                                                            //
ECHO /////////////////////////////////////////////////////////////////////////////////////////
ECHO.
SET/P cmd=cmd:

REM execute selected command
REM quit
IF "%cmd%" == "0" GOTO exit

REM build
IF "%cmd%" == "1" GOTO build

REM assemble
IF "%cmd%" == "2.1" GOTO getFilename_asm

REM debug assemble
IF "%cmd%" == "2.1d" GOTO getFIlename_asm_debug

REM assemble to hex
IF "%cmd%" == "2.2" GOTO getFilename_asmToHex

REM debug assemble to hex
IF "%cmd%" == "2.2d" GOTO getFilename_asmToHex_debug

REM re-assemble
IF "%cmd%" == "3" GOTO getFilename_rsm

REM debug re-assemble
IF "%cmd%" == "3d" GOTO getFilename_rsm_debug

REM unrecognized command
ECHO Unrecognized command
GOTO menu

:getFilename_asm
REM Get name of file to assemble. Recall this script with an assembly entry point
SET/P filename=Name of program to assemble (.asm): 
CMD /K "%0 asm %filename%" 0 0
GOTO exit

:getFilename_asm_debug
REM Get name of file to assemble. Recall this script with an assembly entry point
SET/P filename=Name of program to assemble (.asm): 
CMD /K "%0 asm %filename%" 0 1
GOTO exit

:getFilename_asmToHex
REM Get name of file to assemble. Recall this script with an assembly entry point
SET/P filename=Name of program to assemble (.asm): 
CMD /K "%0 asm %filename%" 1 0
GOTO exit

:getFilename_asmToHex_debug
REM Get name of file to assemble. Recall this script with an assembly entry point
SET/P filename=Name of program to assemble (.asm): 
CMD /K "%0 asm %filename%" 1 1
GOTO exit

:getFilename_rsm
REM Get name of file to re-assemble. Recall this script with an assembly entry point
SET/P filename=Name of object file to re-assemble (.o): 
CMD /K "%0 asm %filename%" 2 0
GOTO exit

:getFilename_rsm_debug
REM Get name of file to re-assemble. Recall this script with an assmembly entry point
SET/P filename=Name of object file to re-assemble (.o): 
CMD /K "%0 asm %filename%" 2 1
GOTO exit

:build
REM recompile everything
ECHO Compiling ...
@ECHO on
javac Symbol.java
javac SymbolTable.java
javac Translator.java
javac Driver.java
@ECHO off
ECHO.     
GOTO menu

:asm
REM Perform the assembly
java Driver %2 %3 %4
ECHO.  
GOTO menu

:exit
EXIT