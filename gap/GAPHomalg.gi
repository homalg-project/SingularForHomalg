#############################################################################
##
##  GAPHomalg.gi                                   SingularForHomalg package
##
##  Copyright 2012-2013, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations for the external computer algebra system GAP with libsing.
##
#############################################################################

####################################
#
# representations, families, and types:
#
####################################

##
DeclareRepresentation( "IsHomalgExternalLibSingRingObjectRep",
        IsHomalgExternalRingObjectInGAPRep,
        [ "ring", "homalgTable" ] );

##
BindGlobal( "TheTypeHomalgExternalLibSingObjectRing",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgExternalLibSingRingObjectRep ) );

##
DeclareRepresentation( "IsHomalgExternalLibSingRingRep",
        IsHomalgExternalRingInGAPRep,
        [ "ring", "homalgTable" ] );

##
BindGlobal( "TheTypeHomalgExternalLibSingRing",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgExternalLibSingRingRep ) );

####################################
#
# global functions and variables:
#
####################################

##
InstallValue( RingMacrosForGAPWithLibSing,
        rec(
            
            _CAS_name := "gap",
            
            _Identifier := "libsing",
            
            ("!init_string_libsing") := "LoadPackage(\"libsing\")",
            
            )
        
        );

##
UpdateMacrosOfCAS( RingMacrosForGAPWithLibSing, GAPHomalgMacros );
UpdateMacrosOfLaunchedCASs( RingMacrosForGAPWithLibSing );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( MatElm,
        "for homalg external matrices in GAP using libsing",
        [ IsHomalgExternalMatrixRep, IsPosInt, IsPosInt, IsHomalgExternalLibSingRingRep ],
        
  function( M, r, c, R )
    local ext_obj;
    
    ext_obj := homalgSendBlocking( [ "SI_\\\[(", M, c, r, ")" ], HOMALG_IO.Pictograms.MatElm );
    
    return HomalgExternalRingElement( ext_obj, R );
    
end );

####################################
#
# constructor functions and methods:
#
####################################

## talk with libsing via external gap equipped with the libsing package
InstallGlobalFunction( HomalgFieldOfRationalsInExternalLibSing,
  function( arg )
    local nargs, param, minimal_polynomial, Q, R;
    
    ## we create Q[dummy_variable] and feed only expressions without
    ## "dummy_variable" to Singular. Since GAP does not know about
    ## the dummy_variable it will vanish during the next ring extension
    
    nargs := Length( arg );
    
    if nargs > 0 and IsString( arg[1] ) then
        
        param := ParseListOfIndeterminates( SplitString( arg[1], "," ) );
        
        arg := arg{[ 2 .. nargs ]};
        
        if nargs > 1 and IsString( arg[1] ) then
            minimal_polynomial := arg[1];
            arg := arg{[ 2 .. nargs - 1 ]};
        fi;
        
        Q := CallFuncList( HomalgFieldOfRationalsInLibSing, arg );
        
        R := [ "(0,", JoinStringsWithSeparator( param ), "),dummy_variable,dp" ];
        
    else
        
        R := "0,dummy_variable,dp";
        
    fi;
    
    R := Concatenation( [ R ], [ IsPrincipalIdealRing ], arg );
    
    ## the above code is copied and still unused
    R := "SI_ring(0,[\"dummy_variable\"])";
    
    ## ugly hack
    R := RingForHomalgInExternalGAP( TheTypeHomalgExternalLibSingObjectRing, R, TheTypeHomalgExternalLibSingRing );
    
    if IsBound( minimal_polynomial ) then
        ## FIXME: we assume the polynomial is irreducible of degree > 1
        homalgSendBlocking( [ "minpoly=", minimal_polynomial ], "need_command", R, HOMALG_IO.Pictograms.define );
        R!.MinimalPolynomialOfPrimitiveElement := minimal_polynomial;
    fi;
    
    if IsBound( param ) then
        
        param := List( param, a -> a / R );
        
        Perform( param, function( v ) SetName( v, homalgPointer( v ) ); end );
        
        SetRationalParameters( R, param );
        
        SetIsFieldForHomalg( R, true );
        
        SetCoefficientsRing( R, Q );
        
    else
        
        SetIsRationalsForHomalg( R, true );
        
    fi;
    
    SetRingProperties( R, 0 );
    
    return R;
    
end );

##
InstallMethod( PolynomialRing,
        "for homalg rings in external GAP equipped with libsing",
        [ IsHomalgExternalLibSingRingRep, IsList ],
        
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
        ext_obj := homalgSendBlocking( [ "XXXX(", param, ",", var, ")" ], TheTypeHomalgExternalLibSingObjectRing, properties, R, HOMALG_IO.Pictograms.CreateHomalgRing );
    else
        ext_obj := homalgSendBlocking( [ "SI_ring(", Characteristic( R ), param, ",", var, ")" ], TheTypeHomalgExternalLibSingObjectRing, properties, R, HOMALG_IO.Pictograms.CreateHomalgRing );
    fi;
    
    S := CreateHomalgExternalRing( ext_obj, TheTypeHomalgExternalLibSingRing );
    
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

##
InstallMethod( CreateHomalgMatrixFromString,
        "constructor for homalg matrices",
        [ IsString, IsInt, IsInt, IsHomalgExternalLibSingRingRep ],
        
  function( S, r, c, R )
    local s;
    
    s := ShallowCopy( S );
    
    RemoveCharacters( s, "\[\]\\\n\"\ " );
    
    s := homalgSendBlocking( [ "SI_transpose(SI_matrix(", R!.ring, r, c, ",\"", s, "\"))" ], HOMALG_IO.Pictograms.HomalgMatrix );
    
    return HomalgMatrix( s, r, c, R );
    
end );

#############################################
#
# Override Display method for SingularForHomalg
#
#############################################

##
InstallMethod( Display,
        "for homalg external LibSing matrices",
        [ IsHomalgExternalMatrixRep ], 1,
        
  function( o )
    
    if not IsHomalgExternalLibSingRingRep( HomalgRing( o ) ) then
        
        TryNextMethod( );
        
    fi;
    
    Print( homalgSendBlocking( [ "Display( SI_transpose( ", o, " ) )" ], "need_display", HOMALG_IO.Pictograms.Display ) );
    
end );
