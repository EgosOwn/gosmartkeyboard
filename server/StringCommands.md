# String Commands

To control key events and the input method we use special command strings at the beginning of a message.

They are as follows:

Payload delimiter:
--- payload delimiter
{KB_MSG}
---


Xdotool typing:

--- use xdotool cmd
{KEYDOXDOTOOL}:
---

Xdotool key command:

--- use xdotool key cmd
{KEYDOXTOOLKEY}:
---

Send keys commands:

--- keydown cmd
{KEYDWN}
---

--- keyup cmd
{KEYUP}
---

--- keyheld cmd
{KEYHLD}
---