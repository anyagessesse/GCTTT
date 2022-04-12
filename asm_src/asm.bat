@echo off

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
ECHO /////////////////////////////////////////////////////////////////////////////////////
ECHO // ASSMEBLER MENU                                                                  //
ECHO // 1 - BUILD - Recompile the assembler.                                            //
ECHO // 2 - ASSEMBLE - Convert a program file (.asm) to a binary object file (.o).      //
ECHO // 0 - QUIT                                                                        //
ECHO /////////////////////////////////////////////////////////////////////////////////////
ECHO.
SET/P cmd=cmd:

REM execute selected command
REM quit
IF "%cmd%" == "0" GOTO exit

REM build
IF "%cmd%" == "1" GOTO build

REM assemble
IF "%cmd%" == "2" GOTO getFilename_asm

REM unrecognized command
ECHO Unrecognized command
GOTO menu

:getFilename_asm
REM Get name of file to assemble Recall this script with an assembly entry point
SET/P filename=Name of program to assemble (.asm): 
cmd /K "%0 asm %filename%"
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
java Driver 0 %2
ECHO.  
GOTO menu


:exit
EXIT