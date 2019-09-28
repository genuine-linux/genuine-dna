#!/bin/bash

# To enable shadowed passwords, run the following command:

pwconv

# To enable shadowed group passwords, run:

grpconv

# This parameter causes useradd to create a mailbox file for the newly created user.

sed -i 's/yes/no/' /etc/default/useradd

# Choose a password for user root and set it by running:

passwd root

