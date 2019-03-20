; Simply asks you to enter something and prints it back, 5 times

; "IMPORANT: Make sure you use -n when launching otherwise you're stuck in an endless loop...\n\nPlease enter some text:"
; From: https://copy.sh/brainfuck/text.html
-[------->+<]>.++++.+++.-.+++.--[->++++<]>+.+++++++++++++.++++++.[--->++<]>++.[-->+<]>+++.++++++[->++<]>+.-[------>+<]>-.++++++++++.------.--[--->+<]>-.---[->++++<]>-.++.---.-------------.--[--->+<]>-.--[->++++<]>+.----------.++++++.-[---->+<]>+++.---[->++++<]>+.--.++++[->+++<]>.--[--->+<]>-.--[-->+++<]>.-[-->+++++<]>.-[->+++++<]>-.--[->++++<]>-.+[->+++<]>.---.+++++++++.-[->+++++<]>-.++[--->++<]>.-----------.--[--->+<]>.-------.-----------.+++++.+.+++++.-------.-[--->+<]>--.+++++[->+++<]>.+++++.------------.---.+++++++++++++.+++++.+[->+++<]>+.++++++++++.++++[->+++<]>.--[--->+<]>-.--[->++++<]>+.----------.++++++.[--->+<]>.-[->+++<]>.-------------.--[--->+<]>-.---[->++++<]>-.+.+.+[->+++<]>+.++++++++.-[++>---<]>+.-[--->++<]>-.+++++.-[->+++++<]>-.[->+++<]>+.+++++++++++++.-[->+++++<]>-.+[->+++<]>++.+++++++++.----------.++++++++.-------.[--->+<]>----..+[---->+<]>+++.++[--->++<]>.+++..+.[->+++++<]>--...>++++++++++..[->++++++++<]>.+[--->++++<]>.-------.----.--[--->+<]>--.++++[->+++<]>.--[--->+<]>-.+[->+++<]>++.+++++++++.++++++.+++[->+++<]>.+++++++++++++.[-->+++++<]>+++.---[->++++<]>-.----.--.--------.--[--->+<]>-.---[->++++<]>.+++[->+++<]>.[--->+<]>+.----.[-->+<]>.

; Getting out of the used cells from the text.
; This will put us in a cell with a value of 0.
; Note got some weird errors, probably due to the text part above
[>]

; And now we fill the next with wathever data comes in.
; We move forward once to keep a "loop killer" for later
[-] >

,[>,]

; Note the last cell will be at 0, not one since it is overwritten by the null byte !
; When the null byte is reached, we go back.
<[<]
++++++++++.
>[.>]
