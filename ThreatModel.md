# GoSmartKeyboard Threat Model


GoSmartKeyboard assumes that it is running behind a reverse proxy that provides TLS termination. This is a common setup for web applications, and is the default configuration for the [Caddy](https://caddyserver.com/) web server.

The daemon is intended to be used by a single user, with the client used by the same person.
It is not recommended to use this over the internet, as it is intended for the user to be able to physically see the screen.