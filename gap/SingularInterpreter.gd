#############################################################################
##
##  SingularInterpreter.gd                         SingularForHomalg package
##
##  Copyright 2011-2012, Mohamed Barakat, University of Kaiserslautern
##
##  Declarations to use Singular's interpreter via SingularInterface.
##
#############################################################################

# our info class:
DeclareInfoClass( "InfoSingularInterpreterForHomalg" );
SetInfoLevel( InfoSingularInterpreterForHomalg, 1 );

# a central place for configurations:
DeclareGlobalVariable( "SingularInterpreterForHomalg" );

####################################
#
# global functions and operations:
#
####################################

DeclareGlobalFunction( "LaunchCASSingularInterpreterForHomalg" );

DeclareGlobalFunction( "SendBlockingToCASSingularInterpreterForHomalg" );

DeclareGlobalFunction( "TerminateCASSingularInterpreterForHomalg" );

DeclareGlobalFunction( "InitializeMacrosForSingularInterpreter" );

DeclareGlobalFunction( "InitializeSingularInterpreterMacros" );

DeclareGlobalFunction( "_SingularInterpreter_SetInvolution" );

# constructor methods:

# basic operations:

