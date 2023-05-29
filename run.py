#!/usr/bin/env python

import subprocess
import time
import matplotlib.pyplot as plt
from tabulate import tabulate
import sys
import os

# This script actually runs the benchmark and builds the data

def run_bench(directory, benchmark):
    # Set dir and build
    subprocess.check_output(["./bench.sh", "prepare"])

    # Run the bench command and measure the time taken
    start = time.monotonic()
    subprocess.check_call(["./bench.sh", "run", benchmark])
    end = time.monotonic()

    # Return the time taken
    return end - start

def main():
    # 11/10 flag handling here
    output = False
    if "--output" in sys.argv:
        output = True
        sys.argv.remove("--output")
    
    if len(sys.argv) == 1:
        directories = os.listdir("./languages")
    else:
        directories = sys.argv[1:]

    print(f"Executing benchmark for: {directories}")

    # A dictionary to hold the times for each directory
    times = {}

    cwd = os.getcwd()

    benchmark = os.path.abspath("./bench/mandelbrot.b")

    # Run the bench command in each directory and record the time taken
    for directory in directories:
        directory = os.path.join("languages", directory)

        os.chdir(directory)

        time_taken = run_bench(directory, benchmark)
        times[directory] = time_taken

        os.chdir(cwd)

    # Print a markdown table of the times
    table = tabulate(times.items(), headers=["Directory", "Time"], tablefmt="pipe")

    print(table)

    if output:
        with open("table.md", "w") as f:
            f.write(table)

    # Generate a bar chart of the times
    plt.bar(times.keys(), times.values())
    plt.xlabel("Directory")
    plt.ylabel("Time (s)")
    plt.title("Bench Time for Each Directory")

    plt.show()

    if output:
        plt.savefig("bar_chart.png")

if __name__ == "__main__":
    main()

