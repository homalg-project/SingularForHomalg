##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "GAPDoc" );

SetGapDocLaTeXOptions( "utf8" );

bib := ParseBibFiles( "doc/LibSingularForHomalg.bib" );
WriteBibXMLextFile( "doc/LibSingularForHomalgBib.xml", bib );

list := [
         "../gap/LibSingularForHomalg.gd",
         "../gap/LibSingularForHomalg.gi",
         ];

MakeGAPDocDoc( "doc", "LibSingularForHomalg", list, "LibSingularForHomalg" );

GAPDocManualLab( "LibSingularForHomalg" );
