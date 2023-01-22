# Cowsay

This tool sends your text as cow speech to the server. It is a simple example of a tool that can be used to send text to the server.

``` go

--- /tools/cowsay.go
@{tool header}
@{tool main}

func doTool(){
    if len(os.Args) < 2 {
        fmt.Println("Usage: cowsay <text>")
        os.Exit(1)
    }
	cmd := exec.Command("cowsay", os.Args[1:])
	//cmd.Stdin = strings.NewReader("some input")
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}
    fmt.Println(strings)
}


---
```