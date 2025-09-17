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
        "benchmarks/big_benchmarks.csv",

rule zips:
    input:
        expand("outputs/output_a_{n}_vs_a_zipmf.csv", n=range(100, 1100, 100)),
        expand("outputs/output_a_{n}_vs_a_ziplist.csv", n=range(100, 1100, 100)),
        expand("outputs/output_a_vs_a_{n}_zipmf.csv", n=range(1000, 10000, 1000)),
        expand("outputs/output_a_vs_a_{n}_ziplist.csv", n=range(1000, 10000, 1000)),
        # aggregated zip benchmarks
        "benchmarks/zips_benchmarks.csv",

rule threads:
    input:
        expand("benchmarks/a_vs_a_1000_t{t}.txt", t=[4,8,16,24,32,40,48,56,64]),
        # zip threads
        expand("benchmarks/a_vs_a_{n}_t{thr}_zipmf.txt", n=range(1000, 10000, 1000), thr=[4,8,16,24,32,40,48,56,64]),
        expand("benchmarks/a_vs_a_{n}_t{thr}_ziplist.txt", n=range(1000, 10000, 1000), thr=[4,8,16,24,32,40,48,56,64]),
        # aggregated threads benchmarks
        "benchmarks/threads_benchmarks.csv",


wildcard_constraints:
    n = r"[0-9]+",
    thr = r"[0-9]+"


rule a_vs_a:
    """
    Run the full GTDB list A (1000 genomes) against the full wort A.
    formats:
        GTDB list A: *sig.zip
        wort A: manifest csv for loading sig files
    """
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
    """
    Run a subset of GTDB list A (e.g. 1k, 2k, ..., 9k) against the full wort A.
    formats:
        GTDB list A: zip files
        wort A: manifest csv for loading sig files
    """
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

rule a_sub_vs_a_zipmf:
    """
    Run a subset of GTDB list A (100, 200, ..., 900, 1000) against the full wort A.
    formats:
        GTDB list A: *sig.zip
        wort A: manifest for loading sig.zip files directly
    """
    input:
        queries="data/gtdb-list-a-{n}.sig.zip",
        # against="data/wort-list-a.ziplist.txt",
        against="data/wort-list.a.zip-mf.csv"
    output:
        csv="outputs/output_a_{n}_vs_a_zipmf.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_{n}_vs_a_zipmf.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_sub_vs_a_ziplist:
    """
    Run a subset of GTDB list A (100, 200, ..., 900, 1000) against the full wort A.
    formats:
        GTDB list A: *sig.zip
        wort A: txt file listing zips
    """
    input:
        queries="data/gtdb-list-a-{n}.sig.zip",
        against="data/wort-list-a.ziplist.txt",
    output:
        csv="outputs/output_a_{n}_vs_a_ziplist.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_{n}_vs_a_ziplist.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_vs_a_sub:
    """
    Run the full GTDB list A (1000 genomes) against a subset of wort A (1k, 2k, ..., 9k).
    formats:
        GTDB list A: *sig.zip
        wort A: manifest csv for loading sig files
    """
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


rule a_vs_a_sub_zipmf:
    """
    Run the full GTDB list A (1000 genomes) against a subset of wort A (1k, 2k, ..., 9k).
    formats:
        GTDB list A: *sig.zip
        wort A: manifest for loading sig.zip files directly
    """
    input:
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list.a-{n}.zip-mf.csv"
    output:
        csv="outputs/output_a_vs_a_{n}_zipmf.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_a_{n}_zipmf.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """


