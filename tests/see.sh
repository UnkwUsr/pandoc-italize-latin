rm original.pdf filtered.pdf

pandoc input.md -V mainfont="Times New Roman" -V sansfont="Times New Roman" -V monofont="Times New Roman" --pdf-engine "xelatex" -o original.pdf
pandoc input.md --lua-filter=../italize-latin.lua -V mainfont="Times New Roman" -V sansfont="Times New Roman" -V monofont="Times New Roman" --pdf-engine "xelatex" -o filtered.pdf
zathura original.pdf filtered.pdf
