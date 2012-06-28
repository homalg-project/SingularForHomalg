##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "LibSingularForHomalg" );

HOMALG_IO.show_banners := false;

LoadPackage( "GAPDoc" );

list := [
         "../gap/LibSingularForHomalg.gd",
         "../gap/LibSingularForHomalg.gi",
         ];

size := SizeScreen( );
SizeScreen([80]);

TestManualExamples( DirectoriesPackageLibrary( "LibSingularForHomalg", "doc" )[1]![1], "LibSingularForHomalg.xml", list );

GAPDocManualLab( "LibSingularForHomalg" );

SizeScreen( size );

