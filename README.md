# cc-turtle-lab

Sandbox for ComputerCraft turtle tests.

## place_up.lua

A turtle that places every block put into its inventory above itself.

Install on a turtle (run on the turtle):

```
delete startup
wget https://raw.githubusercontent.com/Kapebara07/cc-turtle-lab/main/place_up.lua startup
reboot
```

If the space above is occupied, the turtle waits and retries every 2 seconds.
