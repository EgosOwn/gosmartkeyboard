# Keyboard socket server

The server has two jobs, to authenticate and to accept a stream of key presses from the client.

For efficiency and security we support use of a unix socket, but tcp can be used instead. In the case of TCP, the server will listen on 127.1 by default but can be configured to listen on a different address and port. In any case, it is highly recommended to run the server behind a reverse proxy supporting HTTPS such as nginx or caddy.

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


## HTTP API endpoints



``` go
--- start http server

func StartServer() {

    @{create listener}
	fmt.Println("Listening on", listener.Addr())
    http.HandleFunc("/sendkeys", clientConnected)
	//http.HandleFunc("/activewindow", )
    http.Serve(listener, nil)


}


---


--- /server/server.go
package server

import(
    "net"
	"time"
    "os"
    "net/http"
    "fmt"
    "strings"
    "log"
	"keyboard.voidnet.tech/auth"
    @{gorilla/websocket import string}
    @{sendkeys import string}
)

var listener net.Listener

var upgrader = websocket.Upgrader{} // use default options

@{streaming keyboard input}
@{start http server}

---
```