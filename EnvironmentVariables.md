# GoSmartKeyboard Environment Variables


## Always use xdotool

Some users may always want xdotool, see the [Streaming.md](Streaming.md) file for more information.

--- always use xdotool environment variable

alwaysUseXdotool, alwaysUseXdotoolExists := os.LookupEnv("KEYBOARD_ALWAYS_USE_XDOTOOL")

---


## Authentication token file

The authentication token configuration file is set by the environment variable `KEYBOARD_AUTH_TOKEN_FILE`, but defaults to
`XDG_CONFIG_HOME/smartkeyboard/auth-token`.


``` go
--- get authTokenFile from environment

authTokenFile, authTokenFileIsSet := os.LookupEnv("KEYBOARD_AUTH_TOKEN_FILE")

---
```

## Authentication token input (for client)

--- get authTokenInput from environment

authTokenInput, authTokenInputExists := os.LookupEnv("KEYBOARD_AUTH")

---


## Client fifo

--- get client fifo input file from environment

clientFifoInputFile, clientFifoInputFileExists := os.LookupEnv("KEYBOARD_FIFO")

---

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
