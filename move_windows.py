#!/usr/bin/env python3

import subprocess
import time

# script to get around annoying linux mint bug of moving 
# all open windows to a new display whenever it is connected / extended to

def get(cmd):
    return subprocess.check_output(["/bin/bash", "-c", cmd]).decode("utf-8")

def un_maximize_windows():
    w_data = [l.split() for l in get("wmctrl -lG").splitlines()]
    for w in w_data:
        command = "wmctrl -ir " + w[0] + " -b remove,maximized_vert,maximized_horz"
        subprocess.Popen(["/bin/bash", "-c", command])

def shift_windows():
    w_data = [l.split() for l in get("wmctrl -lG").splitlines()]
    for w in w_data:
        command = "wmctrl -ir " + w[0] + " -e 0,2500,650,800,600"
        subprocess.Popen(["/bin/bash", "-c", command])

def maximize_windows():
    w_data = [l.split() for l in get("wmctrl -lG").splitlines()]
    for w in w_data:
        if ("max@home" not in w[7]):
            command = "wmctrl -ir " + w[0] + " -b add,maximized_vert,maximized_horz"
            print("maximize: ", w)
            subprocess.Popen(["/bin/bash", "-c", command])

un_maximize_windows()
shift_windows()
maximize_windows()
