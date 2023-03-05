# GoSmartKeyboard


Copyright 2022 [Kevin Froman](https://chaoswebs.net/) [Licensed under GPLv3](LICENSE.md)

Work in progress

# Introduction

GoSmartKeyboard is a daemon that allows you to have a more powerful keyboarding experience. It is meant to be used with a secondary device, such as an Android phone or a raspberry pi.


This is done with a simple websocket server meant to accept a single connection, authenticate it, and stream UTF16 characters and send them as key strokes into the window manager. **With a simple daemon like this we can enhance keyboarding with inteligent features.**

The goal of this particular daemon is not to perfectly emulate a HID, so it may trip up on Windows UAC or game anticheat systems.

A client is included that simply connects and authenticates. It is meant to be used with unix philosophy modules, for example a password manager wrapper. A UI could then wrap the client and said modules.

**See [Building.md](Building.md) for instructions on how to build this [literate](https://en.wikipedia.org/wiki/Literate_programming) project.**


## Why a smart keyboard?

Keyboards have been an essential element of computing since the beginning, however they have not evolved much. Everything has a smart variant, so why not keyboards?

A smart keyboard could, for example, be used for the following:

* Typical macros
* Buffer typed text before sending it to the client, preventing invalid commands or input. (This would also save some CPU on low power machines, this is how many early teletype systems worked)
* Clever CLI tricks, think `vim` or `cowsay` on your keyboard!
* Isolated password manager
* One Time Passwords
* Virtual keyboard switch or communicating with multiple daemons at once
* Easily attach to VMs
* Text storage, such as configuration or SSH pubkeys
* On-the-fly spell checking or translation
* On-the-fly encryption (ex: PGP sign every message you type), isolated from the perhaps untrusted computer
* Easy layout configuration
* Delay keystrokes by a few dozen or so milliseconds to reduce [key stroke timing biometrics](https://en.wikipedia.org/wiki/Keystroke_dynamics)



Some points about the design of this project:

* Written in go with the [literate](https://en.wikipedia.org/wiki/Literate_programming) tool [srcweave](https://github.com/justinmeiners/srcweave), so this
markdown book is actually the source code
* The project is test-driven
* KISS principle above All
* Small and light core
* Advanced features provided via plugins
* Well defined [threat model](ThreatModel.md)


# Running

## Server

`sudo KEYBOARD_TCP_BIND_ADDRESS=0.0 KEYBOARD_TCP_BIND_PORT=8080 ./keyboard`


# Entrypoint



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