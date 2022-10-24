sra_search_bin="/home/ctbrown/scratch/magsearch/bin/searcher"

rule all:
    input:
        expand("benchmarks/{x}_vs_{y}.txt", x=['a'],
               y=['a', 'b', 'c', 'd', 'e']),
        "outputs/output_a_vs_largest_10k.csv",
        expand("benchmarks/a_{n}_vs_a.txt", n=range(100, 1000, 100)),
        expand("benchmarks/a_vs_a_{n}.txt", n=range(1000, 10000, 1000)),

rule a_vs_a:
    input:
        bin=sra_search_bin,
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-a.txt",
    output:
        csv="outputs/output_a_vs_a.csv",
    benchmark:
        "benchmarks/a_vs_a.txt"
    threads: 32
    shell: """
        export RAYON_NUM_THREADS={threads}
        {input.bin} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against}
    """

rule a_sub_vs_a:
    input:
        bin=sra_search_bin,
        queries="data/gtdb-list-a-{n}.sigs.txt",
        against="data/wort-list-a.txt",
    output:
        csv="outputs/output_a_{n}_vs_a.csv",
    benchmark:
        "benchmarks/a_{n}_vs_a.txt"
    threads: 32
    shell: """
        export RAYON_NUM_THREADS={threads}
        {input.bin} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against}
    """

rule a_vs_a_sub:
    input:
        bin=sra_search_bin,
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-a-{n}.txt",
    output:
        csv="outputs/output_a_vs_a_{n}.csv",
    benchmark:
        "benchmarks/a_vs_a_{n}.txt"
    threads: 32
    shell: """
        export RAYON_NUM_THREADS={threads}
        {input.bin} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against}
    """

rule a_vs_b:
    input:
        bin=sra_search_bin,
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-b.txt",
    output:
        csv="outputs/output_a_vs_b.csv",
    benchmark:
        "benchmarks/a_vs_b.txt"
    threads: 32
    shell: """
        export RAYON_NUM_THREADS={threads}
        {input.bin} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against}
    """

rule a_vs_c:
    input:
        bin=sra_search_bin,
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-c.txt",
    output:
        csv="outputs/output_a_vs_c.csv",
    benchmark:
        "benchmarks/a_vs_c.txt"
    threads: 32
    shell: """
        export RAYON_NUM_THREADS={threads}
        {input.bin} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against}
    """

rule a_vs_d:
    input:
        bin=sra_search_bin,
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-d.txt",
    output:
        csv="outputs/output_a_vs_d.csv",
    benchmark:
        "benchmarks/a_vs_d.txt"
    threads: 32
    shell: """
        export RAYON_NUM_THREADS={threads}
        {input.bin} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against}
    """

rule a_vs_e:
    input:
        bin=sra_search_bin,
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-e.txt",
    output:
        csv="outputs/output_a_vs_e.csv",
    benchmark:
        "benchmarks/a_vs_e.txt"
    threads: 32
    shell: """
        export RAYON_NUM_THREADS={threads}
        {input.bin} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against}
    """

rule a_vs_largest:
    input:
        bin=sra_search_bin,
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-largest-10k.txt",
    output:
        csv="outputs/output_a_vs_largest_10k.csv",
    benchmark:
        "benchmarks/a_vs_largest_10k.txt"
    threads: 32
    shell: """
        export RAYON_NUM_THREADS={threads}
        {input.bin} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against}
    """

