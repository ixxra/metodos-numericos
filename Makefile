PARSER_PATH = "src/parser/tex2html.rb"
PARSER = ruby ${PARSER_PATH}

notes:
	cd latex && pdflatex -shell-escape notes
	cd latex && bibtex notes
	cd latex && pdflatex -shell-escape notes
	cd latex && pdflatex -shell-escape notes
	mv latex/notes.pdf pdf/
	

.PHONY : html clean
html:
	${PARSER}  latex/01-preliminares.tex > html/notes.html

clean:
	echo "TODO"
