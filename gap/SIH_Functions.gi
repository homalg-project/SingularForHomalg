##
InstallGlobalFunction( SIH_BasisOfColumnModule,
  function( M )
    
    return SI_matrix( SI_std( M ) );
    
end );

##
InstallGlobalFunction( SIH_BasisOfRowModule,
  function( M )
    
    return SI_transpose( SIH_BasisOfColumnModule( SI_transpose( M ) ) );
    
end );

##
InstallGlobalFunction( SIH_BasisOfColumnsCoeff,
  function( M )
    local B;
    
    B := SIH_BasisOfColumnModule( M );
    
    return [ B, SI_lift( M, B ) ];
    
end );

##
InstallGlobalFunction( SIH_BasisOfRowsCoeff,
  function( M )
    
    return List( SIH_BasisOfColumnsCoeff( SI_transpose( M ) ), SI_transpose );
    
end );

##
InstallGlobalFunction( SIH_DecideZeroColumns,
  function( A, B )
    
    return SI_matrix( SI_reduce( A, B ) );
    
end );

##
InstallGlobalFunction( SIH_DecideZeroRows,
  function( A, B )
    
    return SI_transpose( SIH_DecideZeroColumns( SI_transpose( A ), SI_transpose( B ) ) );
    
end );

##
InstallGlobalFunction( SIH_DecideZeroColumnsEffectively,
  function( A, B )
    local M;
    
    M := SIH_DecideZeroColumns( A, B );
    
    return [ M, SI_lift( B, M - A ) ];
    
end );

##
InstallGlobalFunction( SIH_DecideZeroRowsEffectively,
  function( A, B )
    
    return List( SIH_DecideZeroColumnsEffectively( SI_transpose( A ), SI_transpose( B ) ), SI_transpose );
    
end );

##
InstallGlobalFunction( SIH_SyzygiesGeneratorsOfColumns,
  function( M )
    
    return SI_matrix( SI_syz( M ) );
    
end );

##
InstallGlobalFunction( SIH_SyzygiesGeneratorsOfRows,
  function( M )
    
    return SI_transpose( SIH_SyzygiesGeneratorsOfColumns( SI_transpose( M ) ) );
    
end );

##
InstallGlobalFunction( SIH_RelativeSyzygiesGeneratorsOfColumns,
  function( M, M2 )
    
    return SIH_BasisOfColumnModule( SI_modulo( M, M2 ) );
    
end );

##
InstallGlobalFunction( SIH_RelativeSyzygiesGeneratorsOfRows,
  function( M, M2 )
    
    return SI_transpose( SIH_RelativeSyzygiesGeneratorsOfColumns( SI_transpose( M ), SI_transpose( M2 ) ) );
    
end );

##
InstallGlobalFunction( SIH_ReducedSyzygiesGeneratorsOfColumns,
  function( M )
    
    return SI_nres( M, 2 )[2];
    
end );

##
InstallGlobalFunction( SIH_ReducedSyzygiesGeneratorsOfRows,
  function( M )
    
    return SI_transpose( SIH_ReducedSyzygiesGeneratorsOfColumns( SI_transpose( M ) ) );
    
end );

##
InstallGlobalFunction( SIH_ZeroColumns,
  function( M )
    local zero;
    
    M := SI_module( M );
    
    zero := M[0];
    
    ##FIXME: should become: return Filtered( M, IsZero );
    return Filtered( [ 1 .. SI_ncols( M ) ], i -> SI_\=\=( M[i], zero ) = 1 );
    
end );

##
InstallGlobalFunction( SIH_ZeroRows,
  function( M )
    
    return SIH_ZeroColumns( SI_transpose( M ) );
    
end );

##
InstallGlobalFunction( SIH_Submatrix,
  function( M, row_range, col_range )
    local N;
    
    N := Flat( List( row_range, r -> List( col_range, c -> SI_\[( M, r, c ) ) ) );
    
    return SI_matrix( Length( row_range ), Length( col_range ), N );
    
end );

##
InstallGlobalFunction( SIH_UnionOfRows,
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
InstallGlobalFunction( SIH_UnionOfColumns,
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

##
InstallGlobalFunction( SIH_GetColumnIndependentUnitPositions,
  function( M, poslist )
    local R, rest, pos, i, j, k;
    
    R := SI_ring( M );
    
    rest := [ 1 .. SI_ncols( M ) ];
    
    pos := [ ];
    
    for i in [ 1 .. SI_nrows( M ) ] do
        for k in Reversed( rest ) do
            if not [ i, k ] in poslist and
               ##FIXME: IsUnit( R, MatElm( M, i, k ) ) then
               SI_deg( SI_\[( M, i, k ) ) = 0 then
                Add( pos, [ i, k ] );
                rest := Filtered( rest,
                                a -> IsZero( SI_\[( M, i, a ) ) );
                break;
            fi;
        od;
    od;
    
    ##FIXME:
    #if pos <> [ ] then
    #    SetIsZero( M, false );
    #fi;
    
    return pos;
    
end );

##
InstallGlobalFunction( SIH_GetRowIndependentUnitPositions,
  function( M, poslist )
    local R, rest, pos, j, i, k;
    
    R := SI_ring( M );
    
    rest := [ 1 .. SI_nrows( M ) ];
    
    pos := [ ];
    
    for j in [ 1 .. SI_ncols( M ) ] do
        for k in Reversed( rest ) do
            if not [ j, k ] in poslist and
               ##FIXME: IsUnit( R, MatElm( M, k, j ) ) then
               SI_deg( SI_\[( M, k, j ) ) = 0 then
                Add( pos, [ j, k ] );
                rest := Filtered( rest,
                                a -> IsZero( SI_\[( M, a, j ) ) );
                break;
            fi;
        od;
    od;
    
    ##FIXME:
    #if pos <> [ ] then
    #    SetIsZero( M, false );
    #fi;
    
    return pos;
    
end );

##
InstallGlobalFunction( SIH_GetUnitPosition,
  function( M, poslist )
    local R, pos, m, n, i, j;
    
    R := SI_ring( M );
    
    m := SI_ncols( M );
    n := SI_nrows( M );
    
    for i in [ 1 .. m ] do
        for j in [ 1 .. n ] do
            if not [ i, j ] in poslist and not j in poslist and
               ##FIXME: IsUnit( R, SI_\[( M, j, i ) ) then
               SI_deg( SI_\[( M, j, i ) ) = 0 then
                ##FIXME: SetIsZero( M, false );
                return [ i, j ];
            fi;
        od;
    od;
    
    return fail;
    
end );
