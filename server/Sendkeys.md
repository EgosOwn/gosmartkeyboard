# uinput streaming approach



``` go
--- do streaming keylogger approach

key := ""
if strings.HasPrefix(message_string, "{KEYDWN}") {
	key = strings.TrimPrefix(string(message_string), "{KEYDWN}")
	k.Write(1, key)
} else if strings.HasPrefix(message_string, "{KEYUP}") {
	key = strings.TrimPrefix(string(message_string), "{KEYUP}")
	k.Write(0, key)
} else{
	for _, key := range message_string {
		// write once will simulate keyboard press/release, for long press or release, lookup at Write
		k.WriteOnce(string(key))
	}
}


---

```