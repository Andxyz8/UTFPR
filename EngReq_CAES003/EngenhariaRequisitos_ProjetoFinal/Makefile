FILE="modelo_dissertacao"

all: clean
	# bibtex need this rm to working
	rm -f $(FILE).bbl

	pdflatex $(FILE)
	bibtex $(FILE) && pdflatex $(FILE)
	pdflatex $(FILE)

	# alpha order in siglas
	sort $(FILE).lsg > $(FILE).lsg.tmp
	mv $(FILE).lsg.tmp $(FILE).lsg

	pdflatex $(FILE)
	evince $(FILE).pdf &

clean:
	rm -f $(FILE).aux
	rm -f $(FILE).dvi
	rm -f $(FILE).lof
	rm -f $(FILE).log
	rm -f $(FILE).lot
	rm -f $(FILE).lsb
	rm -f $(FILE).lsg
	rm -f $(FILE).pdf
	rm -f $(FILE).toc
	rm -f $(FILE).bbl
	rm -f $(FILE).blg
	rm -f -R $(FILE) auto