#!/usr/bin/env python3

import sys

def main(argv):

    files = sys.argv[1:]
    
    for name in files:
        with open(name, "r") as f:
            lines = f.readlines()
        char_counter = -1
        line_counter = 0
        initial_whitespaces = True
        
        for line in lines:
            initial_whitespaces = True
            line_counter += 1
            char_counter = -1
            for char in line:
                if char != " " or not initial_whitespaces:
                    char_counter += 1
                    initial_whitespaces = False

            if char_counter >= 80:
                print('{} @ line {} has {} characters'.format(name, line_counter, char_counter)) 
        f.close()

if __name__ == "__main__":
    main(sys.argv[1])
