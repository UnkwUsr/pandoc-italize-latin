This is pandoc filter that italizes all latin words in text, leaving words in
other alphabets untouched (like cyrillic). This is requirement in Russian
papers.

## Usage

```shell
pandoc --lua-filter=italize-latin.lua input -o output
pandoc --lua-filter=italize-latin.lua input.md -o output.pdf
pandoc --lua-filter=italize-latin.lua input.md -o output.md
```

## Example

```
$ cat a.md
Unix-way - это хорошо

$ pandoc a.md --lua-filter=italize-latin.lua -o b.md

$ cat b.md
*Unix-way* - это хорошо
```
