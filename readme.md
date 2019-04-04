<h1>
	<img src="https://img.icons8.com/color/32/000000/critical-thinking.png"> Brainfuck IO - 
	<sub><sup>Bringing pure crazy and sensitive data together</sup></sub>
	<!----><a href="readme.md" title="English">
		<img align="right" width="32px" height="32px" vspace="8px" src="https://i.imgur.com/YjJ8Syw.png" alt="English">
	</a>
	<!--<a href="readme-fra.md" title="Français">
		<img align="right" width="32px" height="32px" vspace="8px"src="https://i.imgur.com/ablvR3p.png" alt="Français">
	</a>-->
	<!--<a href="readme.md" title="English">
		<img align="right" width="32px" height="32px" vspace="8px"src="https://i.imgur.com/Tnb1YyP.png" alt="English (Current)">
	</a>
	<a href="readme-fra.md" title="Français">
		<img align="right" width="32px" height="32px" vspace="8px" src="https://i.imgur.com/GBx717J.png" alt="Français">
	</a>-->
</h1>

This project follows the evolution of Brainfuck IO from a standard interpreter to what it should be in the end.

Each step will add something new and blah blah blah...

Bringing Barinfuck in the 21st century by giving it access to important ...

A final version of this project is available in the following repo: ...

The end goal is BFIO and a version of it is available in this repo too as a clean and full one.
And fully docummented since the readme for it is as long as this one.

## Summary

&nbsp;&nbsp;&nbsp;&nbsp;● [What is Brainfuck ?](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;● [Project Description and Goals](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;● [Interpreters](#interpreters)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⚬ [Standard](#standard)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Standard Basic](#standard-basic)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Standard Plus](#standard-plus)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⚬ [Iterative Improvements](#iterative-improvements)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Instantiation](#instantiation)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Interpreter directives](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Better char support](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [Buffers](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◾ [I/O & File Access](#)<br>
&nbsp;&nbsp;&nbsp;&nbsp;● Something ?<br>
&nbsp;&nbsp;&nbsp;&nbsp;● Credits<br>
&nbsp;&nbsp;&nbsp;&nbsp;● [License](#license)<br>
<br>

## Project Description and Goals

### Goal
The goal of this project is to push the boundaries of what is achievable in Brainfuck while keeping most of the core principles of the language.<br>
And ???

### Why ?
Even though Brainfuck is technically Turing complete, it still lacks many important features that would allow it to be used like any other programming languages for common modern computing tasks. <i>(eg: I/O access, OS API calls, Modularity, [add more], ...)</i><br>
So that is why we added them.
<br><br>

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
<br><br>

<!--
For the os libraries, interpreter directives could be used, but it isn't really odular enough and could cause problems when loading code pages with different fixed stuff
And who wouldn't want to explore a dll with brainfuck (list functions + example)
Add a note about jumping straight to the important part (final)
The changes are more iterative and are kept separate here since ech addition will be explained in the paper and so they will be used as references.
-->

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

<hr>
<br>

### Interlude ?

[Add the note about iterative stuff here]

Instead of using new commands to control the charset used, use the interpreter directives to switch and when combined with flow and code control, it can easily be switched on the fly.

TODO: Check the extended BF for pointers and code control instead oof shitty includes (and flow ctrl too) !


888 NOtem insteqd of using nez co;;qnds to choose bet
<br><br>


### Iterative Improvements

[Add the note about iterative stuff here]

The changes applied and separated here should mostly, if not only, take place in the intrerpreter and not in surrounding/includers.

This fact becomes relevant with the first improvement, since most of them will not affect the cli part. (includer)
<br><br>


#### Instantiation

This change separates the core and application parts of the interpreter in separate files.<br>

The core is what

Making parts of the interpreter modular for later, this is easier this way to separate the changes.<br>
This change might seem a bit big and unnessary/overdue/overdone for this, but it is motly done for later improvements.


They are called handlers even tho the are technically callbacks
In ImprovedIterations/Instances/

Created structures
Now uses console handles instead of purebasic default stuff. (will mostly be used later)

TALK ABOUT THE SEPARATION !!!

Mostly is about preparing for the massive extensions for later, making room and acomodating in advance for them.

Still has that problem with the input buffer where multi byte chars will only use the first one !
<br><br>


#### Interpreter directives

#! param1;param2

---
OS detection/requirement ??? - Later, with the libs since that's when it will be platform dependant.
-> static libs ? - Could make a nice middleground :/

Files, only with os libs ???

Move back n cell by current amount ? - How to handle it for >1 bytes numbers ?

---

Default options: InputBuffer;NullByte;NoDynamicDirectives;ANSIChars;NoShowWarnings;WarningSTDErr

InputBuffer <> NoInputBuffer

NullByte <> NoNullByte

DynamicDirectives <> NoDynamicDirectives

ANSIChars || UnicodeChars || UTF8Chars

ShowWarnings <> NoShowWarnings

WarningSTDErr || WarningSTDOut


TODO: Add a clean separation between simple char and string switches, different char ?
<br><br>


#### Improved [charset] support

Should be done in the includer ?
<br><br>


#### Buffers
aa
<br><br>


#### IO & File access
aa
<br><br>


#### Variable cell size ?
aa
<br><br>


#### Tools
Minifier, ???


### Notes

For each new instructions, at least a standard qwerty char/instr
Or an ALT+x combination ?
Alt +02D9
Kinda annoying...

Most of the doc will be in the respective interpreter folder (in the iterations only ?) and will each add to it, so copy and add and no looking trought every one.

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
