# Keyboard connection authentication

Keyboarding obviously has a ton of sensitive data, so we need to both encrypt and
authenticate the connections.

All connections are encrypted using an external TLS proxy (e.g. Caddy) outside the
scope of this project, but we perform application level authentication using two
randomly generated UUIDv4s in a manner similar to a passphrase. @{token generation}

We hash the token using sha3-256 to avoid accidentally exposing the token to a
readonly attacker.


## Generating the authentication token

``` go
--- token generation
id := uuid.New() + uuid.New()
hashedID := sha3.Sum256([]byte(id))
---
```

## Storing the authentication token

We then store the token in a file, which is set
by the environment variable `KEYBOARD_AUTH_TOKEN_FILE`, but defaults to
'XDG_CONFIG_HOME/smartkeyboard/auth-token.' @{defineProvisionTokenFile}


``` go
--- store token
if err := os.WriteFile(KEYBOARD_AUTH_TOKEN_FILE, hashedID, 0666); err != nil {
    log.Fatal(err)
}
---
```

## Checking authentication

When a client connects, the [websocket server](Server.md) checks the token they send against the stored token.

``` go
--- check token
func checkAuthToken(token string) error {
    hashedToken := sha3.Sum256([]byte(token))
    storedToken, err := os.ReadFile(KEYBOARD_AUTH_TOKEN_FILE)
    if err != nil {
        return err
    }

    if subtle.ConstantTimeCompare(hashedToken[:], storedToken) != 1 {
        return errors.New("invalid token")
    }

    return nil
}
---
```


--- /auth/auth.go
package main

@{auth imports}
@{check token}
---

--- auth imports

import(
    //"github.com/google/uuid"
    //"encoding/base64"
    "golang.org/x/crypto/sha3"
    "os"
    "errors"
    "crypto/subtle"
)
---

``` go
--- defineProvisionTokenFile
provisionTokenFile, keyboardAuthExists := os.Getenv("KEYBOARD_AUTH_TOKEN_FILE")

if keyboardAuthExists == false {
    provisionTokenFile = filepath.Join(xdg.ConfigHome, "smartkeyboard", "auth-token")
}
---
```

```go
--- provisionToken
func provisionToken() (error){
    @{defineProvisionTokenFile}
    @{token generation}
    @{store token}
}
---
```