#!/usr/bin/env python

from sys import argv

if len(argv)<2:
    exit(0)

for arg in argv[1:-1]:
    print(arg.upper(),end=' ')
print(argv[-1].upper())
    
    
