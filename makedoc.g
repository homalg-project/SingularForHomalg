##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "GAPDoc" );

SetGapDocLaTeXOptions( "utf8" );

bib := ParseBibFiles( "doc/SingularForHomalg.bib" );
WriteBibXMLextFile( "doc/SingularForHomalgBib.xml", bib );

list := [
         "../gap/SingularForHomalg.gd",
         "../gap/SingularForHomalg.gi",
         ];

MakeGAPDocDoc( "doc", "SingularForHomalg", list, "SingularForHomalg" );

GAPDocManualLab( "SingularForHomalg" );
