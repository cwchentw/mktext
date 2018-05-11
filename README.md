# mktext - An Useless Text-Processing Utility that Exploits Make Functions.

**DON'T USE IT IN PRODUCTION CODE.**

We developed `mktext` just to demo how to use Make functions.

## System Requirement

* A recent `sh` compatible shell.
* A recent GNU Make >= 3.81

We tested `mktext` on a recent CentOS. It should work on most modern Unix-like systems.

## Usage

`mktext` provides several actions in functional styles:

* `any`
* `all`
* `filter`
* `select`
* `sub`
* `sort`
* `first`
* `last`
* `nth`
* `range`

`any` checks whether any element fits *cond*:

```
$ ./mktext any x x y z
true
```

`all` checks whether all elements fit *cond*:

```
$ ./mktext all x x y z
false
```

`filter` removes elements by *cond*:

```
$ ./mktext filter "a b c" a b c d e f g
d
e
f
g
```

`select` keeps elements by *cond*:

```
$ ./mktext select "a b c" a b c d e f g
a
b
c
```

`sub` replaces *from* with *to*:

```
$ ./mktext sub ee ea beer deer feet
bear
dear
feat
```

`sort` sorts elements alphabetically:

```
$ ./mktext sort b d a e c
a
b
c
d
e
```

`first` returns the first element:

```
$ ./mktext first a b c d e
a
```

`last` returns the last element:

```
$ ./mktext last a b c d e
e
```

`nth` returns the *n*th element:

```
$ ./mktext nth 4 a b c d e
d
```

`range` returns the elements from *m*th to *n*th, inclusively on both side:

```
$ ./mktext range 2 4 a b c d e
b
c
d
```

Besides, use `-h` and `--help` to print help message:

```
$ ./mktext --help
Usage: ./mktext action ...

Actions:
        all cond arg_a arg_b arg_c ...
(Omit some message...)
```

## Philosophy

Make functions are a small sets of LISPy functions that are greek to many programmers from C family languages. Hence, we wrote `mktext` to show how to (improperly) use those functions.

`make` itself is unable to handle command-line arguments and several other features seen in `mktext`. To handle those issues, we embedded a Makefile in a shell script so that we can manage those issues with a `sh` compatible shell. We limit ourself in the features provided by `make` when possble; otherwise, we use the features available in the system shell.

To make a more useful alternative, consider to port it in Perl or some other modern scripting language.

## Author

Michael Chen, 2018.

## License

MIT
