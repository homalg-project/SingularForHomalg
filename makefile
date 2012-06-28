all: doc test

doc: doc/manual.six

doc/manual.six: makedoc.g maketest.g \
		PackageInfo.g \
		doc/LibSingularForHomalg.bib doc/*.xml doc/*.css \
		gap/*.gd gap/*.gi examples/*.g
	        gapdev makedoc.g

clean:
	(cd doc ; ./clean)

test:	doc
	gapdev maketest.g

archive: test
	(mkdir -p ../tar; cd ..; tar czvf tar/LibSingularForHomalg.tar.gz --exclude ".DS_Store" --exclude "*~" LibSingularForHomalg/doc/*.* LibSingularForHomalg/doc/clean LibSingularForHomalg/gap/*.{gi,gd} LibSingularForHomalg/{CHANGES,PackageInfo.g,README,VERSION,init.g,read.g,makedoc.g,makefile,maketest.g} LibSingularForHomalg/examples/*.g)

WEBPOS=public_html
WEBPOS_FINAL=~/public_html/LibSingularForHomalg

towww: archive
	echo '<?xml version="1.0" encoding="UTF-8"?>' >${WEBPOS}.version
	echo '<mixer>' >>${WEBPOS}.version
	cat VERSION >>${WEBPOS}.version
	echo '</mixer>' >>${WEBPOS}.version
	cp PackageInfo.g ${WEBPOS}
	cp README ${WEBPOS}/README.LibSingularForHomalg
	cp doc/manual.pdf ${WEBPOS}/LibSingularForHomalg.pdf
	cp doc/*.{css,html} ${WEBPOS}
	rm -f ${WEBPOS}/*.tar.gz
	mv ../tar/LibSingularForHomalg.tar.gz ${WEBPOS}/LibSingularForHomalg-`cat VERSION`.tar.gz
	rm -f ${WEBPOS_FINAL}/*.tar.gz
	cp ${WEBPOS}/* ${WEBPOS_FINAL}
	ln -s LibSingularForHomalg-`cat VERSION`.tar.gz ${WEBPOS_FINAL}/LibSingularForHomalg.tar.gz

