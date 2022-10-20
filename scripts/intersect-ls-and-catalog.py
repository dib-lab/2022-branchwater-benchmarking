#! /usr/bin/env python
import argparse
import sys
import os.path


def main():
    p = argparse.ArgumentParser()
    p.add_argument('filesize_output')
    p.add_argument('catalog')
    args = p.parse_args()

    metagenomes = set()
    with open(args.catalog, 'rt') as fp:
        for line in fp:
            acc = os.path.basename(line.strip())
            acc = os.path.splitext(acc)[0]
            metagenomes.add(acc)
    print(f"loaded {len(metagenomes)} accessions from '{args.catalog}'",
          file=sys.stderr)
    print(f"example acc: {next(iter(metagenomes))}", file=sys.stderr)

    acc_sizes = {}
    with open(args.filesize_output, 'rt') as fp:
        for line in fp:
            size, filename = line.strip().split(' ', 1)
            acc = os.path.basename(filename)
            acc = os.path.splitext(acc)[0]

            if acc in metagenomes:
                size = int(size)
                acc_sizes[acc] = size

    print(f"Loaded {len(acc_sizes)} file sizes from '{args.filesize_output}'")

    if len(metagenomes) != len(acc_sizes):
        print(f"WARNING: missing some filesizes for some accessions.",
              file=sys.stderr)

    avg = sum(acc_sizes.values()) / len(acc_sizes)
    print(f"average file size: {avg:.1f}")

    sizes = list(acc_sizes.values())
    sizes.sort()
    median = sizes[len(sizes) // 2]
    print(f"median file size: {median}")


if __name__ == '__main__':
    sys.exit(main())
