# Raw Capture

This tool captures keyboard input from /dev/input/eventX and pipes it to the fifo accordingly.

It is meant to be ran from it's own tty, and is not meant to be used with a graphical environment, although a full screen terminal emulator will work for most input.

An escape sequence of escape+f1 will exit the program, but this can be changed via a command line argument.


## Why

This mode is especially useful for workflows with a lot of keyboard shortcuts or use of modifier keys, for example i3wm.

Generally a user would be in this mode when not typing extensively.

# Entrypoint

``` go

--- /tools/rawcapture/rawcapture.go

package main

import (
    "io/ioutil"
    "fmt"
    "os"
	//"os/signal"
    "github.com/MarinX/keylogger"
)
//ioutil.WriteFile(clientFifoInputFile, []byte(input), 0644)

/*
func receive(signalCh chan os.Signal, doneCh chan struct{}) {
    for {
        select {
        // Example. Process to receive a message
        // case msg := <-receiveMessage():
        case <-signalCh:
            pass
        }
    }
}
*/

func main(){
    @{get client fifo input file from environment}
    if ! clientFifoInputFileEnvExists {
        os.Exit(1)
    }

    /*
    doneCh := make(chan struct{})

    signalCh := make(chan os.Signal, 1)
    signal.Notify(signalCh, os.Interrupt)

    go receive(signalCh, doneCh)
    */

    keyboard := keylogger.FindKeyboardDevice()
    if keyboard == "" {
        os.Exit(1)
    }
    k, err := keylogger.New(keyboard)
    if err != nil {
        fmt.Println("could not get keyboard")
        os.Exit(1)
    }

	events := k.Read()
    var key = ""
    //byte keyByte = 0

	// range of events
	for e := range events {
		switch e.Type {
		// EvKey is used to describe state changes of keyboards, buttons, or other key-like devices.
		// check the input_event.go for more events
		case keylogger.EvKey:
            key = e.KeyString()
            if len(key) == 0{
                fmt.Println(e.Code)
            } 
			// if the state of key is pressed
			if e.KeyPress() {
                ioutil.WriteFile(clientFifoInputFile, []byte(fmt.Sprintf("{KEYDWN}%s", key)), 0644)
                //fmt.Println(e.Code)
			}

			// if the state of key is released
			if e.KeyRelease() {
				ioutil.WriteFile(clientFifoInputFile, []byte(fmt.Sprintf("{KEYUP}%s", key)), 0644)
			}

			break
		}
	}
}
---
```