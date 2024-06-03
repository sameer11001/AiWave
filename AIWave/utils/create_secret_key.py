""" Third-party modules """
import secrets

# Generate a random 32-byte secret key (256 bits)
secret_key = secrets.token_hex(32)

# Print the secret key
print("Secret Key:", secret_key)