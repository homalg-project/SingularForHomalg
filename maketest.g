##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips
##  
##  Call this with GAP.
##

LoadPackage( "SingularForHomalg" );

HOMALG_IO.show_banners := false;

LoadPackage( "GAPDoc" );

list := [
         "../gap/SingularForHomalg.gd",
         "../gap/SingularForHomalg.gi",
         ];

size := SizeScreen( );
SizeScreen([80]);

TestManualExamples( DirectoriesPackageLibrary( "SingularForHomalg", "doc" )[1]![1], "SingularForHomalg.xml", list );

GAPDocManualLab( "SingularForHomalg" );

SizeScreen( size );

