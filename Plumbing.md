# Miscelanious plumbing functions

## Detect version command, print version, and exit

``` go
--- handle version command
if len(os.Args) > 1 && os.Args[1] == "version" {
    fmt.Println("Keyboard version: @{version}")
    os.Exit(0)
}
---
```