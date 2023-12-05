rm not.pdf yes.pdf

pandoc input.md -V mainfont="Times New Roman" -V sansfont="Times New Roman" -V monofont="Times New Roman" --pdf-engine "xelatex" -o not.pdf
pandoc input.md --lua-filter=italize-latin.lua -V mainfont="Times New Roman" -V sansfont="Times New Roman" -V monofont="Times New Roman" --pdf-engine "xelatex" -o yes.pdf
zathura not.pdf yes.pdf
