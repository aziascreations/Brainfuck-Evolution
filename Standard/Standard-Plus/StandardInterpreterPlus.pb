; -----------------
; Brainfuck Standard Plus Interpreter
; 
; Revision: 0 on 11/3/19
; -----------------

;- Compiler directives

EnableExplicit

; If set to true the final executable will not open a file requester and
;  will end with the following exit code: #EXIT_CODE_NO_FILE_GIVEN
#COMPILER_BF_FORCE_FILE_AS_LAUNCH_PARAM = #False

; Allows for easy identification of text file encoding.
; See the file or the readme for links and credits to the author and forum post.
XIncludeFile "../../Includes/AutoDetectTextEncoding.pbi"
UseModule dte

; Allows for easy manipulation of cli parameters.
; FIXME: This is an unfinished version of the library and is missing a few procedures to cleanup the memory.
;        It either has to be finished or changed with something that works correctly.
;XIncludeFile "./Includes/cli-args.pbi"


;- Header stuff and variables

; Exit codes
#EXIT_CODE_NO_ERROR = 0
#EXIT_CODE_UNKNOWN = 1 ; Don't use this one if possible
#EXIT_CODE_NO_CONSOLE = 2

#EXIT_CODE_MALLOC_ERROR_CELLS = 10
#EXIT_CODE_REALLOC_ERROR_CELLS = 11

#EXIT_CODE_REALLOC_ERROR_INPUT_BUFFER = 20
#EXIT_CODE_MEALLOC_ERROR_INPUT_BUFFER = 21

#EXIT_CODE_INVALID_LAUNCH_PARAM = 30

#EXIT_CODE_FILE_INVALID = 40
#EXIT_CODE_UNSUPORTED_FILE_ENCODING = 41
#EXIT_CODE_FILE_ENCODING_DETECTION_FAILURE = 42
#EXIT_CODE_FILE_READ_ERROR = 43
#EXIT_CODE_NO_FILE_GIVEN = 44

#EXIT_CODE_OUT_OF_RANGE_STACK_POINTER = 50

; Amounts of bytes available at the start and by which the memory is expanded when needed.
#MEMORY_SIZE_INITIAL = 256
#MEMORY_SIZE_INCREMENT = 256

;; Default size for the input buffer (can be overwritten with launch arguments)
;#MEMORY_SIZE_INPUT_BUFFER = 1024

; Stack pointer (Memory pointer)
Define SP.q = 0

; Instruction pointer
Define IP.q = 0

; Memory area that contains all the cells.
Define *Cells

; A copy of the *Cells pointer that is kept in memory in case there is an error while
;  expanding the memory.
Define *OldCells

; Will be resized when loading the code
Dim Instructions$(0)

; Used in the _BracketSearch() Macro to keep count of the nested loops.
Define BracketCount

; Path to the file that contains the bf code.
Define SourceFilePath$

; Temporary Variable(s) (Used in some loops)
Define Line$, CharPosition, i
Define CurrentCliParameter$
Define SourceFileEncoding

; Interpreter Buffer(s)
Define IsInputBufferEnabled = #True
Define AddNullAfterInputBuffer = #False
Define TempInputBuffer$
Dim InputBuffer$(0)

;Define *InputBuffer, *OldInputBuffer
;Define TempInputBuffer$ ; Used to avoid a null pointer error (Should be temporary)


;- Macros

; Macro taken from rosetta code and adapted for this project.
; See: https://rosettacode.org/wiki/Execute_Brain****/PureBasic
; Direction: 1=forward -1=Backward
Macro _BracketSearch(Direction = 1)
	; Start counting with the current bracket
	BracketCount = Direction
	
	; Count nested loops until a matching one is found.
	Repeat
		; Moving the IP in the right direction
		IP + Direction
		If Instructions$(IP) = "]"
			BracketCount - 1
		ElseIf Instructions$(IP) = "["
			BracketCount + 1
		EndIf
	Until BracketCount = 0
EndMacro


;- Procedures

