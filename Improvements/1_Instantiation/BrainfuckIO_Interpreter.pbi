; -----------------
; BrainfuckIO_Interpreter.pbi ??? - // Standard Plus Interpreter
; 
; Revision: null on 30/3/19
; -----------------

;- Compiler directives

EnableExplicit

; TODO: Change name to Instances and Callbacks (execution flow control) ?

; TODO: Maybe add a basic set of instrs for linux to handles basic IO shit, or combine them:
; if FileExists Then ....
; If ReadFile() >> gives 0 in return to BFIO
; Then it is fucked or close it and continue ?

; TODO: Handle misplaced / uneven brackets (on load with warning ?)

; TODO: Maybe move the mem size init and increments into the structure itself and config stuff.

;- - - - - - - - - - - - - - - - - - - -
;- Header

;-> Constants

;-> > Error codes

;#BFIO_RETURN_NO_ERROR = 0 ; Unused, but it's the same as #False which means that the execution has not finished.
;#BFIO_RETURN_NOT_FINISHED = #BFIO_RETURN_NO_ERROR
#BFIO_RETURN_EXECUTION_FINISHED = 1 ; Returned when update() reached the end

; Ignore this !
; 2-9 Unrecoverable errors (Fatal)
;#BFIO_ERROR_NO_CONSOLE = 2 ; The interpreter itself doesn't deal with console handles (Except the output :/ )
;#BFIO_ERROR_NO_CONSOLE_HANDLE = 3 ; Same
; Invalid config (could be raised earlier with warnings)

; 10-49 - Initialization errors
#BFIO_ERROR_INIT_MALLOC = 10 ; Failed to allocate memory for *Instance
#BFIO_ERROR_INIT_CELLS_MALLOC = 11 ; Failed to allocate memory for *Instance\Cells

; 50-199 - Execution error
#BFIO_ERROR_EXEC_NULL_INSTANCE_POINTER = 50
#BFIO_ERROR_EXEC_CELLS_REALLOC = 51
#BFIO_ERROR_EXEC_OUT_OF_RANGE_STACK_POINTER = 52
;#BFIO_ERROR_EXEC_NULL_POINTER = 50

; 200-249 - Buffers ?

; 250-299 - Files ?


; Will be dealt with when I get around to the input part !
; Might be moved in the 100-199 range with all the future buffers
; 20-29 Cells Memory errors
;#BFIO_ERROR_INPUT_BUFFER_MALLOC = 20
;#BFIO_ERROR_INPUT_BUFFER_REALLOC = 21


; Not sure what to do with those for the moment...
; #EXIT_CODE_FILE_INVALID = 40 ; Might be important for modular/dynamic code loading
; #EXIT_CODE_UNSUPORTED_FILE_ENCODING = 41
; #EXIT_CODE_FILE_ENCODING_DETECTION_FAILURE = 42
; #EXIT_CODE_FILE_READ_ERROR = 43
; #EXIT_CODE_NO_FILE_GIVEN = 44

;-> > Warning codes

; 2-49 Unused

; 50-199 - Execution error
#BFIO_WARNING_EXEC_UNHANDLED_INSTRUCTION = 50
#BFIO_WARNING_EXEC_ALREADY_FINISHED = 51
#BFIO_WARNING_EXEC_NO_OUTPUT_HANDLER = 52
; Should this one be an error since inputs are kinda required, and not outputs ?
#BFIO_WARNING_EXEC_NO_INPUT_HANDLER = 53
#BFIO_WARNING_EXEC_NO_INPUT_GIVEN = 54
#BFIO_WARNING_CONFIG_IDK = 2 ; When a given config doesn't seem right


;-> > Misc
; Amounts of bytes available at the start and by which the memory is expanded when needed.
#MEMORY_SIZE_INITIAL = 256
#MEMORY_SIZE_INCREMENT = 256


;-> Structures

