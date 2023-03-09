# Simple Input

This tool reads lines from stdin and sends them to the server.

Newline characters are only sent when a blank line is entered.


``` go

--- /tools/input/input.go

package main

import (
    "io/ioutil"
    "bufio"
    "os"
)

func main(){
    var input string
    @{get client fifo input file from environment}
    if ! clientFifoInputFileEnvExists {
        os.Exit(1)
    }
    for {
        reader := bufio.NewReader(os.Stdin)
        input, _ = reader.ReadString('\n')
        if len(input) > 0 {
            ioutil.WriteFile(clientFifoInputFile, []byte(input), 0644)
        } else {
            ioutil.WriteFile(clientFifoInputFile, []byte("\n"), 0644)
        }
        input = ""
    }

}
---