rule a_vs_a_sub_ziplist:
    """
    Run the full GTDB list A (1000 genomes) against a subset of wort A (1k, 2k, ..., 9k).
    formats:
        GTDB list A: *sig.zip
        wort A: ziplist file listing zips
    """
    input:
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list-a-{n}.ziplist.txt"
    output:
        csv="outputs/output_a_vs_a_{n}_ziplist.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_a_{n}_ziplist.txt"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads}
    """

rule a_vs_b:
    """
    Run the full GTDB list A (1000 genomes) against the full wort B.
    formats:
        GTDB list A: *sig.zip
        wort B: manifest csv for loading sig files
    """
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
        against="data/wort-largest-10k.check-mf.csv",
    output:
        csv="outputs/output_a_vs_largest_10k.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_largest_10k.txt"
    log: "logs/a_vs_largest_10k.log"
    threads: 32
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {threads} 2> {log}
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

rule a_vs_a_sub_threads_zipmf:
    """
    Run the full GTDB list A (1000 genomes) against a subset of wort A (1k, 2k, ..., 9k).
    formats:
        GTDB list A: *sig.zip
        wort A: manifest for loading sig.zip files directly
    """
    input:
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list.a-{n}.zip-mf.csv"
    output:
        csv="outputs/output_a_vs_a_{n}_t{thr}_zipmf.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_a_{n}_t{thr}_zipmf.txt"
    threads: 64                 # max out threads so nothing else running
    shell: """
        {manysearch_cmd} -k 31 --scaled=1000 -o {output.csv} \
            {input.queries} {input.against} -c {wildcards.thr}
    """

rule a_vs_a_sub_threads_ziplist:
    """
    Run the full GTDB list A (1000 genomes) against a subset of wort A (1k, 2k, ..., 9k).
    formats:
        GTDB list A: *sig.zip
        wort A: ziplist file listing zips
    """
    input:
        queries="data/gtdb-list-a-1000.sig.zip",
        against="data/wort-list-a-{n}.ziplist.txt",
    output:
        csv="outputs/output_a_vs_a_{n}_t{thr}_ziplist.csv",
    resources:
        only_one_job=1,
    benchmark:
        "benchmarks/a_vs_a_{n}_t{thr}_ziplist.txt"
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

rule aggregate_big:
    input:
        expand("benchmarks/{f}.txt", f=[
            "a_vs_largest_10k",
            "a_vs_catalog",
            *["a_{n}_vs_a".format(n=n) for n in range(100, 1000, 100)],
            *["a_vs_a_{n}".format(n=n) for n in range(1000, 10000, 1000)],
        ])
    output:
        benchmarks_csv="benchmarks/big_benchmarks.csv",
        summary_csv="benchmarks/big_summary.csv"
    log: "logs/aggregate_big.log"
    shell:
        """
        python scripts/aggregate-benchmarks.py {input} \
            --benchmarks-csv {output.benchmarks_csv} \
            --summary-csv {output.summary_csv} \
            > {log} 2>&1
        """

rule aggregate_threads:
    input:
        expand("benchmarks/a_vs_a_1000_t{t}.txt", t=[4,8,16,24,32,40,48,56,64])
    output:
        benchmarks_csv="benchmarks/threads_benchmarks.csv",
        summary_csv="benchmarks/threads_summary.csv"
    log: "logs/aggregate_threads.log"
    shell:
        """
        python scripts/aggregate-benchmarks.py {input} \
            --benchmarks-csv {output.benchmarks_csv} \
            --summary-csv {output.summary_csv} \
            > {log} 2>&1
        """

rule aggregate_zips:
    input:
        expand("benchmarks/a_{n}_vs_a_zipmf.txt", n=range(100, 1100, 100)),
        expand("benchmarks/a_{n}_vs_a_ziplist.txt", n=range(100, 1100, 100)),
        expand("benchmarks/a_vs_a_{n}_zipmf.txt", n=range(1000, 10000, 1000)),
        expand("benchmarks/a_vs_a_{n}_ziplist.txt", n=range(1000, 10000, 1000)),
    output:
        benchmarks_csv="benchmarks/zips_benchmarks.csv",
        summary_csv="benchmarks/zips_summary.csv"
    log: "logs/aggregate_zips.log"
    shell:
        """
        python scripts/aggregate-benchmarks.py {input} \
            --benchmarks-csv {output.benchmarks_csv} \
            --summary-csv {output.summary_csv} \
            > {log} 2>&1
        """

rule aggregate_all:
    input:
        expand("benchmarks/a_vs_{y}.txt", y=['a', 'b', 'c', 'd', 'e'])
    output:
        benchmarks_csv="benchmarks/all_benchmarks.csv",
        summary_csv="benchmarks/all_summary.csv"
    log: "logs/aggregate_all.log"
    shell:
        """
        python scripts/aggregate-benchmarks.py {input} \
            --benchmarks-csv {output.benchmarks_csv} \
            --summary-csv {output.summary_csv} \
            > {log} 2>&1
        """

rule aggregate_benchmarks:
    input:
        "benchmarks/big_benchmarks.csv",
        "benchmarks/threads_benchmarks.csv",
        "benchmarks/zips_benchmarks.csv",
        "benchmarks/all_benchmarks.csv"
    output:
        "benchmarks/combined_benchmarks.csv"
    run:
        import pandas as pd
        dfs = [pd.read_csv(f) for f in input]
        pd.concat(dfs, ignore_index=True).to_csv(output[0], index=False)
