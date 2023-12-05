pandoc input.md -s -t native > usual
pandoc input.md -s -t native --lua-filter=italize-latin.lua > filtered
vimdiff usual filtered
