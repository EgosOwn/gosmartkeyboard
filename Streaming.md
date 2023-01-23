# Streaming keyboard input

We use the Gorilla websocket library to handle the websocket connection.

Most of the time, we can use sendkeys (which uses libinput) to effeciently press keys. However, if we need to send a character that sendkeys doesn't know about, we can use the xdotool command. xdotool is also useful if one does not want to use root.

xdotool spawns a new process for each keypress, so it's not as effecient as sendkeys.

To specify xdotool usage, the client should send a message with the format `{kb_cmd:xdotool}:message` where message is a utf-8 string.

``` go
--- streaming keyboard input

func clientConnected(w http.ResponseWriter, r *http.Request) {
	keyboard, err := sendkeys.NewKBWrapWithOptions(sendkeys.Noisy)


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


// regex if string has characters we need to convert to key presses
characterRegex, _ := regexp.Compile(`[^\x08]\x08|\t|\n`)

doXDoTool := func(command string, keys string)(err error) {
	var cmd *exec.Cmd
	if command == "type" {
		cmd = exec.Command("xdotool", command, "--delay", "25", keys)
	} else {
		cmd = exec.Command("xdotool", command, keys)
	}
	return cmd.Run()
}

if strings.HasPrefix(message_string, "{kb_cmd:xdotool}:") {
	message_string = strings.TrimPrefix(message_string, "{kb_cmd:xdotool}:")
	if message_string == "" {
		message_string = "\n"
	}


	if characterRegex.MatchString(message_string) {
		for _, character := range message_string {
			charString := string(character)
			if charString == "\n" {
				charString = "Enter"
			} else if charString == "\t" {
				charString = "Tab"
			} else if charString == "\b" {
				charString = "BackSpace"
			} else{
				doXDoTool("type", charString)
				continue
			}
			// key is required for special characters
			err = doXDoTool("key", charString)
			continue
		}
		continue
	} else {
		doXDoTool("type", message_string)
	}
	continue
}

if characterRegex.MatchString(message_string) {
	for _, character := range message_string {
		charString := string(character)
		if charString == "\n" {
			keyboard.Enter()
			continue
		}
		if charString == "\t" {
			keyboard.Tab()
			continue
		}
		if charString == "\b" {
			keyboard.BackSpace()
			continue
		}
		err = keyboard.Type(charString)
		if err != nil {
			log.Println("type:", err)
		}
		continue
	}
	continue
}
err = keyboard.Type(message_string)
if err != nil {
	log.Println("type:", err)
}
---
```