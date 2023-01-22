# Keyboarding Tools

The actual keyboarding tools are completely seperate from the server and client code. 
As far as features are concerned, they only need to write to stdout.

All tools have the same initial structure:
``` go
--- tool header
package main
import (
    "fmt"
    "os"
    "log"
    "time"
)
---
--- tool main
func main(){
    @{get auth token}
    @{start tool}
}

---

--- start tool

time.Sleep(1 * time.Second)

fmt.Println(authTokenInput)

doTool()


---

--- get auth token --- noWeave

@{get authTokenInput from environment}

if !authTokenInputExists {
    //fmt.Print("Enter authentication token: ")
    _, err := fmt.Scanln(&authTokenInput)
    if err != nil {
        log.Fatal(err)
    }
}

---
