# Keyboard connection authentication

Keyboarding is a very sensitive activity, so this app naturally needs to encrypt and authenticate connections.

All connections are encrypted using an external TLS proxy (e.g. [Caddy](https://caddyserver.com)) outside the
scope of this project, but we perform application level authentication using two
randomly generated UUIDv4s in a manner similar to a passphrase. @{token generation}

We hash the token using sha3-256 to avoid accidentally exposing the token to a
readonly attacker. Since the token is very high entropy, we do not need a salt or
KDF.

``` go
--- token generation
authToken = uuid.New().String() + uuid.New().String()
hashedID := sha3.Sum256([]byte(authToken))
---
```


## Authentication token file

We store the token in a file, which is set
by the environment variable `KEYBOARD_AUTH_TOKEN_FILE`, but defaults to
'XDG_CONFIG_HOME/smartkeyboard/auth-token.'

The following is used when we need to get the token file path:

``` go

--- define authentication token file

@{get authTokenFile from environment}

if authTokenFileIsSet == false {
    authTokenFile = filepath.Join(xdg.ConfigHome, "smartkeyboard", "auth-token")
}
---
```


## Checking authentication

When a client connects, the [websocket server](Server.md) checks the token they send against the stored token.

``` go
--- check token
func checkAuthToken(token string) error {
    @{define authentication token file}
    // compare sha3_256 hash to hash in file
    hashedToken := sha3.Sum256([]byte(token))
    storedToken, err := os.ReadFile(authTokenFile)
    if err != nil {
        return err
    }
    if subtle.ConstantTimeCompare(hashedToken[:], storedToken) != 1 {
        return errors.New("invalid token")
    }
    return nil
}
---

--- /auth/auth.go
package auth

import(
    "os"
    "path/filepath"
    "errors"
    "crypto/subtle"
@{sha3 import string}
@{uuid import string}
@{xdg import string}
)

var authToken = ""

func provisionToken() (error){
    @{define authentication token file}

    if _, err := os.Stat(authTokenFile); err == nil {
        return nil
    }

    @{token generation}

    fo, err := os.Create(authTokenFile)
    if err != nil {
        panic(err)
    }
    fo.Write(hashedID[:])
    fo.Close()
    return nil
}

@{check token}
---


```