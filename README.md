## command to get file sizes

```
find . -type f -printf "%k %p\n" | tee ~/scratch/magsearch/ls-wort.txt
```
