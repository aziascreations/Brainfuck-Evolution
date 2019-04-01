<h1>
	<img src="https://img.icons8.com/color/32/000000/critical-thinking.png"> Brainfuck - IO Evolution [Journey, or move the IO to the first section ?]
	<!--<a href="readme.md" title="English">
		<img align="right" width="32px" height="32px" vspace="8px" src="https://i.imgur.com/YjJ8Syw.png" alt="English">
	</a>
	<a href="readme-fra.md" title="Français">
		<img align="right" width="32px" height="32px" vspace="8px"src="https://i.imgur.com/ablvR3p.png" alt="Français">
	</a>-->
	<!--<a href="readme.md" title="English">
		<img align="right" width="32px" height="32px" vspace="8px"src="https://i.imgur.com/Tnb1YyP.png" alt="English (Current)">
	</a>
	<a href="readme-fra.md" title="Français">
		<img align="right" width="32px" height="32px" vspace="8px" src="https://i.imgur.com/GBx717J.png" alt="Français">
	</a>-->
</h1>

The goal of this project is to push the boundaries of what is achievable in Brainfuck sticking to some of the core principles of the language.

Even though Brainfuck is technically Turing complete, it still lacks many important features that would allow it to be used like any other programming languages for common modern computing tasks. <i>(eg: I/O access, OS API calls, Modularity, [add more], ...)</i>

The project was done [with text related to it]<br>
[more stuff + git page]<br>
techincal details are mostly available in the text.

TODO: Change the structure again to have all the interpreters in one master folder and each subfolder is a variant/improvement !!!

The end goal is BFIO and a version of it is available in this repo too as a clean and full one.
And fully docummented since the readme for it is as long as this one.

TODO: Cut the shit and add a See the "[Project Description and Goals](#)" section for more info.

## Summary

