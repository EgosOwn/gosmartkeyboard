# Input Method Editor

This tool uses your $EDITOR to buffer keystrokes.

``` go
--- /tools/editor/editor.go

package main

import (
	"io/ioutil"
	"os"
)
// #include <stdlib.h>
//
// void vim() {
//  system("vi inputfile");
// }
import "C"

func main() {

    var inputFile := "inputFile"
    @{get client fifo input file from environment}

    C.vim()
	data, _ := ioutil.ReadFile(inputFile)
	f, err := os.OpenFile(clientFifoInputFile, os.O_WRONLY, 0600)
	if err != nil {
		panic(err)
	}
    f.Write(data)
    os.Remove(inputFile)

}


---
```