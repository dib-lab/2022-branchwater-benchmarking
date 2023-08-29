#sra_search_bin="/home/ctbrown/scratch/magsearch/bin/searcher"
manysearch_cmd = "sourmash scripts manysearch"

rule all:
    input:
        expand("benchmarks/{x}_vs_{y}.txt", x=['a'],
               y=['a', 'b', 'c', 'd', 'e']),
        "outputs/output_a_vs_largest_10k.csv",
        expand("benchmarks/a_{n}_vs_a.txt", n=range(100, 1000, 100)),
        expand("benchmarks/a_vs_a_{n}.txt", n=range(1000, 10000, 1000)),
        expand("benchmarks/a_vs_a_1000_t{t}.txt", t=[4,8,16]),
        expand("benchmarks/a_vs_catalog.txt"),

rule threads:
    input:
        expand("benchmarks/a_vs_a_1000_t{t}.txt", t=[4,8,16,24,32,40,48,56,64]),
    

rule a_vs_a:
    input:
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-a.txt",
    output:
        csv="outputs/output_a_vs_a.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_a.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_sub_vs_a:
    input:
        queries="data/gtdb-list-a-{n}.sigs.txt",
        against="data/wort-list-a.txt",
    output:
        csv="outputs/output_a_{n}_vs_a.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_{n}_vs_a.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_vs_a_sub:
    input:
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-a-{n}.txt",
    output:
        csv="outputs/output_a_vs_a_{n}.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_a_{n}.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_vs_b:
    input:
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-b.txt",
    output:
        csv="outputs/output_a_vs_b.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_b.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_vs_c:
    input:
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-c.txt",
    output:
        csv="outputs/output_a_vs_c.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_c.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_vs_d:
    input:
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-d.txt",
    output:
        csv="outputs/output_a_vs_d.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_d.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_vs_e:
    input:
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-e.txt",
    output:
        csv="outputs/output_a_vs_e.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_e.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_vs_largest:
    input:
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-largest-10k.txt",
    output:
        csv="outputs/output_a_vs_largest_10k.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_largest_10k.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_vs_a_sub_threads:
    input:
        queries="data/gtdb-list-a.sigs.txt",
        against="data/wort-list-a-{n}.txt",
    output:
        csv="outputs/output_a_vs_a_{n}_t{thr}.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_a_{n}_t{thr}.txt"
    threads: 64                 # max out threads so nothing else running
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {wildcards.thr}
    """


rule a_vs_catalog:
    input:
        queries="data/gtdb-list-a.sigs.txt",
        against="data/metagenomes-catalog.txt",
    output:
        csv="outputs/output_a_vs_catalog.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_catalog.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads} || true
    """