&nbsp;&nbsp;&nbsp;&nbsp;● [What is Brainfuck ?](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;● [Project Description and Goals](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;● [Interpreters](#interpreters)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⚬ [Standard](#standard)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Standard Basic](#standard-plus)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Standard Plus](#standard-emoji)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⚬ [Iterative Improvements](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Instance](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Interpreter directives](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Better char support](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Buffers](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [I/O & File Access](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;● Something ?<br>
&nbsp;&nbsp;&nbsp;&nbsp;● Credits<br>
&nbsp;&nbsp;&nbsp;&nbsp;● [License](#license)<br>

<!--◾◽-->

## Interpreters

This is list of every interpreter in this repo, in the same order as the "article".

Every interpreter can be downloaded separately in the release section if you choose to do so.

[Some may depend on others, changes may aplly to others if made later in the project.]
<br><br>


### Standard 

The 2 standard interpreters follow the blah blah blah...

The first one is a barebone implementaiion, a POC.
The second one is pretty much the same with a few aditions that still follow the standard pretty much.

None of them are really good as standalones since they mostlly serves as bases (codebase/framework/reference???) for the rest of the project.
<br><br>

#### Standard Basic
A regular interpretor that can interpret any standard ANSI encoded text files that contains Brainfuck code.

It has no buffered input, and will pause everytime you have to input something while adding a new line, and it will always open a file requester window for the source file.

This one is mainly kept separate to show what "the bare minimum" is for an interpretor and is a base for all the other interpretors in this repo.

TODO: A note about the main loop from rosetta code compared the the java one.

The only notable divergence from the "standard" is the fact that any char. after a ';' on a line is ignored, making links and ponctuation in comments possible.

<!--
For the os libraries, interpreter directives could be used, but it isn't really odular enough and could cause problems when loading code pages with different fixed stuff
And who wouldn't want to explore a dll with brainfuck (list functions + example)
Add a note about jumping straight to the important part (final)
The changes are more iterative and are kept separate here since ech addition will be explained in the paper and so they will be used as references.
-->

<hr>

#### Standard Plus

Same as the standard one, but it brings some QOL improvement:
* Basic CLI parameters. <sup>1</sup>
* UTF8 & Unicode support. <sup>2</sup>
	* Source code encoding is automatically detected.
	* The input characters can be encoded in non-ascii, but only the first byte of each char will be given when using <code>,</code> !
* Buffered Input, with optional (opt-in) trailling null byte.
* Fixed exit codes.
* Some minor stuff

<sup>1</sup>: Some stuff about cli-args.pb not being finished.
<sup>2</sup>: Some stuff about the encoding detection.

The input buffer only supports strings, not raw data (an option for that will be added later).

Mostly used as a base for all the other extensions.<br>
It's use as a standalone interpreter is not recommended if you use it [alone ?].

#### Examples:
* [hello-world-ansi.bf](StandardPlus/hello-world-ansi.bf) - Hello world encoded in ANSI
* [hello-world-utf8-signed.bf](StandardPlus/hello-world-utf8-signed.bf) - Hello world encoded in Signed UTF8
* [buffered-input-utf8-signed.bf](StandardPlus/buffered-input-utf8-signed.bf) - Asks for some inputs, 5 times or less
* [null-byte-string-utf8-signed.bf](StandardPlus/null-byte-string-utf8-signed.bf) - String stuff

<!--<hr>

#### Standard Emoji 

This interpreter is mostly the same as the [Standard Plus](#standard-plus) one, except that all the instructions are replaced by emojis.

This interpreter is more of a proof of concept for non-ascii instructions support and [mult instr glyphs].
it is this way since appart from the joke theres not much more to it, for now.

Will not support ascii and unicode or utf8 support might get murky

It mostly stem from a logical idea [f.ing it up and for fun] that Me and pajowu had around the same time [separately]
I took some of his and added more

See https://github.com/pajowu/emojy

<table>
	<tr>
		<td><b>Bf</b></td>
		<td><b>Emoji</b></td>
	</tr>
	<tr>
		<td>+</td>
		<td>⬆ 👍 👆 ☝ 🖕</td>
	</tr>
	<tr>
		<td>-</td>
		<td>⬇ 👎 👇</td>
	</tr>
	<tr>
		<td>&gt;</td>
		<td>➡ ▶ 👉</td>
	</tr>
	<tr>
		<td>&lt;</td>
		<td>⬅ ◀ 👈</td>
	</tr>
	<tr>
		<td>.</td>
		<td>👄 ❕ ❗ 📣 📢</td>
	</tr>
	<tr>
		<td>,</td>
		<td>👂 ❔ ❓</td>
	</tr>
	<tr>
		<td>[</td>
		<td>🔁</td>
	</tr>
	<tr>
		<td>]</td>
		<td>↩ 🔙 🔚</td>
	</tr>
</table>-->


<br>

### Interlude ?

[Add the note about iterative stuff here]

Instead of using new commands to control the charset used, use the interpreter directives to switch and when combined with flow and code control, it can easily be switched on the fly.

TODO: Check the extended BF for pointers and code control instead oof shitty includes (and flow ctrl too) !


888 NOtem insteqd of using nez co;;qnds to choose bet

<br>

### Improced Interpreter

[Add the note about iterative stuff here]

The changes applied and separated here should mostly, if not only, take place in the intrerpreter and not in surrounding/includers.

This fact becomes relevant with the first improvement, since most of them will not affect the cli part. (includer)


#### Instances
Making parts of the interpreter modular for later, this is easier this way to separate the changes.<br>
This change might seem a bit big and unnessary/overdue/overdone for this, but it is motly done for later improvements.



In ImprovedIterations/Instances/

Created structures
Now uses console handles instead of purebasic default stuff. (will mostly be used later)

TALK ABOUT THE SEPARATION !!!

Mostly is about preparing for the massive extensions for later, making room and acomodating in advance for them.

#### Interpreter directives

#! param1;param2

Default options: InputBuffer;NullByte;NoDynamicDirectives;ANSIChars;NoShowWarnings;WarningSTDErr

InputBuffer <> NoInputBuffer

NullByte <> NoNullByte

DynamicDirectives <> NoDynamicDirectives

ANSIChars || UnicodeChars || UTF8Chars

ShowWarnings <> NoShowWarnings

WarningSTDErr || WarningSTDOut


TODO: Add a clean separation between simple char and string switches, different char ?

#### Improved [charset] support

Should be done in the includer ?

#### Buffers


#### IO & File access



### Notes

For each new instructions, at least a standard qwerty char/instr
Or an ALT+x combination
Alt +02D9



TO use standard bf, you really have to generate a script and read the output or stuff (usage with the standard one)

### Buffers buffers and buffers, there can never be too many.

This interpreter add just a "simple" feature, buffers.

It is also the first int. in this list to add new instructions to manipulate the buffers and new behaviour to the commands, boosting the complexity (return values from instructions).

* Input
* Output (Optional, '.' will act the same or can be changed to pick a char from the buffer each call, may then return the value wrote in the current cell)
* More for later. (reserve some characters, maybe not here, will spoil the thing)



<!--

Note about the core spirit and it being one char per instrucion and no 2 parts instrs

DLL
Like kids, they grow and have to go somewhere else joke in the text

FS access
Now we are getting in the fun no-go/danger zone

Module loaded in the main loop

## What after

BF OS, ...
-->

## Credits

File encoding detector

Rosetta code snippet

## License
This project is licensed under the [Apache V2](LICENSE) license.

And, the software is provided "as is", without warranties or conditions of any kind.
