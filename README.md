## Running

```!
srun -p high2 --time=72:00:00 --nodes=1 --cpus-per-task 64 --mem 64GB --pty bash
```

then

```
snakemake -j 64 -s benchmarking.snakefile --resources only_one_job=1
```

## appendix

### command to get file sizes

```
find . -type f -printf "%k %p\n" | tee ~/scratch/magsearch/ls-wort.txt
```
