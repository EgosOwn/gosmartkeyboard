# GoSmartKeyboard Threat Model


GoSmartKeyboard assumes that it is running behind a reverse proxy that provides TLS termination. This is a common setup for web applications, and is the default configuration for the [Caddy](https://caddyserver.com/) web server. Alternatively you could use SSH port forwarding to tunnel the traffic to the server.

The server daemon is intended to be used on a single-user system. The goal is to prevent against well funded attackers without physical access to the machine from authenticating to the service. To prevent this, a 256 bit random token is generated and stored in a file. The token is then displayed to the user, and they are expected to copy it to store it safely. The token cannot be recovered because only a sha256 hash of the token is stored on disk.