# GoSmartKeyboard


Copyright [Kevin Froman](https://chaoswebs.net/) [Licensed under GPLv3](LICENSE.md)

Work in progress

--- version
0.0.1 
---


# Introduction

GoSmartKeyboard is a daemon that allows you to have a more powerful keyboarding experience. It can be used with a secondary device, such as an Android phone or a raspberry pi, or it can run locally. A seperate client binary is provided that reads from a FIFO (named pipe) and sends the data to the server. This allows you to use any program that can write to a FIFO as a source of keyboard input.


This is done with a simple websocket server meant to accept a single connection, authenticate it, and stream UTF16 characters and send them as key strokes into the window manager. **With a simple daemon like this we can enhance keyboarding with inteligent features.**

Be careful with online games, as they may interpret the keystrokes as cheating. I assume if you don't send keystrokes or more accurately than a human you should be fine, but don't blame the software if you get banned.


**See [Building.md](Building.md) for instructions on how to build this [literate](https://en.wikipedia.org/wiki/Literate_programming) project.**


## What can you do with it?

Examples of what you can do:

* Run dictation software on a separate device
* Typical macros
* Buffer typed text before sending it to the server, preventing invalid commands or input. 
* Clever CLI tricks, think `vim` or `cowsay` on your keyboard!
* Isolated password manager
* One Time Passwords
* Virtual keyboard switch (keyboard multiplexer)
* Typing things into VMS, or transfering text based files to VMs/servers.
* Text storage, such as configuration or SSH pubkeys
* On-the-fly spell checking or translation
* On-the-fly encryption (ex: PGP sign every message you type), isolated from the perhaps untrusted computer
* Easy layout configuration
* Key logging
* Delay keystrokes by a few dozen or so milliseconds to reduce [key stroke timing biometrics](https://en.wikipedia.org/wiki/Keystroke_dynamics)



Some points about the design of this project:

* Written in go with the [literate](https://en.wikipedia.org/wiki/Literate_programming) tool [srcweave](https://github.com/justinmeiners/srcweave), so this
markdown book is actually the source code
* KISS principle above All
* Small and light core
* No dependencies for the core and most features
* Features (such as described in above section) are implementend as seperate programs, unix style
* Simple [threat model](ThreatModel.md)


# Running

## Installation

The server and client are both single static binaries. The only requirement is Linux. This software has been tested
with typical US keyboards in QWERTY and Colemak layouts. It should work with any keyboard layout, though.

### Keyboard weirdness

Not all keyboards are equal, per the [Linux kernel documentation](https://www.kernel.org/doc/html/latest/input/event-codes.html#ev-key), 
some keyboards do not autorepeat keys. Autorepeat behavior was also found inconsistent during testing and seems to mess up the rawcapture tool.

## Server

`sudo KEYBOARD_TCP_BIND_ADDRESS=127.1 KEYBOARD_TCP_BIND_PORT=8080 ./keyboard`

You could also run sudoless by giving your user access to uinput, but it would minimally if at all be more secure.

On first run it will output your authentication token. Store it in a safe place such as your password manager.

It is highly recommended to use SSH forwarding (preferred) or a reverse https proxy to access the server.

### SSH example

To connect with ssh, run this on the client:

`ssh -R 8080:localhost:8080 user@myserver`


### Socket file

It is more secure and mildly more efficient to use a unix socket file. To do this, set the environment variable `KEYBOARD_UNIX_SOCKET_PATH` to the path of the socket file. The server will create the file if it does not exist. The socket is useful for reverse proxies or SSH forwarding.

## Client

`KEYBOARD_AUTH=your_token_here KEYBOARD_FIFO=keyboard_control_file ./keyboard-client "ws://myserver:8080/sendkeys`

From here you can use any program that can write to a FIFO to send keystrokes to the server. For example, you could use `cat` to send a file to the server, or `cowsay` to send a cow message to the server.

### Tools

