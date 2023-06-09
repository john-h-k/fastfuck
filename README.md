<h1 align="center">fastfuck</h1>
<div align="center">
 <strong>
  Benchmarking languages with <a href="https://en.wikipedia.org/wiki/Brainfuck">Brainfuck</a>
 </strong>
</div>

# The what and the why

`Brainfuck` as a language is very similar to [P``](https://en.wikipedia.org/wiki/P′′), one of the simplest turing complete languages.
It also happens to be remarkably simple to write an interpreter for, and there are a vast library of preexisting brainfuck programs, so I thought
it would be an interesting project to use as a language benchmark.

For each language benchmarked, there are 2 versions:

* `idiomatic` - this contains idiomatic, normal, clean code you'd expect in a professional environment, understandable by anyone familiar with the language
* `optimised` - this contains hyper-optimised code which only has the aim of being as fast as possible - clarity/correctness be damned

### What this benchmark _does_ do

* Shows the general order-of-magnitude performance of a languae
  * You can safely use this benchmark to determine that Ruby, is, in fact, slower than C
* Demonstrates the capabilities of a language in extremely monotonic data processing, such as text-parsing

### What this benchmark _doesn't_ do

* Determine the performance of a language in all real-world contexts
  * Notably, this benchmark will give a big advantage to systems which can JIT or otherwise optimise very hot methods, as the
main loop of this program will be executed millions of times
* Determine the overally quality of a language
  * I hope this one needs no explanation


## Can I add <x> language?

Absolutely - contributions are welcome. The structure for adding a new language is extremely simple:

1. Add a new directory under languages, named appropriately
2. Create any necessary code/projects/assets within that directory
3. Create a `bench.sh` script which accepts 2 commands
  * `prepare` to perform compilation or similar steps - this can be a nop for languages that don't need it, but it must be present
  * `run` to actually run a benchmark - the file to run will be provided as the second argument to the script (as the first will be `run`)
4. Test it and open a PR

## Results
 
| Directory   |      Time |
|:------------|----------:|
| C++         |   27.7329 |
| C           |   29.3115 |
| Go          |   30.7541 |
| Rust        |   31.0722 | 
| Java        |   32.0129 |
| Swift       |   36.3749 |
| C#          |   41.6299 |
| JavaScript  |   95.9078 |
| Ruby        | 4146.0210 |
| Python      | 6163.0700 |
| Bash        | ~150 days | _(extrapolated)_

![bar chart of results](bar_chart.png)