; Flags could be used, but I'm not working with 64k of RAM, so this will do just fine.
Structure BFIOInstanceParameters
	; Might be moved in the cli thingy.
	AddNullAfterInputBuffer.b ; = #False
	UseBufferedInput.b ; = #True
EndStructure

Structure BFIOInstance
	; Standard BF variables
	SP.q
	IP.q
	*Cells
	Array Instructions$(0)
	
	; BFIO stuff
	Config.BFIOInstanceParameters
	
	*OutputCallback.BFIOOutputCallback
	*InputCallback.BFIOInputCallback
	*ErrorCallback.BFIOErrorCallback
	*WarningCallback.BFIOWarningCallback
	
	; TODO: A structure of buffers and file id index for later ?
	; How would the array work if used in C ?
	; TODO: Use a memory ptr ?
	Array InputBuffer$(0)
EndStructure


;-> Prototypes

; void BFIOOutputCallback(...)
; Maybe allow string to be given so you can output from the Stack or by Raw input ?
;Prototype BFIOOutputCallback(*Instance.BFIOInstance) ;, Output$, OutputLength.i, OutputByteLength.i) ; encoding ?

Prototype BFIOOutputCallback(*Instance.BFIOInstance, RawOutput$, RawOutputLength, RawOutputByteLength) ;, Output$, OutputLength.i, OutputByteLength.i) ; encoding ?

Prototype.i BFIOInputCallback(*Instance.BFIOInstance)

; Return error/warn in a pointer value, and return the number of stuff written ?
; - kinda useless, just return the error and an optonal error ?
; - Kinda inconsistent :/
; - For the out or warning ???

; int BFIOErrorCallback(...)
Prototype.i BFIOErrorCallback(*Instance.BFIOInstance, ErrorCode) ;, ErrorMessage$) ; + msglen, msgbytelen

; Should only be used when debugging or if you are a bit paranoid
; Nothing bad should be pushed here.
Prototype.i BFIOWarningCallback(*Instance.BFIOInstance, WarningCode) ;, WarningMessage$) ; + msglen, msgbytelen



;- - - - - - - - - - - - - - - - - - - -
;- Macros

; All macros assume that Instance is not null and is a .BFIOInstance *ptr

; Macro originally taken from rosetta code and adapted for this project.
; See: https://rosettacode.org/wiki/Execute_Brain****/PureBasic
; Direction: 1=forward -1=Backward
Macro _BFIOBracketSearch(Instance, Direction = 1)
	; Start counting with the current bracket
	BracketCount = Direction
	
	; Count nested loops until a matching one is found.
	Repeat
		; Moving the IP in the right direction
		Instance\IP + Direction
		If Instance\Instructions$(Instance\IP) = "]"
			BracketCount - 1
		ElseIf Instance\Instructions$(Instance\IP) = "["
			BracketCount + 1
		EndIf
	Until BracketCount = 0
EndMacro

