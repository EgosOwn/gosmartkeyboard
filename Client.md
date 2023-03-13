# GoSmartKeyboard Client

When the GoSmartKeyboard client is started, it does the following:

1. Load the connection URL from the first CLI argument.
2. Load the auth token from the environment variable `KEYBOARD_AUTH` or stdin if it does not exist.
3. Connect to the server.
4 Send the auth token to the server.
5. If the server responds with "authenticated", we start reading keys from stdin and sending them to the server until EOF.
    5.1 If the environment variable `KEYBOARD_FIFO` is set, we read from the path specified there instead as a named pipe.
    5.2 Regardless, each message is sent to the server with the prefix `@{payload delimiter}`.

``` go
--- handle client command
if len(os.Args) > 1 {
    @{get client fifo input file from environment} 
    @{setup client}
    if clientFifoInputFileEnvExists {
        @{start client with fifo}
        os.Exit(0)
    }
    @{start client with stdin}
    os.Exit(0)
}

---
```


## Connecting

The base64 authentication token is loaded from the environment variable `KEYBOARD_AUTH`, if it does not exist we read it from stdin (base64 encoded), ended with a newline.

``` go

--- setup client

@{handle version command}
@{load connection URL from second CLI argument}
@{get authTokenInput from environment}
@{add xdotool if non qwerty function}

if !authTokenInputExists {
    fmt.Print("Enter authentication token: ")
    _, err := fmt.Scanln(&authTokenInput)
    if err != nil {
        log.Fatal(err)
    }
}

client, _, err := websocket.DefaultDialer.Dial(connectionURL, nil)
if err != nil {
    log.Fatal("dial:", err)
}
defer client.Close()

err = client.WriteMessage(websocket.TextMessage, []byte(authTokenInput))

if err != nil {
    log.Fatal("write:", err)
}

_, authResponse, err := client.ReadMessage()
if err != nil {
    log.Fatal("read:", err)
}
if string(authResponse) == "authenticated" {
    fmt.Println("authenticated")
} else {
    log.Fatal("authentication failed")
}


---

--- load connection URL from second CLI argument --- noWeave

if len(os.Args) < 2 {
    log.Fatal("missing connection URL")
}

connectionURL := os.Args[1]

if !strings.HasPrefix(connectionURL, "ws://") && !strings.HasPrefix(connectionURL, "wss://") {
    log.Fatal("connection URL must start with ws:// or wss://")
}

---

```

## Sending keys from a named pipe


We create a fifo and then continuously read from it in a loop.

``` go
--- start client with fifo

syscall.Mkfifo(clientFifoInputFile, syscall.S_IFIFO|0666)

inputString := ""
for {
    readData, err := ioutil.ReadFile(clientFifoInputFile)
    if err != nil {
        log.Fatal(err)
    }

    inputString = addXDoToolIfNonQWERTY(string(readData))
    input := []byte("@{payload delimiter}" + inputString)
    if len(input) > 0 {
        err = client.WriteMessage(websocket.TextMessage, input)
        if err != nil {
            log.Fatal("write:", err)
        }
    }

}

---
```


## Sending keys from stdin


We read keys from stdin and send them to the server until we get EOF.

We specify xdotool if the key is not a QWERTY key or if KEYBOARD_ALWAYS_XDOTOOL is set to true.


``` go

--- start client with stdin

reader := bufio.NewReader(os.Stdin)
for {
    var key string
    
    
    rune, _, err := reader.ReadRune() //:= fmt.Scan(&key)
    key = addXDoToolIfNonQWERTY(string(rune))

    if err != nil {
        if err == io.EOF {
            break
        }
        log.Fatal(err)
    }
    err = client.WriteMessage(websocket.TextMessage, []byte("@{payload delimiter}" + key))
    if err != nil {
        log.Fatal("write:", err)
    }
}

---

```

# Handling unicode outside of the ASCII set

``` go

--- add xdotool if non qwerty function --- noWeave
addXDoToolIfNonQWERTY := func(message string)(string) {
    
    if strings.HasPrefix(message, "@{use xdotool cmd}") {
        return message
    }
    for _, char := range message {
        if char < 32 || char > 126  {
            if char != 8 && char != 9 && char != 10 {
                return "@{use xdotool cmd}" + message
            }
        }
    }
    return message

}

---
```


``` go
--- /client/main-client.go
package main
import (
    "strings"
    "io/ioutil"
    "syscall"
    "io"
    "bufio"
    "log"
    "fmt"
    "os"
@{gorilla/websocket import string}

)

func main(){@{handle client command}}


---
```
