#!/usr/bin/python

import sys
import re
import Image


comment_line = re.compile("^ *\/\/")
data = re.compile("^(?P<data>[0-1]+)$")


def map_value(x, in_min, in_max, out_min, out_max):
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min


def read_file(file_name):
    input_file = open(file_name, "r+")
    pixels = []
    for line in input_file.readlines():
        if comment_line.match(line):
            continue
        pure_data = data.match(line).group()
        resolution = len(pure_data) / 3
        max_value = 2 ** resolution - 1
        r = map_value(int(pure_data[0:resolution], 2), 0, max_value, 0, 255)
        g = map_value(int(pure_data[resolution:resolution * 2], 2), 0, max_value, 0, 255)
        b = map_value(int(pure_data[resolution * 2:resolution * 3], 2), 0, max_value, 0, 255)
        pixels.append((r, g, b))
    return pixels


def bin_to_image():
    target = str(sys.argv[1])
    width = int(sys.argv[2])
    height = int(sys.argv[3])
    name, ext = target.split(".", 2)
    img = Image.new('RGB', (width, height))
    file_pixels = read_file(target)[::-1]
    pixels = img.load()
    for i in range(img.size[0]):
        for j in range(img.size[1]):
            pixels[i, j] = file_pixels.pop()
    img.save(name + ".bmp")


def image_to_bin():
    target = str(sys.argv[1])
    resolution = int(sys.argv[2])
    max_value = 2 ** resolution - 1
    name, ext = target.split(".", 2)
    out_file = open(name + ".txt", "w+")
    img = Image.open(target)
    pixels = img.load()
    str_format = "{0:0%db}" % resolution
    for i in range(img.size[0]):
        for j in range(img.size[1]):
            color = [str_format.format(map_value(c, 0, 255, 0, max_value)) for c in pixels[i, j]]
            line = ''.join(color)
            out_file.write(line)
            out_file.write("\r\n")


if __name__ == '__main__':
    if len(sys.argv) == 3 and str(sys.argv[1]).endswith(".bmp"):
        image_to_bin()
    elif len(sys.argv) == 4 and str(sys.argv[1]).endswith(".txt"):
        bin_to_image()
    else:
        print "..."








