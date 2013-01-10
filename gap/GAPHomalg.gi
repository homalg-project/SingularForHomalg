#############################################################################
##
##  GAPHomalg.gi                                   SingularForHomalg package
##
##  Copyright 2012-2013, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations for the external computer algebra system GAP with LibSing.
##
#############################################################################

##
InstallValue( RingMacrosForGAPWithSingularForHomalg,
        rec(
            
            _CAS_name := "gap",
            
            _Identifier := "SingularForHomalg",
            
            $init_string_SingularForHomalg := "LoadPackage(\"SingularForHomalg\")",
            
            )
        
        );

##
UpdateMacrosOfCAS( RingMacrosForGAPWithSingularForHomalg, GAPHomalgMacros );
UpdateMacrosOfLaunchedCASs( RingMacrosForGAPWithSingularForHomalg );

####################################
#
# constructor functions and methods:
#
####################################

##
InstallMethod( PolynomialRing,
        "for homalg rings in external GAP",
        [ IsHomalgExternalRingInGAPRep, IsList ],
        
  function( R, indets )
    local ar, r, var, nr_var, properties, param, ext_obj, S, l, RP;
    
    ar := _PrepareInputForPolynomialRing( R, indets );
    
    r := ar[1];
    var := ar[2];	## all indeterminates, relative and base
    nr_var := ar[3];	## the number of relative indeterminates
    properties := ar[4];
    param := ar[5];
    
    ## create the new ring
    if HasIsIntegersForHomalg( r ) and IsIntegersForHomalg( r ) then
        ext_obj := homalgSendBlocking( [ "HomalgRingOfIntegersInLibSingular(", param, ")*", var ], TheTypeHomalgExternalRingObjectInGAP, properties, R, HOMALG_IO.Pictograms.CreateHomalgRing );
    else
        ext_obj := homalgSendBlocking( [ "HomalgFieldOfRationalsInLibSingular(", Characteristic( R ), param, ")*", var ], TheTypeHomalgExternalRingObjectInGAP, properties, R, HOMALG_IO.Pictograms.CreateHomalgRing );
    fi;
    
    S := CreateHomalgExternalRing( ext_obj, TheTypeHomalgExternalRingInGAP );
    
    if IsBound( r!.MinimalPolynomialOfPrimitiveElement ) then
        homalgSendBlocking( [ "minpoly=", r!.MinimalPolynomialOfPrimitiveElement ], "need_command", S, HOMALG_IO.Pictograms.define );
    fi;
    
    var := List( var, a -> HomalgExternalRingElement( a, S ) );
    
    Perform( var, function( v ) SetName( v, homalgPointer( v ) ); end );
    
    SetIsFreePolynomialRing( S, true );
    
    if HasIndeterminatesOfPolynomialRing( R ) and IndeterminatesOfPolynomialRing( R ) <> [ ] then
        SetBaseRing( S, R );
        l := Length( var );
        SetRelativeIndeterminatesOfPolynomialRing( S, var{[ l - nr_var + 1 .. l ]} );
    fi;
    
    SetRingProperties( S, r, var );
    
    if not ( HasIsFieldForHomalg( r ) and IsFieldForHomalg( r ) ) then
        Unbind( RP!.IsUnit );
        Unbind( RP!.GetColumnIndependentUnitPositions );
        Unbind( RP!.GetRowIndependentUnitPositions );
        Unbind( RP!.GetUnitPosition );
    fi;
    
    if HasIsIntegersForHomalg( r ) and IsIntegersForHomalg( r ) then
        RP!.IsUnit := RP!.IsUnit_Z;
        RP!.GetColumnIndependentUnitPositions := RP!.GetColumnIndependentUnitPositions_Z;
        RP!.GetRowIndependentUnitPositions := RP!.GetRowIndependentUnitPositions_Z;
        RP!.GetUnitPosition := RP!.GetUnitPosition_Z;
    fi;
    
    return S;
    
end );
