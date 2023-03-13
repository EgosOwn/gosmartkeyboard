# Handle xdotool commands

Currently the two commands are `type` and `key`. `type` is used to type a character and `key` is used to type a special character like `Enter` or `Backspace`.

`type` is specified by '@{use xdotool cmd}', and `key` is specified by '@{use xdotool key cmd}'. If the command is not specified and `alwaysUseXdotool` is set from the environment variable, it will default to `type`.


``` go
--- handle xdotoool commands

if alwaysUseXdotool || strings.HasPrefix(message_string, "@{use xdotool cmd}") {
	message_string = strings.TrimPrefix(message_string, "@{use xdotool cmd}")
	if message_string == "" {
		message_string = "\n"
	}


	if characterRegex.MatchString(message_string) {
		for _, character := range message_string {
			charString := string(character)
			if charString == "\n" {
				charString = "Enter"
			} else if charString == "\t" {
				charString = "Tab"
			} else if charString == "\b" {
				charString = "BackSpace"
			} else{
				doXDoTool("type", charString)
				continue
			}
			// key is required for special characters
			err = doXDoTool("key", charString)
			continue
		}
		continue
	} else {
		doXDoTool("type", message_string)
	}
	continue
} else if strings.HasPrefix(message_string, "@{use xdotool key cmd}") {
	message_string = strings.TrimPrefix(message_string, "@{use xdotool key cmd}")
	if message_string == "" {
		message_string = "\n"
	}
	doXDoTool("key", message_string)
	continue
}

---
```