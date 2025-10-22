#!/usr/bin/env bash
rgbgfx -t hello.tilemap.bin -o hello.tiledata.bin /home/jornb/Downloads/Beachball/Beachball.png

rgbasm -o hello.o hello.asm
rgblink -o hello.gb hello.o
rgbfix -v -p 0xFF hello.gb

