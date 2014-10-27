#############################################################################
##
##  SingularInterpreter.gi                         SingularForHomalg package
##
##  Copyright 2011-2012, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations to use Singular's interpreter via SingularInterface.
##
#############################################################################

####################################
#
# global variables:
#
####################################

InstallValue( SingularInterpreterForHomalg,
        rec(
            
            )
);

####################################
#
# initialization
#
####################################

HOMALG_IO_Singular.LaunchCAS := LaunchCASSingularInterpreterForHomalg;

####################################
#
# methods for operations:
#
####################################

##
InstallGlobalFunction( LaunchCASSingularInterpreterForHomalg,
  function( arg )
    local success, s;
    
    success := LoadPackage( "SingularInterface" );
    
    if success = true then
        
        s := rec(
                 lines := "",
                 errors := "",
                 ## name := "SingularInterpreter", ## using anything other than Singular a name will screw up UpdateMacrosOfLaunchedCASs
                 SendBlockingToCAS := SendBlockingToCASSingularInterpreterForHomalg,
                 SendBlockingToCAS_original := SendBlockingToCASSingularInterpreterForHomalg,
                 TerminateCAS := TerminateCASSingularInterpreterForHomalg,
                 InitializeMacros := InitializeMacrosForSingularInterpreter,
                 InitializeCASMacros := InitializeSingularInterpreterMacros,
                 setinvol := _SingularInterpreter_SetInvolution,
                 init_string := Concatenation( HOMALG_IO_Singular.init_string, ";option(notWarnSB)" ),
                 pid := "of GAP",
                 remove_enter := true,
                 trim_display := ""
                 );
        
        return s;
        
    else
        
        return fail;
        
    fi;
    
end );

##
InstallGlobalFunction( SendBlockingToCASSingularInterpreterForHomalg,
  function( arg )
    local stream, r;
    
    if ( Length( arg ) = 2 and IsRecord( arg[1] ) and IsString( arg[2] ) ) then
        
        stream := arg[1];
        
        r := Singular( arg[2] );
        
        stream.lines := SingularLastOutput( );
        
        if r then
            stream.errors := "";
        else
            stream.errors := Concatenation( "error: ", SingularLastError( ) );
        fi;
        
    else
        Error("Wrong number or type of arguments.");
    fi;
    
end );

InstallGlobalFunction( TerminateCASSingularInterpreterForHomalg,
  function( arg )
    # Make this a no-op, as we can never re-start SingularInterpreter
    # SingularInterpreter will exit when gap exits
end );

##
InstallGlobalFunction( InitializeMacrosForSingularInterpreter,
  function( macros, stream )
    
    macros := InitializeMacros( macros, stream );
    
    homalgSendBlocking( [ "export ", macros ], "need_command", stream, HOMALG_IO.Pictograms.initialize );
    
end );

##
InstallGlobalFunction( InitializeSingularInterpreterMacros,
  function( stream )
    local macros;
    
    macros := InitializeSingularMacros( stream );
    
    homalgSendBlocking( [ "export ", macros ], "need_command", stream, HOMALG_IO.Pictograms.initialize );
    
end );

##
InstallGlobalFunction( _SingularInterpreter_SetInvolution,
  function( R )
    
    _Singular_SetInvolution( R );
    
    homalgSendBlocking( "export Involution", "need_command", R, HOMALG_IO.Pictograms.initialize );
    
end );
