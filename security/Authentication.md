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

fmt.Println("This is your authentication token, it will only be shown once: " + authToken)
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

We use a constant time comparison to avoid timing attacks.


``` go
--- check token function
func CheckAuthToken(token string) error {
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

--- provision token function
func ProvisionToken() (error){
    @{define authentication token file}

    if _, err := os.Stat(authTokenFile); err == nil {
        return nil
    }

    @{token generation}

    // create directories if they don't exist
    os.MkdirAll(filepath.Dir(authTokenFile), 0700)
    fo, err := os.Create(authTokenFile)
    defer fo.Close()
    if err != nil {
        panic(err)
    }
    fo.Write(hashedID[:])
    return nil
}
---

## Putting it all together

The following is the structure of the authentication package.

Both CheckAuthToken and ProvisionToken are exported.
The former is used by the server on client connect and the latter is called on startup.

--- /auth/auth.go
package auth

import(
    "os"
    "path/filepath"
    "fmt"
    "errors"
    "crypto/subtle"
@{sha3 import string}
@{uuid import string}
@{xdg import string}
)

var authToken = ""

@{provision token function}

@{check token function}
---


```