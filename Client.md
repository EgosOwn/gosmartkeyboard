# GoSmartKeyboard Client


This is the base client, it only connects and authenticates.


The authentication token is loaded from the environment variable `KEYBOARD_AUTH`, if it does not exist we read it from stdin in base64 form, ended with a newline.

``` go

--- start client



---


```