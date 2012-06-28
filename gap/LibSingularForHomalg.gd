#############################################################################
##
##  LibSingularForHomalg.gd                     LibSingularForHomalg package
##
##  Copyright 2011, Mohamed Barakat, University of Kaiserslautern
##
##  Declaration stuff for LibSingularForHomalg.
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

# basic operations:

