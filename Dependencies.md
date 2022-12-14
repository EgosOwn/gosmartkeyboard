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

# sendkeys


In order to avoid coding key press simulation for every major platform, we use [sendkeys](https://github.com/yunginnanet/sendkeys). This is a cross-platform library that uses the OS's native key press simulation using [keybd_event](https://github.com/micmonay/keybd_event)

--- sendkeys import string

    "github.com/EgosOwn/sendkeys"

---

# gorilla/websocket

We also rely on gorilla/websocket for the websocket server that processes keyboard input.

--- gorilla/websocket import string

    "github.com/gorilla/websocket"

---