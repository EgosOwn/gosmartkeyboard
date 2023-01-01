# GoSmartKeyboard Client

When GoSmartKeyboard is started in client mode, it does the following:

1. Load the connection URL from the second CLI argument.
2. Load the auth token from the environment variable `KEYBOARD_AUTH` or stdin.
3. Connect to the server.
4 Send the auth token to the server.
5. If the server responds with "authenticated", we start reading keys from stdin and sending them to the server until EOF.


## Connecting

The base64 authentication token is loaded from the environment variable `KEYBOARD_AUTH`, if it does not exist we read it from stdin (base64 encoded), ended with a newline.

``` go

--- start client

@{load connection URL from second CLI argument}
@{get authTokenInput from environment}

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
if string(authResponse) != "authenticated" {
    log.Fatal("authentication failed")
}


---

--- load connection URL from second CLI argument --- noWeave

if len(os.Args) < 3 {
    log.Fatal("missing connection URL")
}

connectionURL := os.Args[2]

if !strings.HasPrefix(connectionURL, "ws://") && !strings.HasPrefix(connectionURL, "wss://") {
    log.Fatal("connection URL must start with ws:// or wss://")
}

---

```

## Sending keys


We read keys from stdin and send them to the server until we get EOF

``` go

--- start client +=


for {
    var key string
    _, err := fmt.Scanln(&key)
    if err != nil {
        if err == io.EOF {
            break
        }
        log.Fatal(err)
    }
    err = client.WriteMessage(websocket.TextMessage, []byte(key))
    if err != nil {
        log.Fatal("write:", err)
    }
}

---

```