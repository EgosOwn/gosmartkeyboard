# GoSmartKeyboard Environment Variables

## HTTP Bind Settings


GoSmartKeyboard supports both standard TCP sockets and unix sockets for the
HTTP server.

First, we check for a unix socket path.

One should prefer a unix socket if their reverse proxy supports it and is on the
same machine.

--- unixSocketPath
unixSocketPath, unixSocketPathExists := os.LookupEnv("KEYBOARD_UNIX_SOCKET_PATH")
---

If the unix socket path is set, we use it. Otherwise, we use the TCP socket.

The TCP socket is configured by the following environment variables:

--- TCPBindAddress
tcpBindAddress, tcpBindAddressExists := os.LookupEnv("KEYBOARD_TCP_BIND_ADDRESS")
---

--- TCPBindPort
tcpBindPort, tcpBindPortExists := os.LookupEnv("KEYBOARD_TCP_BIND_PORT")
---