Procedure PrintErrorMessage(Message$, Exitcode)
	ConsoleColor(4, 0)
	PrintN(#CRLF$+Message$)
	ConsoleColor(7, 0)
	
	CompilerIf #PB_Compiler_Debugger
		PrintN("Press enter to exit...")
		Input()
	CompilerEndIf
	
	CloseConsole()
	End Exitcode
EndProcedure


;- Program Code

;-> Console Preparation
If Not OpenConsole("Brainfuck Interpreter")
	MessageRequester("Fatal error", "Unable to open a console.", #PB_MessageRequester_Ok | #PB_MessageRequester_Error)
	End #EXIT_CODE_NO_CONSOLE
EndIf


;-> Allocating Memory
*Cells = AllocateMemory(#MEMORY_SIZE_INITIAL)
If Not *Cells
	PrintErrorMessage("Memory allocation failure !", #EXIT_CODE_MALLOC_ERROR_CELLS)
EndIf


;-> Rudimentary launch parameters parsing

CurrentCliParameter$ = ProgramParameter()

; TODO: Check if next arg is present when nescessary
While CurrentCliParameter$ <> #Null$
	If FindString(CurrentCliParameter$, "-")
		Select CurrentCliParameter$
			Case "-f", "--file", "/f", "/file"
				SourceFilePath$ = ProgramParameter()
			Case "-B", "--no-input-buffer"
				IsInputBufferEnabled = #False
			Case "-n", "--null-after-input"
				Debug "Null byte after input enabled !"
				AddNullAfterInputBuffer = #True
; 			Case "-i", "--input-buffer"
; 				If IsInputBufferEnabled
; 					; FIXME: Could cause a null pointer error
; 					*InputBuffer = CopyMemoryString(ProgramParameter())
; 				Else
; 					PrintErrorMessage("Unable to use -B and -i together !", #EXIT_CODE_INVALID_LAUNCH_PARAM)
; 				EndIf
				;Case "-e", "--encoding"
				;	CurrentCliParameter$ = ProgramParameter()
				;Case "-c", "--code"
				;	Direct code input ?
		EndSelect
		
		CurrentCliParameter$ = ProgramParameter()
	Else
		SourceFilePath$ = CurrentCliParameter$
	EndIf
Wend


;-> Source file selection

If SourceFilePath$ = #Null$
	CompilerIf #COMPILER_BF_FORCE_FILE_AS_LAUNCH_PARAM
		FreeMemory(*Cells)
		End #EXIT_CODE_NO_FILE_GIVEN
	CompilerElse
		SourceFilePath$ = OpenFileRequester("Please choose file to load", "./", "All files (*.*)|*.*", 0)
	CompilerEndIf
EndIf

If SourceFilePath$ = #Null$ Or FileSize(SourceFilePath$) < 0
	PrintErrorMessage("File requester cancelled or invalid file !", #EXIT_CODE_FILE_INVALID)
EndIf


;-> Source file encoding detection and reading

SourceFileEncoding = dte::detectTextEncodingInFile(SourceFilePath$)

If SourceFileEncoding <> -1
	If SourceFileEncoding <> #PB_Ascii And SourceFileEncoding <> #PB_UTF8 And SourceFileEncoding <> #PB_Unicode
		PrintErrorMessage("File encoding not supported, please use ascii/ansi, unicode or utf-8! -> "+SourceFilePath$,
		                  #EXIT_CODE_UNSUPORTED_FILE_ENCODING)
	EndIf
Else
	PrintErrorMessage("Attempt at detecting the file encoding failed -> "+SourceFilePath$,
	                  #EXIT_CODE_FILE_ENCODING_DETECTION_FAILURE)
EndIf

If Not ReadFile(0, SourceFilePath$, SourceFileEncoding)
	PrintErrorMessage("Unable to read file! -> "+SourceFilePath$, #EXIT_CODE_FILE_READ_ERROR)
	End 2
EndIf

; Temporarely resizing the array to the size of the file.
ReDim Instructions$(FileSize(SourceFilePath$))

While Eof(0) = 0
	Line$ = ReadString(0, SourceFileEncoding)
	
	CharPosition = FindString(Line$, ";")
	If CharPosition
		Debug Line$
		Line$ = Left(Line$, CharPosition - 1)
		Debug Line$
	EndIf
	Line$ = ReplaceString(Line$, " ", "")
	
	For i=1 To Len(Line$)
		Instructions$(IP) = Mid(Line$, i, 1)
		Debug Instructions$(IP)
		IP + 1
	Next
Wend

CloseFile(0)
ReDim Instructions$(IP)
IP = 0


;-> Main Interpreter Loop

While IP < ArraySize(Instructions$()) And Instructions$(IP) <> #Null$
	Select(Instructions$(IP))
		Case "+"
			PokeA(*Cells + SP, PeekA(*Cells + SP) + 1)
			
		Case "-"
			PokeA(*Cells + SP, PeekA(*Cells + SP) - 1)
			
		Case ">"
			SP + 1
			If SP >= MemorySize(*Cells)
				*OldCells = *Cells
				*Cells = ReAllocateMemory(*Cells, MemorySize(*Cells) + #MEMORY_SIZE_INCREMENT)
				
				If Not *Cells
					; TODO: Call a dump procedure
					FreeMemory(*OldCells)
					PrintErrorMessage("Memory reallocation failure !", #EXIT_CODE_REALLOC_ERROR_CELLS)
				EndIf
				
				*OldCells = #Null
			EndIf
			
		Case "<"
			SP - 1
			If SP < 0 
				PrintErrorMessage("Memory Pointer out of range @"+Str(SP)+" !", #EXIT_CODE_OUT_OF_RANGE_STACK_POINTER)
			EndIf
			
		Case "."
			Print(Chr(PeekA(*Cells + SP)))
			
		Case ","
			; TODO: Allow for raw data to be given
			; TODO: Add optional null byte to signal string end ?
			; INFO: Maybe keep a 4 byte buffer handy to output any char/raw data ?
			; INFO: Don't print shit here except for the prompt !
			
			If IsInputBufferEnabled
				
				If ArraySize(InputBuffer$())
					PokeA(*Cells + SP, Asc(InputBuffer$(0)))
					;Debug "Poked: "+Asc(InputBuffer$(0)) + "("+InputBuffer$(0)+")"
					
					; Shift array left by 1
					For i=0 To ArraySize(InputBuffer$()) - 1
						InputBuffer$(i) = InputBuffer$(i+1)
					Next
					
					ReDim InputBuffer$(ArraySize(InputBuffer$())-1)
				Else
					Repeat
						Print(#CRLF$ + "> ")
						TempInputBuffer$ = Input()
						
						If AddNullAfterInputBuffer And Not ArraySize(InputBuffer$())
							ReDim InputBuffer$(Len(TempInputBuffer$))
							
							For i=1 To ArraySize(InputBuffer$())
								InputBuffer$(i-1) = Mid(TempInputBuffer$, i+1, 1)
							Next
							
							InputBuffer$(ArraySize(InputBuffer$())-1) = #Null$
							
							PokeA(*Cells + SP, Asc(Left(TempInputBuffer$, 1)))
						Else
							If Len(TempInputBuffer$) > 1
								ReDim InputBuffer$(Len(TempInputBuffer$) - 1)
								
								For i=1 To ArraySize(InputBuffer$())
									InputBuffer$(i-1) = Mid(TempInputBuffer$, i+1, 1)
								Next
								
								PokeA(*Cells + SP, Asc(Left(TempInputBuffer$, 1)))
							ElseIf Len(TempInputBuffer$) = 1
								PokeA(*Cells + SP, Asc(TempInputBuffer$))
							Else
								DebuggerWarning("No input given when asked !")
							EndIf
						EndIf
					Until Len(TempInputBuffer$)
				EndIf
			Else
				Define KeyPressed$
				
				Print(#CRLF$ + "> ")
				
				Repeat
					KeyPressed$ = Inkey()
					
					If KeyPressed$ <> ""
						PokeA(*Cells + SP, Asc(KeyPressed$))
					Else
						Delay(20)
					EndIf
				Until KeyPressed$ <> ""
				
				PrintN(Chr(PeekA(*Cells + SP)))
			EndIf
			
		Case "["
			If PeekA(*Cells + SP) = 0
				_BracketSearch(1)
			EndIf
			
		Case "]"
			If PeekA(*Cells + SP) <> 0
				_BracketSearch(-1)
			EndIf
			
		Case #CR$, #LF$, #CRLF$
			; Nothing (just here to make the debugger happy, he can be a little grumpy)
			
		Default
			DebuggerWarning("Unable to process instruction: "+
			                Instructions$(IP)) ;+" - 0d"+Instructions$(IP))
	EndSelect
	
	IP + 1
Wend


;-> End

Print(#CRLF$+#CRLF$+"Execution finished, please press enter to exit...")
Input()
FreeMemory(*Cells)
CloseConsole()

; IDE Options = PureBasic 5.62 (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 192
; FirstLine = 129
; Folding = -
; EnableXP
; CommandLine = -n