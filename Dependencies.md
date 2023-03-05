# Project Dependencies

This project has the following dependencies, excluding the Go standard library:



# xdg

We use the xdg package to get the user's config directory.

--- xdg import string

    "github.com/adrg/xdg"

---

# sha3

We use sha3 to hash authentication tokens. It is not in the crypto standard library.

--- sha3 import string

    "golang.org/x/crypto/sha3"

---

# keylogger

We use keylogger to get keyboard input on the client and simulate keystrokes on the server.

--- keylogger import string

    "github.com/EgosOwn/keylogger"

---

# gorilla/websocket

We also rely on gorilla/websocket for the websocket server that processes keyboard input.

--- gorilla/websocket import string

    "github.com/gorilla/websocket"

---