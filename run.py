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
    first = sys.argv.pop(1)

    if first in ["i", "idiomatic"]:
        target = "idiomatic"
    elif first in ["o", "optimised"]:
        target = "optimised"
    else:
        print("ERROR: Expected one of 'i'/'idiomatic' or 'o'/'optimised'")
        exit(1)
    
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
        full_directory = os.path.join("languages", directory, target)

        os.chdir(full_directory)

        time_taken = run_bench(full_directory, benchmark)
        times[directory] = time_taken

        os.chdir(cwd)

    # Ultra-fragile code - relies one exact formatting of table.md
    with open("table.md") as f:
        preexisting = [[e.strip() for e in l.split("|")[1:3]] for l in f.readlines()[2:]]
        preexisting = { lang : float(time) for lang, time in preexisting }


    # Add the preexisting times for languages we haven't benched
    times = preexisting | times

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

    if output:
        plt.savefig("bar_chart.png")

    plt.show()

if __name__ == "__main__":
    main()

