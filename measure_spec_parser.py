#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import argparse
from enum import Enum

MODE_SHIFT = 30
UNSPECIFIED_MODE_VALUE = 0 << MODE_SHIFT
EXACTLY_MODE_VALUE = 1 << MODE_SHIFT
AT_MOST_MODE_VALUE = 2 << MODE_SHIFT
MODE_MASK = 0x3 << MODE_SHIFT

class Mode(Enum):
    UNSPECIFIED = UNSPECIFIED_MODE_VALUE
    EXACTLY = EXACTLY_MODE_VALUE
    AT_MOST = AT_MOST_MODE_VALUE


def parse_mode(measure_spec):
    return Mode(measure_spec & MODE_MASK)


def parse_size(measure_spec):
    return measure_spec & ~MODE_MASK


MODE_FORMATS = {
    Mode.UNSPECIFIED: 'your {} can be any size you want',
    Mode.EXACTLY: 'your {} should be exactly {} px',
    Mode.AT_MOST: 'your {} should not exceed {} px'
}

DESCRIPTION = 'a command-line tool to parse and print readable infomation about a android measureSpec value'
parser = argparse.ArgumentParser(description=DESCRIPTION)
parser.add_argument('measure_specs',
                    type=int,
                    nargs=2,
                    help='the width and height values of measureSpec')
args = parser.parse_args()

width_spec = args.measure_specs[0]
height_spec = args.measure_specs[1]
print('The width measureSpec from parent is:[{}], '.format(width_spec), end='')

width_mode = parse_mode(width_spec)
width = parse_size(width_spec)

if width_mode == Mode.UNSPECIFIED:
    print(MODE_FORMATS[Mode.UNSPECIFIED].format('width'))
elif width_mode == Mode.EXACTLY:
    print(MODE_FORMATS[Mode.EXACTLY].format('width', width))
elif width_mode == Mode.AT_MOST:
    print(MODE_FORMATS[Mode.AT_MOST].format('width', width))

print('The height measureSpec from parent is:[{}], '.format(height_spec), end='')
height_mode = parse_mode(height_spec)
height = parse_size(height_spec)

if height_mode == Mode.UNSPECIFIED:
    print(MODE_FORMATS[Mode.UNSPECIFIED].format('height'))
elif height_mode == Mode.EXACTLY:
    print(MODE_FORMATS[Mode.EXACTLY].format('height', height))
elif height_mode == Mode.AT_MOST:
    print(MODE_FORMATS[Mode.AT_MOST].format('height', height))
