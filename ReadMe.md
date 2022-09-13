# GoSmartKeyboard Daemon


# Introduction

This is a simple websocket server meant to accept a single connection, authenticate it, and stream UTF16 characters and send them as key strokes into the window manager.

The goal of this particular daemon is not to perfectly emulate a HID, so it may trip up on Windows UAC or game anticheat systems.


Some points about the design of this project:

* Written in [literate go](https://github.com/justinmeiners/srcweave), so this
markdown book is actually the source code
* The project is test-driven
* KISS principle above All
* Small and light core
* Advanced features provided via plugins
* Well defined [threat model](ThreatModel.md)



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


# Daemon Entrypoint


First, we call

``` go

--- entrypoint

    func main(){
        server.StartServer()
    }

---


--- /main.go
    package main

    import(
        "keyboard.voidnet.tech/server"
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