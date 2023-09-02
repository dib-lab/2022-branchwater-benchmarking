import pandas as pd

def load_benchmark_replicate(filename, ident):
    df = pd.read_csv(filename, sep='\t')
    df['ident'] = ident
    
    return df

print("reading from benchmarks/a_vs_{x}.txt...")
replicates_df = [ load_benchmark_replicate(f"benchmarks/a_vs_{x}.txt", x) for x in ('a','b','c','d','e')]
#query_line.append(load_benchmark_and_annotate('benchmarks/a_vs_a.txt', 1000, 10000))
replicates_df = pd.concat(replicates_df)
replicates_df

replicates_df['m'] = replicates_df['s'] / 60.0
print(f"mean time (minutes) {replicates_df.m.mean():.1f} +/- {replicates_df.m.std():.1f}")

print(f"mean RSS (GB) {replicates_df.max_rss.mean()/1000:.1f} +/- {replicates_df.max_rss.std()/1000:.1f}")

print(f"mean I/O (kb) {replicates_df.io_in.mean():.1f} +/- {replicates_df.io_in.std():.1f}")
