PARSER_PATH = "src/parser/tex2html.rb"
PARSER = ruby ${PARSER_PATH}

notes:
	pdflatex -shell-escape 01-preliminares.tex


.PHONY : html
html:
	${PARSER}  01-preliminares.tex > html/notes.html
