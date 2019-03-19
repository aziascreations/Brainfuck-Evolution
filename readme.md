<h1>
	<img src="https://img.icons8.com/color/32/000000/critical-thinking.png"> Brainfuck Evolution (W.I.P)
	<a href="readme.md" title="English">
		<img align="right" width="32px" height="32px" vspace="8px" src="https://i.imgur.com/YjJ8Syw.png" alt="English">
	</a>
	<a href="readme-fra.md" title="Français">
		<img align="right" width="32px" height="32px" vspace="8px"src="https://i.imgur.com/ablvR3p.png" alt="Français">
	</a>
	<!--<a href="readme.md" title="English">
		<img align="right" width="32px" height="32px" vspace="8px"src="https://i.imgur.com/Tnb1YyP.png" alt="English (Current)">
	</a>
	<a href="readme-fra.md" title="Français">
		<img align="right" width="32px" height="32px" vspace="8px" src="https://i.imgur.com/GBx717J.png" alt="Français">
	</a>-->
</h1>

The goal of this project is to push the boundaries of what is achievable in Brainfuck while keeping [the spirit].

Even though the language is Turing complete, it still lacks many important features that would allow it to be used like any other programming languages in/for common modern computing tasks. <i>(eg: I/O, OS API calls, Modularity, ...)</i>

[more stuff + git page]

techincal details are mostly available in the text.

## Summary

* Brainfuck recap
* Project Goals &/ Milestones ? why ?
* [Interpreters](#interpreters)
	* [Standard](#standard)
	* [Standard Plus](#standard-plus)
	* [Standard Emoji](#standard-emoji)
* Something ?
* Credits
* [License](#license)

## Interpreters

This is list of every interpreter in this repo, in the same order as the "article".

Every interpreter can be downloaded separately in the release section if you choose to do so.

[Some may depend on others, changes may aplly to others if made later in the project.]

### Standard
A regular interpretor that can interpret any standard ANSI encoded text files that contains Brainfuck code.

It has no buffered input, and will pause everytime you have to input something while adding a new line, and it will always open a file requester window for the source file.

This one is mainly kept separate to show what "the bare minimum" is for an interpretor.

<!--<table>
	<tr>
		<td colspan="420"><b>Downloads</b></td>
	</tr>
	<tr>
		<td>
			<p align="center">
				<a href="#">
					<img src="https://i.imgur.com/sAtIUZh.png" alt="Deb Pkg Logo" height="48px"><br>
				</a>
				Zip Archive<br>
			</p>
		</td>
		<td>
			<p align="center">
				<a href="#">
					<img src="https://i.imgur.com/UMjH2WD.png" alt="Windows 10 Logo" height="48px"><br>
				</a>
				Windows Executable<br>
			</p>
		</td>
	</tr>
</table>
<br>-->


### Standard Plus

Same as the standard one, but it brings some QOL improvement:
* CLI parameters (Rudimentary for the moment due to unfinished include)
* UTF8/Unicode support (See Credits section @ filename.pbi)
* Buffered Input (POC + Base for later interpreters)
* Fixed error/exit codes
* TODO: Debugger? (Only if gui, cli ui is annoying?)
* More ?
* Some minor stuff

MISSING THE IN BUFF, in main loop.
and the instc array is still a .c type (the select too)

Mostly used a a base for all the other extensions and as a "decent" standalone cli interpreter.


### Standard Emoji 

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
</table>


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



## License
This project is licensed under the [Apache V2](LICENSE) license.

And, the software is provided "as is", without warranties or conditions of any kind.
