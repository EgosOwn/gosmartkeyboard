# GoSmartKeyboard


Copyright [Kevin Froman](https://chaoswebs.net/) [Licensed under GPLv3](LICENSE.md)

Work in progress

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

## Server

`sudo KEYBOARD_TCP_BIND_ADDRESS=0.0 KEYBOARD_TCP_BIND_PORT=8080 ./keyboard`


# Server Entrypoint



Right out of the gate, we make sure a token is provisioned. In the future we will use the system keyring.

Then we can start the web server and listen for websocket connections.

``` go

--- entrypoint

    func main(){
        
        tokenBase64, _ := auth.ProvisionToken()
        if len(tokenBase64) > 0 {
            fmt.Println("This is your authentication token, it will only be shown once: " + tokenBase64)        
        }


        server.StartServer()
    }

---


--- /server/main.go
    package main

    import(
        "fmt"
        "keyboard.voidnet.tech/server"
        "keyboard.voidnet.tech/auth"
    )


    @{entrypoint}

---



--- set network bind globals

    var string unixSocketPath
    var bool unixSocketPathExists
    var string tcpBindAddress
    var bool tcpBindAddressExists
    var string tcpBindPort
    var bool tcpBindPortExists

---
```