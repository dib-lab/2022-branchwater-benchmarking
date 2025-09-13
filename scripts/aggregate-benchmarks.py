import argparse
import os
import csv
import pandas as pd


def parse_benchmark_file(file_path):
    """Parse a single benchmark file and return its data as a dictionary."""
    with open(file_path, 'r') as file:
        reader = csv.DictReader(file, delimiter='\t')
        for row in reader:
            return row


def collect_benchmarks(file_list):
    """Collect all benchmark files and return their parsed contents."""
    benchmark_data = []
    for file_path in file_list:
        data = parse_benchmark_file(file_path)
        rule_name = os.path.basename(file_path).rsplit('.', 1)[0]
        data['rule'] = rule_name
        data['category'] = assign_category(rule_name)
        benchmark_data.append(data)
    return benchmark_data


def assign_category(rule_name: str) -> str:
    """Map a benchmark filename/rule to a high-level category."""
    if "zip" in rule_name:
        return "zips"
    elif "thread" in rule_name or "_t" in rule_name:
        return "threads"
    elif "largest" in rule_name or "catalog" in rule_name or "big" in rule_name:
        return "big"
    elif rule_name in ["all"]:
        return "all"
    else:
        # default fallback
        return "other"


def summarize_by_category(benchmark_data):
    """Summarize benchmarks per category."""
    df = pd.DataFrame(benchmark_data)

    # convert numeric fields
    for col in ['max_rss', 'mean_load', 'cpu_time', 's']:
        df[col] = pd.to_numeric(df[col], errors='coerce')

    summaries = []
    for category, group in df.groupby("category"):
        total_time_seconds = group['s'].sum()
        minutes = int(total_time_seconds // 60)
        seconds = int(total_time_seconds % 60)

        summaries.append({
            "category": category,
            "n_runs": len(group),
            "total_time": f"{minutes}m {seconds}s",
            "avg_time_s": round(group['s'].mean(), 2),
            "max_memory_rss_gb": round(group['max_rss'].max() / 1024.0, 2),
            "max_cpu_utilization_cores": round(group['mean_load'].max() / 1000.0, 2),
        })
    return summaries


def write_benchmark_csv(output_file, benchmark_data):
    """Write detailed benchmark data to a CSV file."""
    column_order = [
        'rule', 'category', 's', 'h:m:s', 'max_rss', 'max_vms',
        'max_uss', 'max_pss', 'io_in', 'io_out', 'mean_load', 'cpu_time'
    ]
    all_columns = [c for c in column_order if c in benchmark_data[0]]

    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=all_columns)
        writer.writeheader()
        for data in benchmark_data:
            writer.writerow({key: data.get(key, '') for key in all_columns})


def write_summary_csv(summary_file, summaries):
    """Write per-category summary to a CSV file."""
    fieldnames = ["category", "n_runs", "total_time",
                  "avg_time_s", "max_memory_rss_gb",
                  "max_cpu_utilization_cores"]
    with open(summary_file, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for row in summaries:
            writer.writerow(row)


def main(args):
    benchmark_data = collect_benchmarks(args.file_list)
    write_benchmark_csv(args.benchmarks_csv, benchmark_data)

    # if we want to summarize by category
    if args.summary_csv:
        summaries = summarize_by_category(benchmark_data)
        write_summary_csv(args.summary_csv, summaries)

        print("Per-category summary:")
        for s in summaries:
            print(s)


if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Collect and summarize Snakemake benchmark files.")
    p.add_argument("file_list", nargs='+', help="List of .txt benchmark files")
    p.add_argument("--benchmarks-csv", required=True,
                   help="Output CSV file with all benchmark data")
    p.add_argument("--summary-csv",
                   help="Output CSV file with per-category summaries")
    args = p.parse_args()
    main(args)
