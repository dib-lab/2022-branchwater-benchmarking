sra_search_bin="/home/ctbrown/scratch/magsearch/bin/searcher"

rule all:
    input:
        expand("benchmarks/{x}_vs_{y}.txt", x=['a'], y=['a', 'b', 'c', 'd', 'e'])

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
