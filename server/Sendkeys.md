# uinput streaming approach


``` go
--- do streaming keylogger approach

key := ""
if strings.HasPrefix(message_string, "@{keydown cmd}") {
	key = strings.TrimPrefix(string(message_string), "@{keydown cmd}")
	k.Write(1, key)
} else if strings.HasPrefix(message_string, "@{keyup cmd}") {
	key = strings.TrimPrefix(string(message_string), "@{keyup cmd}")
	k.Write(0, key)
}  else if strings.HasPrefix(message_string, "@{keyheld cmd}") {
	key = strings.TrimPrefix(string(message_string), "@{keyheld cmd}")
	k.Write(2, key)
} else{
	for _, key := range message_string {
		// write once will simulate keyboard press/release, for long press or release, lookup at Write
		k.WriteOnce(string(key))
	}
}


---

```