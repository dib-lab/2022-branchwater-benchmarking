# Benchmarks for branchwater paper

This repo contains the benchmarking code for

[Sourmash Branchwater Enables Lightweight Petabyte-Scale Sequence Search](https://dib-lab.github.io/2022-paper-branchwater-software/) ([github repo](https://github.com/dib-lab/2022-paper-branchwater-software/)), Irber et al., 2022.

[doi: 10.1101/2022.11.02.514947](https://www.biorxiv.org/content/10.1101/2022.11.02.514947v1.full)

## Running

Allocate 64 threads and 64 GB:
```!
srun -p high2 --time=72:00:00 --nodes=1 --cpus-per-task 64 --mem 80GB --pty bash
```

then run the snakemake workflow:
```
snakemake -c 64 -p -s benchmarking.snakefile  --resources only_one_job=1 -k
```

## appendix

### command to get file sizes

```
find . -type f -printf "%k %p\n" | tee ~/scratch/magsearch/ls-wort.txt
```
