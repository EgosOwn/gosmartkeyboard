#!/usr/bin/env python3
# Remove fenced code blocks from generated HTML files
# We need to do this because srcweave does not support fenced code blocks

import glob
for f in glob.glob('docs/*.html'):
    with open(f, 'r') as fin:
        lines = fin.readlines()
    with open(f, 'w') as fout:
        for line in lines:
            if line.startswith('<p>```'):
                continue
            fout.write(line)