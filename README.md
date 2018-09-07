# installCert
Trust a certificate in Keychain given an HTTPS/TLS server hostname (OS X)

# Description

This script downloads an HTTPS/TLS certificate in PEM format and imports it to the OS X Keychain as a trusted cert.

In using the "security" Keychain management utility in Terminal, I wasn't able to find a built-in method to import a certificate directly from a website / SSL server. This script imports a certificate based on a given hostname.


# Disclaimer

Use at your discretion. Blindly trusting certs from a remote server can be dangerous, so use this only in controlled & trusted networks. A legit use case might be manually trusting a self-signed cert within a test/dev environment. A not-so-legit use case would be using this for anything at all in a coffee shop.
