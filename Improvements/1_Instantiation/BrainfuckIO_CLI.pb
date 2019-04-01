; -----------------
; BrainfuckIO_CLI.pb ??? - // Standard Plus Interpreter
; 
; Revision: null on 30/3/19
; -----------------

;- Compiler directives

EnableExplicit

; Allows for easy identification of text file encoding.
; See the file or the readme for links and credits to the author and forum post.
;XIncludeFile "../../Includes/AutoDetectTextEncoding.pbi"
;UseModule dte

XIncludeFile "./BrainfuckIO_Interpreter.pbi"


;- Callbacks

;Define *ErrorCallback.BFIOErrorCallback

Procedure ErrorHandler(*Instance.BFIOInstance, ErrorCode)
	Debug ErrorCode
	
	; Should halt the update() procedure (won't increment the IP !)
	ProcedureReturn #True
EndProcedure

OpenConsole("aaa")

Define *Instance.BFIOInstance = CreateBFIOInstance()

If Not *Instance
	Debug "ERR1"
	End 1
EndIf

Define Code$ = ""

If ReadFile(0, "./Examples/hello-world-ansi.bfio", #PB_Ascii)
	While Not Eof(0)
      Code$ = Code$	+ ReadString(0) + #CR$
    Wend
	CloseFile(0)
Else
	Debug "ERR2"
	End 2
EndIf

;Debug "a"
LoadBFIOCode(*Instance, Code$, 0)
;Debug "b"


While UpdateBFIOInstance(*Instance)
	
Wend

PrintN(#CRLF$ + "End!")
Input()

CloseConsole()

End

; IDE Options = PureBasic 5.62 (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 65
; FirstLine = 28
; Folding = -
; EnableXP