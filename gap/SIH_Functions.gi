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
    
    return [ M, SI_lift( B, SI_\-( M, A ) ) ];
    
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
    
    return SI_\[( SI_nres( M, 2 ), 2 );
    
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
    
    zero := SI_\[( M, 0 );
    
    return Filtered( [ 1 .. SI_ncols( M ) ], i -> SI_\=\=( SI_\[( M, i ), zero ) = 1 );
    
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
    
    N := Flat( List( row_range, r -> List( col_range, c -> SI_\[( M , r, c ) ) ) );
    
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
