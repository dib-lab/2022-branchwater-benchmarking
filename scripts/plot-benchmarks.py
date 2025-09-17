#!/usr/bin/env python3
import argparse
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

sns.set_theme(style="whitegrid")


def load_benchmarks(benchmarks_csv: str) -> pd.DataFrame:
    df = pd.read_csv(benchmarks_csv)

    # Normalize fields
    df['mins'] = pd.to_numeric(df['s'], errors='coerce') / 60
    df['max_rss_gb'] = pd.to_numeric(df['max_rss'], errors='coerce') / 1024
    df['cpu_time_min'] = pd.to_numeric(df['cpu_time'], errors='coerce') / 60

    # detect format (mf, zipmf, ziplist) from rule
    def get_format(rule):
        if "zipmf" in rule:
            return "zipmf"
        elif "ziplist" in rule:
            return "ziplist"
        elif rule.endswith(".mf") or "mf" in rule:
            return "mf"
        else:
            return "other"

    df['format'] = df['rule'].apply(get_format)

    # detect replicate sets (like a_vs_a, a_vs_b, …)
    def get_ident(rule):
        if rule.startswith("a_vs_") and len(rule.split("_")) == 3:
            return rule.split("_")[-1]  # e.g. "a_vs_b" → "b"
        return None

    df['ident'] = df['rule'].apply(get_ident)
    return df


def plot_scaling(df, outprefix="plots"):
    """Make scaling plots for varying queries/subjects/threads."""
    threads = df[df['rule'].str.contains("_t")]
    if not threads.empty:
        fig, axs = plt.subplots(1, 3, figsize=(18, 5))

        sns.lineplot(data=threads, x="threads", y="mins", ax=axs[0], marker="o")
        axs[0].set_xlabel("threads")
        axs[0].set_ylabel("walltime (min)")

        sns.lineplot(data=threads, x="threads", y="cpu_time_min", ax=axs[1], marker="o")
        axs[1].set_xlabel("threads")
        axs[1].set_ylabel("CPU time (min)")

        sns.lineplot(data=threads, x="threads", y="max_rss_gb", ax=axs[2], marker="o")
        axs[2].set_xlabel("threads")
        axs[2].set_ylabel("max RSS (GB)")

        plt.savefig(f"{outprefix}_threads.svg", bbox_inches="tight")


def plot_formats(df, outprefix="plots"):
    """Compare mf vs ziplist vs zipmf directly."""
    formats = df[df['format'].isin(["mf", "zipmf", "ziplist"])]
    if formats.empty:
        return

    metrics = [("mins", "walltime (min)"),
               ("max_rss_gb", "max RSS (GB)"),
               ("cpu_time_min", "CPU time (min)")]

    fig, axes = plt.subplots(1, 3, figsize=(15, 4))
    for ax, (col, label) in zip(axes, metrics):
        sns.boxplot(data=formats, x="format", y=col,
                    ax=ax, palette="Set2", showfliers=False)
        sns.swarmplot(data=formats, x="format", y=col,
                      ax=ax, color="black", size=3)
        ax.set_ylabel(label)
        ax.set_xlabel("")
        ax.set_title(label)

    fig.suptitle("Comparison of data loading formats", size=18)
    plt.tight_layout()
    plt.savefig(f"{outprefix}_formats.svg", bbox_inches="tight")


def plot_replicates(df, outprefix="plots"):
    """Replicate boxplots (a_vs_a, a_vs_b, …)."""
    reps = df.dropna(subset=["ident"])
    if reps.empty:
        return

    metrics = [("mins", "time (min)", (None, None), 2),
               ("max_rss_gb", "max RSS (GB)", (None, None), 2),
               ("io_in", "IO in (GB)", (None, None), 10)]

    fig, axes = plt.subplots(1, len(metrics), figsize=(15, 4))
    fig.suptitle("Performance benchmarks (replicates)", size=18, y=1.05)

    for ax, (col, label, ylim, step) in zip(axes, metrics):
        # convert IO to GB
        if col == "io_in":
            reps["io_in_gb"] = pd.to_numeric(reps["io_in"], errors="coerce") / 1024
            col = "io_in_gb"

        sns.boxplot(data=reps, y=col,
                    ax=ax, color=(0.4, 0.6, 0.8, 0.5),
                    medianprops={"color": "coral"}, showcaps=False)
        sns.swarmplot(data=reps, y=col, ax=ax, color="black", size=4)

        if ylim[0] is not None:
            ax.set_ylim(ylim)
        ax.yaxis.set_major_locator(ticker.MultipleLocator(step))
        ax.set_ylabel(label)

    plt.tight_layout()
    plt.savefig(f"{outprefix}_replicates.svg", bbox_inches="tight")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("benchmarks_csv", help="Combined benchmarks CSV")
    ap.add_argument("--outprefix", default="plots", help="Prefix for plot files")
    args = ap.parse_args()

    df = load_benchmarks(args.benchmarks_csv)

    plot_scaling(df, outprefix=args.outprefix)
    plot_formats(df, outprefix=args.outprefix)
    plot_replicates(df, outprefix=args.outprefix)

    print(f"Plots written to {args.outprefix}_*.svg")


if __name__ == "__main__":
    main()
