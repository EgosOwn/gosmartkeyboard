# Streaming keyboard input

We use the Gorilla websocket library to handle the websocket connection.

Most of the time, we can use sendkeys (which uses libinput) to effeciently press keys. However, if we need to send a character that sendkeys doesn't know about, we can use the xdotool command. xdotool is also useful if one does not want to use root.

xdotool spawns a new process for each keypress, so it's not as effecient as sendkeys.

To specify xdotool usage, the client should send a message with the format `{kb_cmd:xdotool}:message` where message is a utf-8 string.

``` go
--- streaming keyboard input

func clientConnected(w http.ResponseWriter, r *http.Request) {
	// regex if string has characters we need to convert to key presses
	characterRegex, _ := regexp.Compile(`[^\x08]\x08|\t|\n`)
	keyboard, err := sendkeys.NewKBWrapWithOptions(sendkeys.Noisy)

	@{always use xdotool environment variable}


	if err != nil {
		panic(err)
	}
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Print("upgrade:", err)
		return
	}
	defer c.Close()

	// get auth token
	_, message, err := c.ReadMessage()
	if err != nil {
		log.Println("read:", err)
		return
	}

	if auth.CheckAuthToken(string(message)) != nil {
		log.Println("invalid token")
		c.WriteMessage(websocket.TextMessage, []byte("invalid token"))
		return
	}
	c.WriteMessage(websocket.TextMessage, []byte("authenticated"))

	for {
		time.Sleep(25 * time.Millisecond)
		_, message, err := c.ReadMessage()
		if err != nil {
			log.Println("read:", err)
			break
		}
		log.Printf("recv: %s", message)
		message_string := string(message)
		if message_string == "" {
			message_string = "\n"
		}
		
		@{send keys to system}
	}
}

---
```

# Sending the keys

Sending the keys is a bit tricky as we need to manually convert backspace, tab, enter and modifier keys.

``` go

--- send keys to system


doXDoTool := func(command string, keys string)(err error) {
	var cmd *exec.Cmd
	if command == "type" {
		cmd = exec.Command("xdotool", command, "--delay", "25", keys)
	} else {
		cmd = exec.Command("xdotool", command, keys)
	}
	return cmd.Run()
}

@{handle xdotoool commands}

@{do streaming sendkeys approach}

---
```