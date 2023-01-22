# Streaming keyboard input

We use the Gorilla websocket library to handle the websocket connection. We then use the sendkeys library to stream the keyboard input to the client.

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
		err = keyboard.Type(message_string)
		if err != nil {
			log.Println("type:", err)
		}
	}
}

---