XIncludeFile "./BrainfuckIO_Interpreter.pbi"

;-> Default Handlers (Optional)

; Default Output Handler
; It prints the character with the corresponding ascii character at [*Cells + SP].
; If RawOutput$ isn't empty, and RawOutputByteLength is different than zero, RawOutput$ will be printed instead.
; 
; Notes:
;   * This procedure assumes that *Instance isn't null since it should be null in the [Update(...) scope]
; 
; Returns:
;   Nothing
Procedure BFIODefaultOutputHandler(*Instance.BFIOInstance, RawOutput$, RawOutputLength, RawOutputByteLength)
	If RawOutput$ = #Null$ Or Not RawOutputByteLength
		Print(Chr(PeekA(*Instance\Cells + *Instance\SP)))
	Else
		Print(RawOutput$)
	EndIf
EndProcedure

; Should only manage inputs and nothing else like moving the SP !
; TODO: Clean the stuff in the highest nested ifs
; TODO: Handle the returned value !
Procedure.i BFIODefaultInputHandler(*Instance.BFIOInstance)
	Protected KeyPressed$, TempString$, TempBufferedInput$, i.i
	
	If *Instance\Config\UseBufferedInput
		; Is using buffered input
		
		If ArraySize(*Instance\InputBuffer$())
			; The input buffer still has stuff inside it.
			
			PokeA(*Instance\Cells + *Instance\SP, Asc(*Instance\InputBuffer$(0)))
			
			; Shift array left by 1
			For i=0 To ArraySize(*Instance\InputBuffer$()) - 1
				*Instance\InputBuffer$(i) = *Instance\InputBuffer$(i+1)
			Next
			
			ReDim *Instance\InputBuffer$(ArraySize(*Instance\InputBuffer$())-1)
		Else
			; The input buffer is empty
			
			Repeat
				TempString$ = #CRLF$ + "> "
				_HandleBFIOPrint(*Instance, TempString$)
				
				TempBufferedInput$ = Input()
				
				If *Instance\Config\AddNullAfterInputBuffer And Not ArraySize(*Instance\InputBuffer$())
					; TODO: ???
					
					ReDim *Instance\InputBuffer$(Len(TempBufferedInput$))
					
					For i=1 To ArraySize(*Instance\InputBuffer$())
						*Instance\InputBuffer$(i-1) = Mid(TempBufferedInput$, i+1, 1)
					Next
					
					*Instance\InputBuffer$(ArraySize(*Instance\InputBuffer$())-1) = #Null$
					
					PokeA(*Instance\Cells + *Instance\SP, Asc(Left(TempBufferedInput$, 1)))
				Else
					; TODO: ???
					
					If Len(TempBufferedInput$) > 1
						ReDim *Instance\InputBuffer$(Len(TempBufferedInput$) - 1)
						
						For i=1 To ArraySize(*Instance\InputBuffer$())
							*Instance\InputBuffer$(i-1) = Mid(TempBufferedInput$, i+1, 1)
						Next
						
						PokeA(*Instance\Cells + *Instance\SP, Asc(Left(TempBufferedInput$, 1)))
					ElseIf Len(TempBufferedInput$) = 1
						PokeA(*Instance\Cells + *Instance\SP, Asc(TempBufferedInput$))
					Else
						_HandleBFIOInternalWarning(*Instance, #BFIO_WARNING_EXEC_NO_INPUT_GIVEN)
					EndIf
				EndIf
			Until Len(TempBufferedInput$)
		EndIf
		
	Else
		; No buffered input.
		
		TempString$ = #CRLF$ + "> "
		_HandleBFIOPrint(*Instance, TempString$)
		
		Repeat
			KeyPressed$ = Inkey()
			
			If KeyPressed$ <> ""
				PokeA(*Instance\Cells + *Instance\SP, Asc(KeyPressed$))
			Else
				Delay(20)
			EndIf
		Until KeyPressed$ <> ""
		
		TempString$ = Chr(PeekA(*Instance\Cells + *Instance\SP)) + #CRLF$
		_HandleBFIOPrint(*Instance, TempString$)
	EndIf
	
	ProcedureReturn #False
EndProcedure

; TODO: Allow for raw data to be given (piping)
; TODO: Add optional null byte to signal string end ?
; INFO: Maybe keep a 4 byte buffer handy to output any char/raw data ?
; INFO: Don't print shit here except for the prompt !


;-> Getters & Setters

Procedure SetBFIOOutputHandler(*Instance.BFIOInstance, *Procedure.BFIOOutputCallback)
	If *Instance And *Procedure
		*Instance\OutputCallback = *Procedure
		ProcedureReturn #True
	EndIf
	
	ProcedureReturn #False
EndProcedure

Procedure SetBFIOInputHandler(*Instance.BFIOInstance, *Procedure.BFIOInputCallback)
	If *Instance And *Procedure
		*Instance\InputCallback = *Procedure
		ProcedureReturn #True
	EndIf
	
	ProcedureReturn #False
EndProcedure

Procedure SetBFIOErrorHandler(*Instance.BFIOInstance, *Procedure.BFIOErrorCallback)
	If *Instance And *Procedure
		*Instance\ErrorCallback = *Procedure
		ProcedureReturn #True
	EndIf
	
	ProcedureReturn #False
EndProcedure

Procedure SetBFIOWarningHandler(*Instance.BFIOInstance, *Procedure.BFIOWarningCallback)
	If *Instance And *Procedure
		*Instance\WarningCallback = *Procedure
		ProcedureReturn #True
	EndIf
	
	ProcedureReturn #False
EndProcedure

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 148
; FirstLine = 107
; Folding = --
; EnableXP