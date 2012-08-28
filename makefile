all: doc test

doc: doc/manual.six

doc/manual.six: makedoc.g maketest.g \
		PackageInfo.g \
		doc/SingularForHomalg.bib doc/*.xml doc/*.css \
		gap/*.gd gap/*.gi examples/*.g
	        gapdev makedoc.g

clean:
	(cd doc ; ./clean)

test:	doc
	gapdev maketest.g

archive: test
	(mkdir -p ../tar; cd ..; tar czvf tar/SingularForHomalg.tar.gz --exclude ".DS_Store" --exclude "*~" SingularForHomalg/doc/*.* SingularForHomalg/doc/clean SingularForHomalg/gap/*.{gi,gd} SingularForHomalg/{CHANGES,PackageInfo.g,README,VERSION,init.g,read.g,makedoc.g,makefile,maketest.g} SingularForHomalg/examples/*.g)

WEBPOS=public_html
WEBPOS_FINAL=~/public_html/SingularForHomalg

towww: archive
	echo '<?xml version="1.0" encoding="UTF-8"?>' >${WEBPOS}.version
	echo '<mixer>' >>${WEBPOS}.version
	cat VERSION >>${WEBPOS}.version
	echo '</mixer>' >>${WEBPOS}.version
	cp PackageInfo.g ${WEBPOS}
	cp README ${WEBPOS}/README.SingularForHomalg
	cp doc/manual.pdf ${WEBPOS}/SingularForHomalg.pdf
	cp doc/*.{css,html} ${WEBPOS}
	rm -f ${WEBPOS}/*.tar.gz
	mv ../tar/SingularForHomalg.tar.gz ${WEBPOS}/SingularForHomalg-`cat VERSION`.tar.gz
	rm -f ${WEBPOS_FINAL}/*.tar.gz
	cp ${WEBPOS}/* ${WEBPOS_FINAL}
	ln -s SingularForHomalg-`cat VERSION`.tar.gz ${WEBPOS_FINAL}/SingularForHomalg.tar.gz

