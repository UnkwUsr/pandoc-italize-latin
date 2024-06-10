pandoc input.md -s -t native > original.raw
pandoc input.md -s -t native --lua-filter=../italize-latin.lua > filtered.raw
vimdiff original.raw filtered.raw
