# Keyboard socket server

The server has two jobs, to authenticate and to accept a stream of key presses from the client.

For efficiency and security we support use of a unix socket, but tcp can be used instead

# Picking a socket type and setting the listener


``` go
--- create listener

@{unixSocketPath} // gets unixSocketPath from environment, unixSocketPathExists defines if it exists
@{TCPBindAddress} // gets tcpBindAddress from environment, tcpBindAddressExists defines if it exists
@{TCPBindPort} // gets tcpBindPort from environment, tcpBindPortExists defines if it exists


if unixSocketPathExists {
    listener, _ = net.Listen("unix", unixSocketPath)
} else{
    if tcpBindAddressExists && tcpBindPortExists {
        listener, _ = net.Listen("tcp", tcpBindAddress + ":" + tcpBindPort)
    } else {
        listener, _ = net.Listen("tcp", "127.0.0.1:8080")
    }

}

---
```


# Starting the server

``` go
--- start websocket server

func clientConnected(w http.ResponseWriter, r *http.Request) {
	kb, err := keybd_event.NewKeyBonding()
	if err != nil {
		panic(err)
	}
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Print("upgrade:", err)
		return
	}
	defer c.Close()

	for {
		_, message, err := c.ReadMessage()
		if err != nil {
			log.Println("read:", err)
			break
		}
		log.Printf("recv: %s", message)
		message_string := string(message)
		for _, char := range message_string {
			// make sure that the char is a number
			number, err := strconv.Atoi(string(char))
			if err == nil {
				kb.SetKeys(number)
			}
		}
		// sendkeys
		//kb.SetKeys(30, 32, 33)
		go kb.Launching()
	}
}

func StartServer() {

    // create http server on unix socket
    @{create listener}
    http.HandleFunc("/sendkeys", clientConnected)
    http.Serve(listener, nil)


}


---
```

--- /server/server.go
package server

import(
    "net"
    "os"
    "net/http"
    "log"
    @{gorilla/websocket import string}
    @{keybd_event import string}
)

var listener net.Listener

var upgrader = websocket.Upgrader{} // use default options


@{start websocket server}
---