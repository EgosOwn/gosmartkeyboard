# Project Dependencies

This project has the following dependencies, excluding the Go standard library:


# uuid

We use uuidv4s to generate authentication tokens

--- uuid import string

    "github.com/google/uuid"

---

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

# keybd_event


In order to avoid coding key press simulation for every major platform, we use [keybd_event](https://github.com/micmonay/keybd_event). This is a cross-platform library that uses the OS's native key press simulation.

--- keybd_event import string

    "github.com/micmonay/keybd_event"

---

# gorilla/websocket

We also rely on gorilla/websocket for the websocket server that processes keyboard input.

--- gorilla/websocket import string

    "github.com/gorilla/websocket"

---