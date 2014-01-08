all: doc test

doc: doc/manual.six

doc/manual.six: makedoc.g \
		PackageInfo.g \
		doc/Intros.autodoc \
		doc/SingularForHomalg.bib \
		gap/*.gd gap/*.gi examples/*.g
	        gap makedoc.g

clean:
	(cd doc ; ./clean)

test:	doc
	gap maketest.g

archive: test
	(mkdir -p ../tar; cd ..; tar czvf tar/SingularForHomalg.tar.gz --exclude ".DS_Store" --exclude "*~" SingularForHomalg/doc/*.* SingularForHomalg/doc/clean SingularForHomalg/gap/*.{gi,gd} SingularForHomalg/{PackageInfo.g,README,COPYING,VERSION,init.g,read.g,makedoc.g,makefile,maketest.g} SingularForHomalg/examples/*.g SingularForHomalg/examples/doc/*.g)

WEBPOS=public_html
WEBPOS_FINAL=~/Sites/homalg-project/SingularForHomalg

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

