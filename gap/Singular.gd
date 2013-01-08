#############################################################################
##
##  Singular.gd                                    SingularForHomalg package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##
##  Declarations for Singular.
##
#############################################################################

####################################
#
# global variables:
#
####################################

DeclareGlobalFunction( "SI_ZeroColumns" );

DeclareGlobalFunction( "SI_ZeroRows" );

DeclareGlobalFunction( "SI_BasisOfColumnModule" );

DeclareGlobalFunction( "SI_BasisOfRowModule" );

DeclareGlobalFunction( "SI_BasisOfColumnsCoeff" );

DeclareGlobalFunction( "SI_BasisOfRowsCoeff" );

DeclareGlobalFunction( "SI_DecideZeroColumns" );

DeclareGlobalFunction( "SI_DecideZeroRows" );

DeclareGlobalFunction( "SI_DecideZeroColumnsEffectively" );

DeclareGlobalFunction( "SI_DecideZeroRowsEffectively" );

DeclareGlobalFunction( "SI_SyzygiesGeneratorsOfColumns" );

DeclareGlobalFunction( "SI_SyzygiesGeneratorsOfRows" );

DeclareGlobalFunction( "SI_RelativeSyzygiesGeneratorsOfColumns" );

DeclareGlobalFunction( "SI_RelativeSyzygiesGeneratorsOfRows" );

DeclareGlobalFunction( "SI_ReducedSyzygiesGeneratorsOfColumns" );

DeclareGlobalFunction( "SI_ReducedSyzygiesGeneratorsOfRows" );

DeclareGlobalFunction( "SI_Submatrix" );

DeclareGlobalFunction( "SI_UnionOfRows" );

DeclareGlobalFunction( "SI_UnionOfColumns" );

# constructor methods:

DeclareGlobalFunction( "HomalgFieldOfRationalsInExternalLibSingular" );
