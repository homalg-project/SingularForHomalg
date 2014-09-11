#############################################################################
##
##  LibSingular.gd                                 SingularForHomalg package
##
##  Copyright 2011-2012, Mohamed Barakat, University of Kaiserslautern
##
##  Declarations to use Singular's interpreter via SingularInterface.
##
#############################################################################

# our info class:
DeclareInfoClass( "InfoLibSingularForHomalg" );
SetInfoLevel( InfoLibSingularForHomalg, 1 );

# a central place for configurations:
DeclareGlobalVariable( "LibSingularForHomalg" );

####################################
#
# global functions and operations:
#
####################################

DeclareGlobalFunction( "LaunchCASLibSingularForHomalg" );

DeclareGlobalFunction( "SendBlockingToCASLibSingularForHomalg" );

DeclareGlobalFunction( "TerminateCASLibSingularForHomalg" );

DeclareGlobalFunction( "InitializeMacrosForLibSingular" );

DeclareGlobalFunction( "InitializeLibSingularMacros" );

DeclareGlobalFunction( "_LibSingular_SetInvolution" );

# constructor methods:

# basic operations:

