#############################################################################
##
##  Singular.gi                                    SingularForHomalg package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations for Singular.
##
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

##
InstallGlobalFunction( SI_BasisOfColumnModule,
  function( M )
    
    return SI_matrix( SI_std( M ) );
    
end );

##
InstallGlobalFunction( SI_BasisOfRowModule,
  function( M )
    
    return SI_transpose( SI_BasisOfColumnModule( SI_transpose( M ) ) );
    
end );

##
InstallGlobalFunction( SI_BasisOfColumnsCoeff,
  function( M )
    local B;
    
    B := SI_BasisOfColumnModule( M );
    
    return [ B, SI_lift( M, B ) ];
    
end );

##
InstallGlobalFunction( SI_BasisOfRowsCoeff,
  function( M )
    
    return List( SI_BasisOfColumnsCoeff( SI_transpose( M ) ), SI_transpose );
    
end );

##
InstallGlobalFunction( SI_DecideZeroColumns,
  function( A, B )
    
    return SI_matrix( SI_reduce( A, B ) );
    
end );

##
InstallGlobalFunction( SI_DecideZeroRows,
  function( A, B )
    
    return SI_transpose( SI_DecideZeroColumns( SI_transpose( A ), SI_transpose( B ) ) );
    
end );

##
InstallGlobalFunction( SI_DecideZeroColumnsEffectively,
  function( A, B )
    local M;
    
    M := SI_DecideZeroColumns( A, B );
    
    return [ M, SI_lift( B, SI_\-( M, A ) ) ];
    
end );

##
InstallGlobalFunction( SI_DecideZeroRowsEffectively,
  function( A, B )
    
    return List( SI_DecideZeroColumnsEffectively( SI_transpose( A ), SI_transpose( B ) ), SI_transpose );
    
end );

##
InstallGlobalFunction( SI_SyzygiesGeneratorsOfColumns,
  function( M )
    
    return SI_matrix( SI_syz( M ) );
    
end );

##
InstallGlobalFunction( SI_SyzygiesGeneratorsOfRows,
  function( M )
    
    return SI_transpose( SI_SyzygiesGeneratorsOfColumns( SI_transpose( M ) ) );
    
end );

##
InstallGlobalFunction( SI_RelativeSyzygiesGeneratorsOfColumns,
  function( M, M2 )
    
    return SI_BasisOfColumnModule( SI_modulo( M, M2 ) );
    
end );

##
InstallGlobalFunction( SI_RelativeSyzygiesGeneratorsOfRows,
  function( M, M2 )
    
    return SI_transpose( SI_RelativeSyzygiesGeneratorsOfColumns( SI_transpose( M ), SI_transpose( M2 ) ) );
    
end );

##
InstallGlobalFunction( SI_ReducedSyzygiesGeneratorsOfColumns,
  function( M )
    
    return SI_\[( SI_nres( M, 2 ), 2 );
    
end );

##
InstallGlobalFunction( SI_ReducedSyzygiesGeneratorsOfRows,
  function( M )
    
    return SI_transpose( SI_ReducedSyzygiesGeneratorsOfColumns( SI_transpose( M ) ) );
    
end );

##
InstallGlobalFunction( SI_ZeroColumns,
  function( M, R )
    local zero;
    
    M := SI_module( M );
    
    zero := SI_vector( SI_poly( R, "0" ) );
    
    return Filtered( [ 1 .. SI_ncols( M ) ], i -> SI_\=\=( SI_\[( M, i ), zero ) = 1 );
    
end );

##
InstallGlobalFunction( SI_ZeroRows,
  function( M, R )
    
    return SI_ZeroColumns( SI_transpose( M ), R );
    
end );

##
InstallGlobalFunction( SI_Submatrix,
  function( M, row_range, col_range )
    local N;
    
    N := Flat( List( row_range, r -> List( col_range, c -> SI_\[( M , r, c ) ) ) );
    
    return SI_matrix( Length( row_range ), Length( col_range ), N );
    
end );

##
InstallGlobalFunction( SI_UnionOfRows,
  function( M, N )
    local rM, cM, rN;
    
    rM := SI_nrows( M );
    cM := SI_ncols( M );
    rN := SI_nrows( N );
    
    M := List( [ 1 .. rM ], r -> List( [ 1 .. cM ], c -> SI_\[( M, r, c ) ) );
    N := List( [ 1 .. rN ], r -> List( [ 1 .. cM ], c -> SI_\[( N, r, c ) ) );
    
    return SI_matrix( rM + rN, cM, Flat( Concatenation( M, N ) ) );
    
end );

##
InstallGlobalFunction( SI_UnionOfColumns,
  function( M, N )
    local rM, cM, cN;
    
    rM := SI_nrows( M );
    cM := SI_ncols( M );
    cN := SI_ncols( N );
    
    M := List( [ 1 .. rM ], r -> List( [ 1 .. cM ], c -> SI_\[( M, r, c ) ) );
    N := List( [ 1 .. rM ], r -> List( [ 1 .. cN ], c -> SI_\[( N, r, c ) ) );
    
    return
      SI_matrix( rM, cM + cN,
              Flat( ListN( M, N,
                      function( r1, r2 ) return Flat( Concatenation( r1, r2 ) ); end
                        ) ) );
    
end );

####################################
#
# methods for operations:
#
####################################

## Max, Char <> 2
InstallMethod( IsZero,
        "",
        [ IsSingularPoly ],
        
  function( r )
    
    return SI_\=\=( r, SI_\+( r, r ) ) = 1;
    
end );

## Max
InstallMethod( IsOne,
        "",
        [ IsSingularPoly ],
        
  function( r )
    
    return not IsZero( r ) and IsZero( SI_\-( SI_\*( r, r ), r ) );
    
end );

## Max
InstallMethod( ZeroAttr,
        "",
        [ IsSingularPoly ],
        
  function( r )
    
    return SI_\-( r, r );
    
end );

## Max
InstallMethod( \<,
        "",
        [ IsSingularPoly, IsSingularPoly ],
        
  function( r1, r2 )
    
    return String( r1 ) < String( r2 );
    
end );

## Max
InstallMethod( \+,
        "",
        [ IsSingularPoly, IsSingularPoly ],
        
  function( r1, r2 )
    
    return SI_\+( r1, r2 );
    
end );

## Max
InstallMethod( \*,
        "",
        [ IsSingularPoly, IsSingularPoly ],
        
  function( r1, r2 )
    
    return SI_\*( r1, r2 );
    
end );

## Max
InstallMethod( One,
        "",
        [ IsSingularPoly ],
        
  function( r )
    
    if IsOne( r ) then
        return r;
    elif IsOne( SI_\-( Zero( r ), r ) ) then
        return SI_\-( Zero( r ), r );
    fi;
    
    TryNextMethod( );
    
end );

## Max
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
    
    s := homalgInternalMatrixHull( SI_transpose( SI_matrix( r, c, R!.ring, s ) ) );
    
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
