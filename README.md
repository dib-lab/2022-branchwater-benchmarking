## Running

```
srun -p high2 --time=72:00:00 --nodes=1             --cpus-per-task 64 --mem 64GB             --pty bash
```

then

```
snakemake -j 64 -n -s benchmarking.snakefile
```

## command to get file sizes

```
find . -type f -printf "%k %p\n" | tee ~/scratch/magsearch/ls-wort.txt
```
