PARSER_PATH = "src/parser/tex2html.rb"
PARSER = ruby ${PARSER_PATH}

notes:
	cd latex && pdflatex -shell-escape 01-preliminares.tex
	mv latex/01-preliminares.pdf pdf/
	

.PHONY : html clean
html:
	${PARSER}  latex/01-preliminares.tex > html/notes.html

clean:
	echo "TODO"
