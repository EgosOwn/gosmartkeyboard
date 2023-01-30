# Send keys streaming approach

When applicable to use send keys, we need to detect Enter, Tab, and BackSpace and use the applicatble functions.

We test if it meets the characterRegex, and if so we iterate for each character and send the corresponding key.
Otherwise we send the entire string at once.

``` go
--- do streaming sendkeys approach
if characterRegex.MatchString(message_string) {
	for _, character := range message_string {
		charString := string(character)
		if charString == "\n" {
			keyboard.Enter()
			continue
		}
		if charString == "\t" {
			keyboard.Tab()
			continue
		}
		if charString == "\b" {
			keyboard.BackSpace()
			continue
		}
		err = keyboard.Type(charString)
		if err != nil {
			log.Println("type:", err)
		}
		continue
	}
	continue
}
err = keyboard.Type(message_string)
if err != nil {
	log.Println("type:", err)
}
---

```