Macro _HandleBFIOPrint(Instance, RawOutput="")
	If Instance\OutputCallback <> #Null
		CallFunctionFast(Instance\OutputCallback, Instance, @RawOutput, Len(RawOutput), StringByteLength(RawOutput))
		;CallFunctionFast(Instance\OutputCallback, Instance)
	Else
		DebuggerWarning("Warning: No output callback is set for the instance !")
		_HandleBFIOInternalWarning(Instance, #BFIO_WARNING_EXEC_NO_OUTPUT_HANDLER)
	EndIf
EndMacro

Macro _HandleBFIOInput(Instance)
	If Instance\InputCallback <> #Null
		CallFunctionFast(Instance\InputCallback, Instance)
	Else
		DebuggerWarning("Warning: No input callback is set for the instance !")
		_HandleBFIOInternalWarning(Instance, #BFIO_WARNING_EXEC_NO_INPUT_HANDLER)
	EndIf
EndMacro

; Only warns and let the controller interupt the execution if needed, not really nescessary, but meh...
Macro _HandleBFIOInternalWarning(Instance, WarningCode)
	If Instance\WarningCallback <> #Null
		If CallFunctionFast(Instance\WarningCallback, Instance, WarningCode)
			ProcedureReturn WarningCode
		EndIf
	Else
		DebuggerWarning("A warning was raised with the following code for BFIO: " + WarningCode)
	EndIf
EndMacro

; Used when an error should be given to the error handler.
; If the error handler doesn't return #False, the execution will continue.
; Otherwise the value returned will also be returned.
Macro _HandleBFIOInternalError(Instance, ErrorCode)
	If Instance\ErrorCallback <> #Null
		If CallFunctionFast(Instance\ErrorCallback, Instance, ErrorCode)
			ProcedureReturn ErrorCode
		EndIf
	Else
		ProcedureReturn ErrorCode
	EndIf
EndMacro

; Because fuck you
Macro Yeet
	ProcedureReturn
EndMacro


;- - - - - - - - - - - - - - - - - - - -
;- Procedures

;-> Core

; In the helpers, make macro and procedures versions

; And separate the advanced doc in it's own folder.

; TODO: Change To allocate since it' not an helper
Procedure CreateBFIOInstance()
	Protected *Instance.BFIOInstance
	
	*Instance = AllocateStructure(BFIOInstance)
	
	If *Instance
		*Instance\Cells = AllocateMemory(#MEMORY_SIZE_INITIAL) ;#MEMORY_SIZE_INITIAL)
		If Not *Instance\Cells
			;PrintErrorMessage("Memory allocation failure !", #EXIT_CODE_MALLOC_ERROR_CELLS)
			FreeStructure(*Instance)
			ProcedureReturn #Null
			;*Instance = #EXIT_CODE_MALLOC_ERROR_CELLS
		EndIf
		
		;*Instance\OutputCallback = @BFIODefaultOutputHandler()
		;*Instance\InputCallback = @BFIODefaultInputHandler()
		
		*Instance\Config\UseBufferedInput = #True
		
		; Warning and error handlers should be set manually.
	EndIf
	
	ProcedureReturn *Instance
EndProcedure

Procedure.i CreateBFIOInstance2(*Instance.BFIOInstance)
	
EndProcedure

Procedure FreeBFIOInstance(*Instance.BFIOInstance)
	If *Instance
		If *Instance\Cells
			FreeMemory(*Instance\Cells)
		EndIf
		
		FreeStructure(*Instance)
	EndIf
EndProcedure

; ? #PB_Ignore or #PB_Default
; CleanString bool/flag in Mode.i ? (Or raw string with cleaning on by default ?)
; Return the number of instructions written or the error ?
; TODO: Clean array
; Skip after # ->  ++--<< # My shit.
Procedure LoadBFIOCode(*Instance.BFIOInstance, Code$, Mode.i, Position.i = -1)
	Protected Line$, Char$
	Protected i.i, j.i
	
	If Not *Instance
		DebuggerWarning("Null pointer given in LoadBFIOCode() !")
	EndIf
	
	; Cleaning String
	While FindString(Code$, #CRLF$)
		Code$ = ReplaceString(Code$, #CRLF$, #CR$)
	Wend
	While FindString(Code$, #CR$+#CR$)
		Code$ = ReplaceString(Code$, #CR$+#CR$, #CR$)
	Wend
	
	;Debug "Cleaning ficnished !"
	
	; Reading code into array
	ReDim *Instance\Instructions$(Len(Code$))
	*Instance\IP = 0
	
	For i=1 To CountString(Code$, #CR$)
		Line$ = ReplaceString(StringField(Code$, i, #CR$), " ", "")
		
		; Ignore comments
		If Left(Line$, 1) = "#" ; Len() == 1 is always true, except for the last one.
			Continue
		EndIf
		
		For j=1 To Len(Line$)
			*Instance\Instructions$(*Instance\IP) = Mid(Line$, j, 1)
			*Instance\IP + 1
		Next
	Next
	
	ReDim *Instance\Instructions$(*Instance\IP)
	*Instance\IP = 0
	
	ProcedureReturn #True
EndProcedure

Procedure LoadBFIOCodeFromFile(*Instance.BFIOInstance, FilePath$, Mode.i, Position.i = -1, FileEncoding = -1)
	ProcedureReturn #True
EndProcedure


; Returns non-zero if not finished
; TODO: note about how early the procedure can end if an error/warning is raised.
Procedure.i UpdateBFIOInstance(*Instance.BFIOInstance)
	; Used for ">" in case the memory reallocation fails.
	Protected *OldCells
	
	; Used in the _BFIOBracketSearch() Macro to keep count of the nested loops.
	Protected BracketCount
	
	If *Instance
		;Debug "SP: "+*Instance\SP
		
		If *Instance\IP < ArraySize(*Instance\Instructions$()) And *Instance\Instructions$(*Instance\IP) <> #Null$
			Select(*Instance\Instructions$(*Instance\IP))
				Case "+"
					PokeA(*Instance\Cells + *Instance\SP, PeekA(*Instance\Cells + *Instance\SP) + 1)
				Case "-"
					PokeA(*Instance\Cells + *Instance\SP, PeekA(*Instance\Cells + *Instance\SP) - 1)
					
				Case ">"
					*Instance\SP + 1
					If *Instance\SP >= MemorySize(*Instance\Cells)
						*OldCells = *Instance\Cells
						*Instance\Cells = ReAllocateMemory(*Instance\Cells, MemorySize(*Instance\Cells) + #MEMORY_SIZE_INCREMENT) ;#MEMORY_SIZE_INCREMENT)
						
						; TODO: check if the extension is long enough (0) and raise en error accordingly !
						
						If Not *Instance\Cells
							*Instance\Cells = *OldCells
							_HandleBFIOInternalError(*Instance, #BFIO_ERROR_EXEC_CELLS_REALLOC)
						EndIf
					EndIf
				Case "<"
					*Instance\SP - 1
					If *Instance\SP < 0
						_HandleBFIOInternalError(*Instance, #BFIO_ERROR_EXEC_OUT_OF_RANGE_STACK_POINTER)
					EndIf
					
				Case "["
					If PeekA(*Instance\Cells + *Instance\SP) = 0
						_BFIOBracketSearch(*Instance, 1)
					EndIf
				Case "]"
					If PeekA(*Instance\Cells + *Instance\SP) <> 0
						_BFIOBracketSearch(*Instance, -1)
					EndIf
					
				Case "."
					_HandleBFIOPrint(*Instance)
				Case ","
					_HandleBFIOInput(*Instance)
					
				Default
					DebuggerWarning("Unhandled instruction ! -> "+*Instance\Instructions$(*Instance\IP))
					_HandleBFIOInternalWarning(*Instance, #BFIO_WARNING_EXEC_UNHANDLED_INSTRUCTION)
			EndSelect
			
			*Instance\IP + 1
		Else
			; Has reached the end, the procedure shouldn't have been called in the first place !
			DebuggerWarning("UpdateBFIOInstance() was called with an already finished instance !")
			_HandleBFIOInternalWarning(*Instance, #BFIO_WARNING_EXEC_ALREADY_FINISHED)
		EndIf
	Else
		_HandleBFIOInternalError(*Instance, #BFIO_ERROR_EXEC_NULL_INSTANCE_POINTER)
		
		; Just here in case the execution continues past the error handler. (Avoids an invalid memory access error)
		Yeet #False ; This bitch's empty !
	EndIf
	
	ProcedureReturn Bool(*Instance\IP < ArraySize(*Instance\Instructions$()) And *Instance\Instructions$(*Instance\IP) <> #Null$)
EndProcedure

;- - - - - - - - - - - - - - - - - - - -

; IDE Options = PureBasic 5.62 (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 240
; FirstLine = 212
; Folding = ---
; EnableXP
; CommandLine = -n