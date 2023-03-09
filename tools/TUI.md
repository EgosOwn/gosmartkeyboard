# SmartKeyboardTUI

SmartKeyboardTUI is a terminal user interface for SmartKeyboard. It wraps other commands and provides a way to quickly switch between them.

The commands it wraps are arbitrary and defined in commands.txt. The commands.txt file is a simple text file with one command per line. The first word of each line is the command name, and the rest of the line is the command to run. The command name is used to switch to that command. The command is run with the shell, so you can use pipes, redirection, etc.


``` python
--- /tools/tui/tui.py
#!/usr/bin/env python3

import os
import sys
import time
import subprocess

with open("commands.txt") as f:
    commands = [line.strip().split(" ", 1) for line in f.readlines()]


output_file = os.getenv("KEYBOARD_FIFO", sys.stdout)

while True:
    for c, cmd in enumerate(commands):
        print(f"\r{c+1}: {cmd[0]} ")
    print('\n\r', end='')
    try:
        inp = sys.stdin.read(1)
        inp = int(inp)
    except ValueError:
        if inp == "q":
            break
        inp = 0
        continue
    if inp < 1 or inp > len(commands):
        continue
    cmd = commands[inp-1][1]
    subprocess.run(cmd, shell=True, stdout=output_file)
    print('\n\r')

---


```