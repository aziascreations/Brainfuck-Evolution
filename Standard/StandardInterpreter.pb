; -----------------
; Brainfuck Basic Standard Interpreter
; 
; Revision: 0
; -----------------

;- Compiler directives

EnableExplicit


;- Header stuff and variables

; Amounts of bytes available at the start and by which the memory is expanded when needed.
#MEMORY_SIZE_INITIAL = 256
#MEMORY_SIZE_INCREMENT = 256

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
Dim Instructions.a(0)

; Used in the _BracketSearch() Macro to keep count of the nested loops.
Define BracketCount

; Path to the file that contains the bf code.
Define SourceFilePath$

; Temporary Variable(s) (Used in some loops)
Define Line$, CharPosition, i


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
		If Instructions(IP) = ']'
			BracketCount - 1
		ElseIf Instructions(IP) = '['
			BracketCount + 1
		EndIf
	Until BracketCount = 0
EndMacro


;- Procedures

Procedure PrintErrorMessage(Message$, Exitcode = -1)
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

Procedure DumpMemory()
	
EndProcedure


;- Program Code

;-> Console Preparation
If Not OpenConsole("Brainfuck Interpreter")
	MessageRequester("Fatal error", "Unable to open a console.", #PB_MessageRequester_Ok | #PB_MessageRequester_Error)
EndIf


;-> Allocating Memory
*Cells = AllocateMemory(#MEMORY_SIZE_INITIAL)
If Not *Cells
	PrintErrorMessage("Memory allocation failure !", 1)
EndIf


;-> Source file selection

SourceFilePath$ = "./hello-world.bf"
;SourceFilePath$ = OpenFileRequester("Please choose file to load", "./", "All files (*.*)|*.*", 0)

If SourceFilePath$ = #Null$ Or FileSize(SourceFilePath$) < 0
	PrintErrorMessage("File requester cancelled or invalid file !", 2)
EndIf


;-> Source file reading and "parsing"

If Not ReadFile(0, SourceFilePath$, #PB_Ascii)
	DebuggerError("Unable to read "+SourceFilePath$)
	End 2
EndIf

; Temporarely resizing the array to the size of the file.
ReDim Instructions(FileSize(SourceFilePath$))

While Eof(0) = 0
	Line$ = ReadString(0, #PB_Ascii)
	
	CharPosition = FindString(Line$, ";")
	If CharPosition
		Debug Line$
		Line$ = Left(Line$, CharPosition - 1)
		Debug Line$
	EndIf
	Line$ = ReplaceString(Line$, " ", "")
	
	For i=1 To Len(Line$)
		Instructions(IP) = Asc(Mid(Line$, i, 1))
		Debug Chr(Instructions(IP))
		IP + 1
	Next
Wend

CloseFile(0)
ReDim Instructions(IP)
IP = 0


;-> Main Interpreter Loop

While IP < ArraySize(Instructions()) And Instructions(IP) <> #Null
	Select(Instructions(IP))
		Case '+'
			PokeA(*Cells + SP, PeekA(*Cells + SP) + 1)
			
		Case '-'
			PokeA(*Cells + SP, PeekA(*Cells + SP) - 1)
			
		Case '>'
			SP + 1
			If SP >= MemorySize(*Cells)
				*OldCells = *Cells
				*Cells = ReAllocateMemory(*Cells, MemorySize(*Cells) + #MEMORY_SIZE_INCREMENT)
				
				If Not *Cells
					; TODO: Call a dump procedure
					FreeMemory(*OldCells)
					PrintErrorMessage("Memory reallocation failure !", 3)
				EndIf
				
				*OldCells = #Null
			EndIf
			
		Case '<'
			SP - 1
			If SP < 0 
				PrintErrorMessage("Memory Pointer out of range @"+Str(SP)+" !", 4)
			EndIf
			
		Case '.'
			Print(Chr(PeekA(*Cells + SP)))
			
		Case ','
			; TODO: Make an input buffer.
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
			
		Case '['
			If PeekA(*Cells + SP) = 0
				_BracketSearch(1)
			EndIf
			
		Case ']'
			If PeekA(*Cells + SP) <> 0
				_BracketSearch(-1)
			EndIf
			
		Case #CR, #LF
			; Nothing (just here to make the debugger happy)
			
		Default
			DebuggerWarning("Unable to process instruction: "+
			                Chr(Instructions(IP))+
			                " - 0d"+Str(Instructions(IP)))
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
; CursorPosition = 224
; FirstLine = 197
; Folding = -
; EnableXP
; DisableDebugger