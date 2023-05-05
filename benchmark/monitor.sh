#! /usr/bin/bash

top -b -d1 -o +%MEM | grep -A1 'KiB Mem' >> memory.log