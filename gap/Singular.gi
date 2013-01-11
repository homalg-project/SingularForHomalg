#############################################################################
##
##  Singular.gi                                    SingularForHomalg package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations to use Singular via libsing.
##
#############################################################################

####################################
#
# global variables:
#
####################################

####################################
#
# representations, families, and types:
#
####################################

##
DeclareRepresentation( "IsHomalgLibSingRingRep",
        IsHomalgInternalRingRep,
        [ "ring", "homalgTable" ] );

##
BindGlobal( "TheTypeHomalgLibSingRing",
        NewType( TheFamilyOfHomalgRings,
                IsHomalgLibSingRingRep ) );

####################################
#
# global functions and variables:
#
####################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( IsUnit,
        "",
        [ IsHomalgLibSingRingRep, IsRingElement ],
        
  function( R, r )
    
    return SI_deg( r ) = 0;
    
end );

##
InstallMethod( MatElm,
        "for homalg internal matrices",
        [ IsHomalgInternalMatrixRep, IsPosInt, IsPosInt, IsHomalgLibSingRingRep ],
        
  function( M, r, c, R )
    
    return SI_\[( Eval( M )!.matrix, c, r );
    
end );

####################################
#
# constructor functions and methods:
#
####################################

## talk with libsingular via the GAP package libsing
InstallGlobalFunction( HomalgFieldOfRationalsInLibSing,
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
    R := SI_ring( 0, [ "dummy_variable" ] );
    
    R := CreateHomalgRing( R, [ TheTypeHomalgLibSingRing, TheTypeHomalgInternalMatrix ] );
    
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
        "for homalg rings in Singular",
        [ IsHomalgLibSingRingRep, IsList ],
        
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
        ext_obj := homalgSendBlocking( [ "(integer", param, "),(", var, "),dp" ] , [ "ring" ], TheTypeHomalgExternalRingObjectInSingular, properties, R, HOMALG_IO.Pictograms.CreateHomalgRing );
    else
        ext_obj := SI_ring( Characteristic( R ), var );
    fi;
    
    S := CreateHomalgRing( ext_obj, [ TheTypeHomalgLibSingRing, TheTypeHomalgInternalMatrix ] );
    
    if IsBound( r!.MinimalPolynomialOfPrimitiveElement ) then
        homalgSendBlocking( [ "minpoly=", r!.MinimalPolynomialOfPrimitiveElement ], "need_command", S, HOMALG_IO.Pictograms.define );
    fi;
    
    var := List( var, a -> a / S );
    
    Perform( var, function( v ) SetName( v, String( v ) ); end );
    
    SetIsFreePolynomialRing( S, true );
    
    if HasIndeterminatesOfPolynomialRing( R ) and IndeterminatesOfPolynomialRing( R ) <> [ ] then
        SetBaseRing( S, R );
        l := Length( var );
        SetRelativeIndeterminatesOfPolynomialRing( S, var{[ l - nr_var + 1 .. l ]} );
    fi;
    
    SetRingProperties( S, r, var );
    
    #_Singular_SetRing( S );
    
    RP := homalgTable( S );
    
    #RP!.SetInvolution :=
    #  function( R )
    #    homalgSendBlocking( "\nproc Involution (matrix m)\n{\n  return(transpose(m));\n}\n\n", "need_command", R, HOMALG_IO.Pictograms.define );
    #end;
    
    #homalgStream( S ).setinvol( S );
    
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
InstallMethod( \/,
        "for ring elements",
        [ IsString, IsHomalgLibSingRingRep ],
        
  function( r, R )
    
    return SI_poly( R!.ring, String( r ) );
    
end );

##
InstallMethod( \/,
        "for ring elements",
        [ IsRingElement, IsHomalgLibSingRingRep ],
        
  function( r, R )
    
    return String( r ) / R;
    
end );

##
InstallMethod( CreateHomalgMatrixFromString,
        "constructor for homalg matrices",
        [ IsString, IsInt, IsInt, IsHomalgLibSingRingRep ],
        
  function( S, r, c, R )
    local s;
    
    s := ShallowCopy( S );
    
    RemoveCharacters( s, "\[\]\\\n\"\ " );
    
    s := homalgInternalMatrixHull( SI_transpose( SI_matrix( R!.ring, r, c, s ) ) );
    
    return HomalgMatrix( s, r, c, R );
    
end );

##
InstallMethod( CreateHomalgMatrixFromList,
        "constructor for homalg matrices",
        [ IsList, IsInt, IsInt, IsHomalgLibSingRingRep ],
        
  function( M, r, c, R )
    
    M := homalgInternalMatrixHull( SI_transpose( SI_matrix( r, c, M ) ) );
    
    return HomalgMatrix( M, r, c, R );
    
end );

#############################################
#
# Override Display method for SingularForHomalg
#
#############################################

##
InstallMethod( Display,
        "for homalg LibSing matrices",
        [ IsHomalgInternalMatrixRep ], 1,
        
  function( o )
    
    if not IsHomalgLibSingRingRep( HomalgRing( o ) ) then
        
        TryNextMethod( );
        
    fi;
    
    Display( SI_transpose( Eval( o )!.matrix ) );
    
end );
