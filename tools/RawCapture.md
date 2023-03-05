# Raw Capture

This tool captures keyboard input from /dev/input/eventX and pipes it to the fifo accordingly.

An escape sequence of QKEYBOARD (QWERTY) will exit the program, but this can be changed via a command line argument.


## Why

This mode is especially useful for workflows with a lot of keyboard shortcuts or use of modifier keys, for example i3wm.

Generally a user would be in this mode when not typing extensively.

# Entrypoint

``` python

--- /tools/rawcapture/rawcapture.py

#!/usr/bin/python3
import os
import sys
import evdev
import traceback
import queue
import threading

# Docs http://python-evdev.readthedocs.io/en/latest/tutorial.html

device = ""

fifo = os.getenv("KEYBOARD_FIFO", "")
if not fifo:
    print("KEYBOARD_FIFO not set, exiting.")
    exit(0)

try:
    dev_path = sys.argv[1]
    try:
        device = evdev.InputDevice(dev_path)
    except PermissionError:
        print("Insufficent permission to read, run me as root!")
        exit(0)

except IndexError:
    foundDev = []
    allDev = [evdev.InputDevice(dev) for dev in evdev.list_devices()]
    if len(allDev) == 0:
        print("No devices found, run me as root!")
        exit(0)
    print("Found the following USB input devices: ")
    count = 0
    for device in allDev:
        if "usb" in device.phys:
            count += 1
            foundDev.append(device)
            print(str(count) + ". " + device.name, device.fn)

    print("Select a device (1 to %s)" % str(len(foundDev)), end=" ")
    i = int(input())
    i -= 1
    device = foundDev[i]

print("Using device " + device.fn)

print("Grabbing device for exclusive access.")
device.grab()
print("Enter numbers, press enter (Ctrl-C to exit).")

write_queue = queue.Queue()
def write_loop():
    while True:
        try:
            data = write_queue.get()
            with open(fifo, "w") as f:
                f.write(data)
        except Exception as e:
            print("Error writing to fifo: " + str(e))
            traceback.print_exc()

write_thread = threading.Thread(target=write_loop, daemon=True)
write_thread.start()

KEYMAP = {
    1:   "ESC",
    2:   "1",
    3:   "2",
    4:   "3",
    5:   "4",
    6:   "5",
    7:   "6",
    8:   "7",
    9:   "8",
    10:  "9",
    11:  "0",
    12:  "-",
    13:  "=",
    14:  "BS",
    15:  "TAB",
    16:  "Q",
    17:  "W",
    18:  "E",
    19:  "R",
    20:  "T",
    21:  "Y",
    22:  "U",
    23:  "I",
    24:  "O",
    25:  "P",
    26:  "[",
    27:  "]",
    28:  "ENTER",
    29:  "L_CTRL",
    30:  "A",
    31:  "S",
    32:  "D",
    33:  "F",
    34:  "G",
    35:  "H",
    36:  "J",
    37:  "K",
    38:  "L",
    39:  ";",
    40:  "'",
    41:  "`",
    42:  "L_SHIFT",
    43:  "\\",
    44:  "Z",
    45:  "X",
    46:  "C",
    47:  "V",
    48:  "B",
    49:  "N",
    50:  "M",
    51:  ",",
    52:  ".",
    53:  "/",
    54:  "R_SHIFT",
    55:  "*",
    56:  "L_ALT",
    57:  "SPACE",
    58:  "CAPS_LOCK",
    59:  "F1",
    60:  "F2",
    61:  "F3",
    62:  "F4",
    63:  "F5",
    64:  "F6",
    65:  "F7",
    66:  "F8",
    67:  "F9",
    68:  "F10",
    69:  "NUM_LOCK",
    70:  "SCROLL_LOCK",
    71:  "HOME",
    72:  "UP_8",
    73:  "PGUP_9",
    74:  "-",
    75:  "LEFT_4",
    76:  "5",
    77:  "RT_ARROW_6",
    78:  "+",
    79:  "END_1",
    80:  "DOWN",
    81:  "PGDN_3",
    82:  "INS",
    83:  "DEL",
    84:  "",
    85:  "",
    86:  "",
    87:  "F11",
    88:  "F12",
    89:  "",
    90:  "",
    91:  "",
    92:  "",
    93:  "",
    94:  "",
    95:  "",
    96:  "R_ENTER",
    97:  "R_CTRL",
    98:  "/",
    99:  "PRT_SCR",
    100: "R_ALT",
    101: "",
    102: "HOME",
    103: "UP",
    104: "PGUP",
    105: "LEFT",
    106: "RIGHT",
    107: "END",
    108: "DOWN",
    109: "PGDN",
    110: "INSERT",
    111: "DEL",
    112: "",
    113: "",
    114: "",
    115: "",
    116: "",
    117: "",
    118: "",
    119: "PAUSE",
    120: "",
    121: "",
    122: "",
    123: "",
    124: "",
    125: "SUPER"
}

key_str = ""
log = []
quit_str = "QKEYBOARD"
quit_list = []
for c in quit_str:
    for k, v in KEYMAP.items():
        if v == c:
            quit_list.append(k)
            break

def quit_if_necessry(log):
    if len(log) > len(quit_list):
        log.pop(0)
    if log == quit_list:
        print("Quitting...")
        raise SystemExit

try:
    for event in device.read_loop():

        if event.type == evdev.ecodes.EV_KEY:
            print(event)
            #e_code = event.code - 1
            e_code = event.code
            if e_code == 2:
                break
            try:
                key_str = KEYMAP[e_code]
            except KeyError:
                print("Unknown key: " + str(e_code))
            if event.value == 1:
                key_str = "{KEYDWN}" + key_str
                log.append(e_code)
                quit_if_necessry(log)
            elif event.value == 0:
                key_str = "{KEYUP}" + key_str
            else:
                print("Unknown value: " + str(event.value))
                continue
            write_queue.put(key_str)
            sys.stdout.flush()

except (KeyboardInterrupt, SystemExit, OSError):
    print(traceback.format_exc())
    device.ungrab()
    print("\rGoodbye!")
    exit(0)

---
```