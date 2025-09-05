#sra_search_bin="/home/ctbrown/scratch/magsearch/bin/searcher"
manysearch_cmd = "sourmash scripts manysearch "
#manysearch_cmd = "sourmash scripts manysearch --ignore-abundance"

rule all:
    input:
        expand("benchmarks/{x}_vs_{y}.txt", x=['a'],
               y=['a', 'b', 'c', 'd', 'e']),
        expand("outputs/output_{x}_vs_{y}.csv", x=['a'],
               y=['a', 'b', 'c', 'd', 'e']),

rule big:
    input:
        expand("benchmarks/a_vs_a_1000_t{t}.txt", t=[4,8,16]),
        "outputs/output_a_vs_largest_10k.csv",
        expand("benchmarks/a_vs_catalog.txt"),
        expand("benchmarks/a_{n}_vs_a.txt", n=range(100, 1000, 100)),
        expand("benchmarks/a_vs_a_{n}.txt", n=range(1000, 10000, 1000)),

rule threads:
    input:
        expand("benchmarks/a_vs_a_1000_t{t}.txt", t=[4,8,16,24,32,40,48,56,64]),
    

rule a_vs_a:
    input:
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list.a.mf.csv",
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
        queries="data/gtdb-list-a-{n}.sig.zip",
        against="data/wort-list.a.mf.csv",
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
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list.a.{n}.mf.csv"
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
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list.b.mf.csv",
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
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list.c.mf.csv",
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
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list.d.mf.csv",
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
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list.e.mf.csv",
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
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-largest-10k.mf.csv.gz",
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
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list.a.{n}.mf.csv",
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
        queries="data/gtdb-list-a-1000.sig.zip",
        against="/group/ctbrowngrp5/wort/wort-sra/SOURMASH-MANIFEST.csv.gz"
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
