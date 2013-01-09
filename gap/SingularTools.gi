#############################################################################
##
##  SingularTools.gi          RingsForHomalg package  Markus Lange-Hegermann
##                                                            Simon Goertzen
##
##  Copyright 2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations for the rings provided by Singular.
##
#############################################################################

####################################
#
# global variables:
#
####################################

InstallValue( CommonHomalgTableForLibSingularTools,
        
        rec(
               
               Zero := R -> SI_poly( R!.ring, "0" ),
               
               One := R -> SI_poly( R!.ring, "1" ),
               
               MinusOne := R -> SI_poly( R!.ring, "-1" ),
               
               IsZero := r -> SI_\=\=( r, ~.Zero ) = 1,
               
               IsOne := r -> SI_\=\=( r, ~.One ) = 1,
               
               Minus :=
                 function( a, b )
                   
                   return SI_\-( Eval( a )!.matrix, Eval( b )!.matrix );
                   
                 end,
               
               IsUnit := #FIXME: just for polynomial rings(?)
                 function( R, u )
                   
                   return SI_deg( u ) = 0;
                   
                 end,
               
               IsUnit_Z := #FIXME: just for polynomial rings(?)
                 function( R, u )
                   
                   return homalgSendBlocking( [ "( ", u, " == 1 || ", u, " == -1 )" ], "need_output", HOMALG_IO.Pictograms.IsUnit ) = "0";
                   
                 end,
               
               Sum :=
                 function( a, b )
                   
                   return SI_\+( a, b );
                   
                 end,
               
               Product :=
                 function( a, b )
                   
                   return SI_\*( a, b );
                   
                 end,
               
               Gcd :=
                 function( a, b )
                   
                   return SI_gcd( a, b );
                   
                 end,
               
               CancelGcd :=
                 function( a, b )
                   local g, a_g, b_g;
                   
                   g := homalgSendBlocking( [ "gcd(", a, b, ")" ], [ "def" ], HOMALG_IO.Pictograms.Gcd );
                   a_g := homalgSendBlocking( [ "poly(", a, ") / (", g, ")" ], [ "def" ], HOMALG_IO.Pictograms.CancelGcd );
                   b_g := homalgSendBlocking( [ "poly(", b, ") / (", g, ")" ], [ "def" ], HOMALG_IO.Pictograms.CancelGcd );
                   
                   return [ a_g, b_g ];
                   
                 end,
               
               ShallowCopy := C -> homalgInternalMatrixHull( SI_matrix( Eval( C )!.matrix ) ),
               
               CopyMatrix :=
                 function( C, R )
                   
                   return homalgInternalMatrixHull( SI_imap( HomalgRing( C ), Eval( C )!.matrix ) );
                   
                 end,
               
               ImportMatrix :=
                 function( M, R )
                   local r, c;
                   
                   r := Length( M );
                   c := Length( M[1] );
                   
                   return homalgInternalMatrixHull( SI_transpose( SI_matrix( r, c, Flat( M ) ) ) );
                   
                 end,
               
               ZeroMatrix :=
                 function( C )
                   local R, c, r;
                   
                   R := HomalgRing( C );
                   
                   c := NrColumns( C );
                   r := NrRows( C );
                   
                   ## do not use anything which invokes SI_transpose here
                   return homalgInternalMatrixHull( SI_matrix( c, r, R!.ring, "0" ) );
                   
                 end,
               
               IdentityMatrix :=
                 function( C )
                   local R, r, id;
                   
                   R := HomalgRing( C );
                   
                   r := NrRows( C );
                   
                   id := JoinStringsWithSeparator( Flat( IdentityMat( r ) ) );
                   
                   ## do not use anything which invokes SI_transpose here
                   return homalgInternalMatrixHull( SI_matrix( r, r, R!.ring, id ) );
                   
                 end,
               
               AreEqualMatrices :=
                 function( A, B )
                   
                   return SI_\=\=( Eval( A )!.matrix, Eval( B )!.matrix ) = 1;
                   
                 end,
               
               Involution :=
                 function( M )
                   
                   return homalgInternalMatrixHull( SI_transpose( Eval( M )!.matrix ) );
                   
                 end,
               
               CertainRows :=
                 function( M, plist )
                   
                   return homalgInternalMatrixHull( SI_Submatrix( Eval( M )!.matrix, [ 1 .. NrColumns( M ) ], plist ) );
                   
                 end,
               
               CertainColumns :=
                 function( M, plist )
                   
                   return homalgInternalMatrixHull( SI_Submatrix( Eval( M )!.matrix, plist, [ 1 .. NrRows( M ) ] ) );
                   
                 end,
               
               UnionOfRows :=
                 function( A, B )
                   
                   return homalgInternalMatrixHull( SI_UnionOfColumns( Eval( A )!.matrix, Eval( B )!.matrix ) );
                   
                 end,
               
               UnionOfColumns :=
                 function( A, B )
                   
                   return homalgInternalMatrixHull( SI_UnionOfRows( Eval( A )!.matrix, Eval( B )!.matrix ) );
                   
                 end,
               
               XDiagMat :=
                 function( e )
                   local f;
                   
                   f := Concatenation( [ "dsum(" ], e, [ ")" ] );
                   
                   return homalgSendBlocking( f, [ "matrix" ], [ "[", Sum( List( e, NrColumns ) ), "][", Sum( List( e, NrRows ) ), "]" ], HOMALG_IO.Pictograms.DiagMat );
                   
                 end,
               
               XKroneckerMat :=
                 function( A, B )
                   
                   return homalgSendBlocking( [ "tensor(", A, B, ")" ], [ "matrix" ], [ "[", NrColumns( A ) * NrColumns( B ), "][", NrRows( A ) * NrRows( B ), "]" ], HOMALG_IO.Pictograms.KroneckerMat );
                   
                 end,
               
               MulMat :=
                 function( a, A )
                   
                   return homalgInternalMatrixHull( SI_\*( a, Eval( A )!.matrix ) );
                   
                 end,
               
               AddMat :=
                 function( A, B )
                   
                   return homalgInternalMatrixHull( SI_\+( Eval( A )!.matrix, Eval( B )!.matrix ) );
                   
                 end,
               
               SubMat :=
                 function( A, B )
                   
                   return homalgInternalMatrixHull( SI_\-( Eval( A )!.matrix, Eval( B )!.matrix ) );
                   
                 end,
               
               Compose :=
                 function( A, B )
                   
                   return homalgInternalMatrixHull( SI_\*( Eval( B )!.matrix, Eval( A )!.matrix ) ); ## ;-)
                   
                 end,
               
               NrRows :=
                 function( C )
                   
                   return SI_ncols( Eval( C )!.matrix );
                    
                 end,
               
               NrColumns :=
                 function( C )
                   
                   return SI_nrows( Eval( C )!.matrix );
                   
                 end,
               
               Determinant :=
                 function( C )
                   
                   return SI_det( Eval( C )!.matrix );
                   
                 end,
               
               XIsZeroMatrix :=
                 function( M )
                   
                   return homalgSendBlocking( [ "IsZeroMatrix(", M, ")" ], "need_output", HOMALG_IO.Pictograms.IsZeroMatrix ) = "1";
                   
                 end,
               
               XIsIdentityMatrix :=
                 function( M )
                   
                   return homalgSendBlocking( [ "IsIdentityMatrix(", M, ")" ], "need_output", HOMALG_IO.Pictograms.IsIdentityMatrix ) = "1";
                   
                 end,
               
               XIsDiagonalMatrix :=
                 function( M )
                   
                   return homalgSendBlocking( [ "IsDiagonalMatrix(", M, ")" ], "need_output", HOMALG_IO.Pictograms.IsDiagonalMatrix ) = "1";
                   
                 end,
               
               ZeroRows :=
                 function( C )
                   
                   return SI_ZeroColumns( Eval( C )!.matrix, HomalgRing( C )!.ring );
                   
                 end,
               
               ZeroColumns :=
                 function( C )
                   
                   return SI_ZeroRows( Eval( C )!.matrix, HomalgRing( C )!.ring );
                   
                 end,
               
               XGetColumnIndependentUnitPositions :=
                 function( M, pos_list )
                   local list;
                   
                   if pos_list = [ ] then
                       list := [ 0 ];
                   else
                       Error( "a non-empty second argument is not supported in Singular yet: ", pos_list, "\n" );
                       list := pos_list;
                   fi;
                   
                   return StringToDoubleIntList( homalgSendBlocking( [ "GetColumnIndependentUnitPositions(", M, ", list (", list, "))" ], "need_output", HOMALG_IO.Pictograms.GetColumnIndependentUnitPositions ) );
                   
                 end,
               
               XGetColumnIndependentUnitPositions_Z :=
                 function( M, pos_list )
                   local list;
                   
                   if pos_list = [ ] then
                       list := [ 0 ];
                   else
                       Error( "a non-empty second argument is not supported in Singular yet: ", pos_list, "\n" );
                       list := pos_list;
                   fi;
                   
                   return StringToDoubleIntList( homalgSendBlocking( [ "GetColumnIndependentUnitPositions_Z(", M, ", list (", list, "))" ], "need_output", HOMALG_IO.Pictograms.GetColumnIndependentUnitPositions ) );
                   
                 end,
               
               XGetRowIndependentUnitPositions :=
                 function( M, pos_list )
                   local list;
                   
                   if pos_list = [ ] then
                       list := [ 0 ];
                   else
                       Error( "a non-empty second argument is not supported in Singular yet: ", pos_list, "\n" );
                       list := pos_list;
                   fi;
                   
                   return StringToDoubleIntList( homalgSendBlocking( [ "GetRowIndependentUnitPositions(", M, ", list (", list, "))" ], "need_output", HOMALG_IO.Pictograms.GetRowIndependentUnitPositions ) );
                   
                 end,
               
               XGetRowIndependentUnitPositions_Z :=
                 function( M, pos_list )
                   local list;
                   
                   if pos_list = [ ] then
                       list := [ 0 ];
                   else
                       Error( "a non-empty second argument is not supported in Singular yet: ", pos_list, "\n" );
                       list := pos_list;
                   fi;
                   
                   return StringToDoubleIntList( homalgSendBlocking( [ "GetRowIndependentUnitPositions_Z(", M, ", list (", list, "))" ], "need_output", HOMALG_IO.Pictograms.GetRowIndependentUnitPositions ) );
                   
                 end,
               
               XGetUnitPosition :=
                 function( M, pos_list )
                   local list, list_string;
                   
                   if pos_list = [ ] then
                       list := [ 0 ];
                   else
                       list := pos_list;
                   fi;
                   
                   list_string := homalgSendBlocking( [ "GetUnitPosition(", M, ", list (", list, "))" ], "need_output", HOMALG_IO.Pictograms.GetUnitPosition );
                   
                   if list_string = "fail" then
                       return fail;
                   else
                       return StringToIntList( list_string );
                   fi;
                   
                 end,
               
               XGetUnitPosition_Z :=
                 function( M, pos_list )
                   local list, list_string;
                   
                   if pos_list = [ ] then
                       list := [ 0 ];
                   else
                       list := pos_list;
                   fi;
                   
                   list_string := homalgSendBlocking( [ "GetUnitPosition_Z(", M, ", list (", list, "))" ], "need_output", HOMALG_IO.Pictograms.GetUnitPosition );
                   
                   if list_string = "fail" then
                       return fail;
                   else
                       return StringToIntList( list_string );
                   fi;
                   
                 end,
               
               XPositionOfFirstNonZeroEntryPerRow :=
                 function( M )
                   local L;
                   
                   L := homalgSendBlocking( [ "PositionOfFirstNonZeroEntryPerRow( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.PositionOfFirstNonZeroEntryPerRow );
                   
                   L := StringToIntList( L );
                   
                   if Length( L ) = 1 then
                       return ListWithIdenticalEntries( NrRows( M ), L[1] );
                   fi;
                   
                   return L;
                   
                 end,
               
               XPositionOfFirstNonZeroEntryPerColumn :=
                 function( M )
                   local L;
                   
                   L := homalgSendBlocking( [ "PositionOfFirstNonZeroEntryPerColumn( ", M, " )" ], "need_output", HOMALG_IO.Pictograms.PositionOfFirstNonZeroEntryPerColumn );
                   
                   L := StringToIntList( L );
                   
                   if Length( L ) = 1 then
                       return ListWithIdenticalEntries( NrColumns( M ), L[1] );
                   fi;
                   
                   return L;
                   
                 end,
               
               XDivideEntryByUnit :=
                 function( M, i, j, u )
                   
                   homalgSendBlocking( [ M, "[", j, i, "] =", M, "[", j, i, "]/", u ], "need_command", HOMALG_IO.Pictograms.DivideEntryByUnit );
                   
                 end,
               
               XDivideRowByUnit :=
                 function( M, i, u, j )
                   local v;
                   
                   v := homalgStream( HomalgRing( M ) )!.variable_name;
                   
                   homalgSendBlocking( [ v, "i=", i, ";", v, "j=", j, ";for(", v, "k=1;", v, "k<=", NrColumns( M ), ";", v, "k=", v, "k+1){", M, "[", v, "k,", v, "i]=", M, "[", v, "k,", v, "i]/", u, ";};if(", v, "j>0){", M, "[", v, "j,", v, "i]=1;}" ], "need_command", HOMALG_IO.Pictograms.DivideRowByUnit );
                   
                 end,
               
               XDivideColumnByUnit :=
                 function( M, j, u, i )
                   local v;
                   
                   v := homalgStream( HomalgRing( M ) )!.variable_name;
                   
                   homalgSendBlocking( [ v, "j=", j, ";", v, "i=", i, ";for(", v, "k=1;", v, "k<=", NrRows( M ), ";", v, "k=", v, "k+1){", M, "[", v, "j,", v, "k]=", M, "[", v, "j,", v, "k]/", u, ";};if(", v, "i>0){", M, "[", v, "j,", v, "i]=1;}" ], "need_command", HOMALG_IO.Pictograms.DivideColumnByUnit );
                   
                 end,
               
               XCopyRowToIdentityMatrix :=
                 function( M, i, L, j )
                   local v, l;
                   
                   v := homalgStream( HomalgRing( M ) )!.variable_name;
                   
                   l := Length( L );
                   
                   if l > 1 and ForAll( L, IsHomalgMatrix ) then
                       homalgSendBlocking( [ v, "i=", i, ";", v, "j=", j, ";for(", v, "k=1;", v, "k<=", NrColumns( M ), ";", v, "k=", v, "k+1){", L[1], "[", v, "k,", v, "j]=-", M, "[", v, "k,", v, "i];", L[2], "[", v, "k,", v, "j]=", M, "[", v, "k,", v, "i];", "};", L[1], "[", v, "j,", v, "j]=1;", L[2], "[", v, "j,", v, "j]=1" ], "need_command", HOMALG_IO.Pictograms.CopyRowToIdentityMatrix );
                   elif l > 0 and IsHomalgMatrix( L[1] ) then
                       homalgSendBlocking( [ v, "i=", i, ";", v, "j=", j, ";for(", v, "k=1;", v, "k<=", NrColumns( M ), ";", v, "k=", v, "k+1){", L[1], "[", v, "k,", v, "j]=-", M, "[", v, "k,", v, "i];};", L[1], "[", v, "j,", v, "j]=1;" ], "need_command", HOMALG_IO.Pictograms.CopyRowToIdentityMatrix );
                   elif l > 1 and IsHomalgMatrix( L[2] ) then
                       homalgSendBlocking( [ v, "i=", i, ";", v, "j=", j, ";for(", v, "k=1;", v, "k<=", NrColumns( M ), ";", v, "k=", v, "k+1){", L[2], "[", v, "k,", v, "j]=", M, "[", v, "k,", v, "i];", "};", L[2], "[", v, "j,", v, "j]=1" ], "need_command", HOMALG_IO.Pictograms.CopyRowToIdentityMatrix );
                   fi;
                   
                 end,
               
               XCopyColumnToIdentityMatrix :=
                 function( M, j, L, i )
                   local v, l;
                   
                   v := homalgStream( HomalgRing( M ) )!.variable_name;
                   
                   l := Length( L );
                   
                   if l > 1 and ForAll( L, IsHomalgMatrix ) then
                       homalgSendBlocking( [ v, "j=", j, ";", v, "i=", i, ";for(", v, "k=1;", v, "k<=", NrRows( M ), ";", v, "k=", v, "k+1){", L[1], "[", v, "i,", v, "k]=-", M, "[", v, "j,", v, "k];", L[2], "[", v, "i,", v, "k]=", M, "[", v, "j,", v, "k];", "};", L[1], "[", v, "i,", v, "i]=1;", L[2], "[", v, "i,", v, "i]=1" ], "need_command", HOMALG_IO.Pictograms.CopyColumnToIdentityMatrix );
                   elif l > 0 and IsHomalgMatrix( L[1] ) then
                       homalgSendBlocking( [ v, "j=", j, ";", v, "i=", i, ";for(", v, "k=1;", v, "k<=", NrRows( M ), ";", v, "k=", v, "k+1){", L[1], "[", v, "i,", v, "k]=-", M, "[", v, "j,", v, "k];", L[1], "[", v, "i,", v, "i]=1;" ], "need_command", HOMALG_IO.Pictograms.CopyColumnToIdentityMatrix );
                   elif l > 1 and IsHomalgMatrix( L[2] ) then
                       homalgSendBlocking( [ v, "j=", j, ";", v, "i=", i, ";for(", v, "k=1;", v, "k<=", NrRows( M ), ";", v, "k=", v, "k+1){", L[2], "[", v, "i,", v, "k]=", M, "[", v, "j,", v, "k];", "};", L[2], "[", v, "i,", v, "i]=1" ], "need_command", HOMALG_IO.Pictograms.CopyColumnToIdentityMatrix );
                   fi;
                   
                 end,
               
               XSetColumnToZero :=
                 function( M, i, j )
                   local v;
                   
                   v := homalgStream( HomalgRing( M ) )!.variable_name;
                   
                   homalgSendBlocking( [ v, "i=", i, ";", v, "j=", j, ";for(", v, "k=1;", v, "k<", v, "i;", v, "k=", v, "k+1){", M, "[", v, "j,", v, "k]=0;};for(", v, "k=", v, "i+1;", v, "k<=", NrRows( M ), ";", v, "k=", v, "k+1){", M, "[", v, "j,", v, "k]=0;}" ], "need_command", HOMALG_IO.Pictograms.SetColumnToZero );
                   
                 end,
               
               XGetCleanRowsPositions :=
                 function( M, clean_columns )
                   local list_string;
                   
                   list_string := homalgSendBlocking( [ "GetCleanRowsPositions(", M, ", list (", clean_columns, "))" ], "need_output", HOMALG_IO.Pictograms.GetCleanRowsPositions );
                   
                   return StringToIntList( list_string );
                   
                 end,
               
               ## determined by CoefficientsOfUnreducedNumeratorOfHilbertPoincareSeries
               XAffineDimension :=
                 function( mat )
                   
                   if ZeroColumns( mat ) <> [ ] and
                      ## the only case of a free direct summand we are allowed to send to Singular (<= 3-1-3)
                      not ( IsZero( mat ) and NrRows( mat ) = 1 and NrColumns( mat ) = 1 ) then
                       Error( "Singular (<= 3-1-3) does not handle nontrivial free direct summands correctly\n" );
                   fi;
                   
                   return Int( homalgSendBlocking( [ "dim(std(", mat, "))" ], "need_output", HOMALG_IO.Pictograms.AffineDimension ) );
                   
                 end,
               
               XCoefficientsOfUnreducedNumeratorOfHilbertPoincareSeries :=
                 function( mat )
                   local hilb;
                   
                   if ZeroColumns( mat ) <> [ ] and
                      ## the only case of a free direct summand we allowed to send to Singular (<= 3-1-3)
                      not ( IsZero( mat ) and NrRows( mat ) = 1 and NrColumns( mat ) = 1 ) then
                       Error( "Singular (<= 3-1-3) does not handle nontrivial free direct summands correctly\n" );
                   fi;
                   
                   hilb := homalgSendBlocking( [ "hilb(std(", mat, "),1)" ], "need_output", HOMALG_IO.Pictograms.HilbertPoincareSeries );
                   
                   hilb := StringToIntList( hilb );
                   
                   if hilb = [ 0, 0 ] then
                       return [ ];
                   fi;
                   
                   return hilb{[ 1 .. Length( hilb ) - 1 ]};
                   
                 end,
               
               ### commented out since Singular (<= 3-1-3) does not handle nontrivial free direct summands correctly;
               ## determined by CoefficientsOfUnreducedNumeratorOfHilbertPoincareSeries
               #XCoefficientsOfNumeratorOfHilbertPoincareSeries :=
               #  function( mat )
               #    local hilb;
               #    
               #    if ZeroColumns( mat ) <> [ ] and
               #       ## the only case of a free direct summand we can to send to Singular (<= 3-1-3)
               #       not ( IsZero( mat ) and NrRows( mat ) = 1 and NrColumns( mat ) = 1 ) then
               #        Error( "Singular (<= 3-1-3) does not handle nontrivial free direct summands correctly\n" );
               #    fi;
               #    
               #    hilb := homalgSendBlocking( [ "hilb(std(", mat, "),2)" ], "need_output", HOMALG_IO.Pictograms.HilbertPoincareSeries );
               #    
               #    hilb := StringToIntList( hilb );
               #    
               #    if hilb = [ 0, 0 ] then
               #        return [ ];
               #    fi;
               #    
               #    return hilb{[ 1 .. Length( hilb ) - 1 ]};
               #    
               #  end,
               
               XCoefficientsOfUnreducedNumeratorOfWeightedHilbertPoincareSeries :=
                 function( mat, weights, degrees )
                   local R, v, hilb;
                   
                   R := HomalgRing( mat );
                   
                   v := homalgStream( R )!.variable_name;
                   
                   if ZeroColumns( mat ) <> [ ] and
                      ## the only case of a free direct summand we allowed to send to Singular (<= 3-1-3)
                      not ( IsZero( mat ) and NrRows( mat ) = 1 and NrColumns( mat ) = 1 ) then
                       Error( "Singular (<= 3-1-3) does not handle nontrivial free direct summands correctly\n" );
                   fi;
                   
                   hilb := homalgSendBlocking( [ "CoefficientsOfUnreducedNumeratorOfWeightedHilbertPoincareSeries(", mat, ", intvec(", weights,"), intvec(", degrees, "))" ], "need_output", HOMALG_IO.Pictograms.HilbertPoincareSeries );
                   
                   hilb := StringToIntList( hilb );
                   
                   if hilb = [ 0, 0 ] then
                       return [ 0 ];
                   fi;
                   
                   return hilb;
                   
                 end,
               
               XPrimaryDecomposition :=
                 function( mat )
                   local R, v, c, primary_decomposition;
                   
                   R := HomalgRing( mat );
                   
                   v := homalgStream( R )!.variable_name;
                   
                   homalgSendBlocking( [ "list ", v, "l=PrimaryDecomposition(", mat, ")" ], "need_command", HOMALG_IO.Pictograms.PrimaryDecomposition );
                   
                   c := Int( homalgSendBlocking( [ "size(", v, "l)" ], "need_output", R, HOMALG_IO.Pictograms.PrimaryDecomposition ) );
                   
                   primary_decomposition :=
                     List( [ 1 .. c ],
                           function( i )
                             local primary, prime;
                             
                             primary := HomalgVoidMatrix( "unkown_number_of_rows", 1, R );
                             prime := HomalgVoidMatrix( "unkown_number_of_rows", 1, R );
                             
                             homalgSendBlocking( [ "matrix ", primary, "[1][size(", v, "l[", i, "][1])]=", v, "l[", i, "][1]" ], "need_command", HOMALG_IO.Pictograms.PrimaryDecomposition );
                             homalgSendBlocking( [ "matrix ", prime, "[1][size(", v, "l[", i, "][2])]=", v, "l[", i, "][2]" ], "need_command", HOMALG_IO.Pictograms.PrimaryDecomposition );
                             
                             return [ primary, prime ];
                             
                           end
                         );
                   
                   return primary_decomposition;
                   
                 end,
               
               XEliminate :=
                 function( rel, indets, R )
                   local elim;
                   
                   elim := Product( indets );
                   
                   return homalgSendBlocking( [ "matrix(eliminate(ideal(", rel, "),", elim, "))" ], [ "matrix" ], R, HOMALG_IO.Pictograms.Eliminate );
                   
                 end,
               
               XCoefficients :=
                 function( poly, var )
                   local R, v, vars, coeffs;
                   
                   R := HomalgRing( poly );
                   
                   v := homalgStream( R )!.variable_name;
                   
                   homalgSendBlocking( [ "matrix ", v, "m = coef(", poly, var, ")" ], "need_command", HOMALG_IO.Pictograms.Coefficients );
                   vars :=homalgSendBlocking( [ "submat(", v, "m,1..1,1..ncols(", v, "m))" ], [ "matrix" ], R, HOMALG_IO.Pictograms.Coefficients );
                   coeffs := homalgSendBlocking( [ "submat(", v, "m,2..2,1..ncols(", v, "m))" ], [ "matrix" ], R, HOMALG_IO.Pictograms.Coefficients );
                   
                   return [ vars, coeffs ];
                   
                 end,
               
               XIndicatorMatrixOfNonZeroEntries :=
                 function( mat )
                   local l;
                   
                   l := StringToIntList( homalgSendBlocking( [ "IndicatorMatrixOfNonZeroEntries(", mat, ")" ], "need_output", HOMALG_IO.Pictograms.IndicatorMatrixOfNonZeroEntries ) );
                   
                   return ListToListList( l, NrRows( mat ), NrColumns( mat ) );
                   
                 end,
               
               XDegreeOfRingElement :=
                 function( r, R )
                   
                   return Int( homalgSendBlocking( [ "deg( ", r, " )" ], "need_output", HOMALG_IO.Pictograms.DegreeOfRingElement ) );
                   
                 end,
               
               XCoefficientsOfUnivariatePolynomial :=
                 function( r, var )
                   
                   return homalgSendBlocking( [ "coeffs( ", r, var, " )" ], [ "matrix" ], HOMALG_IO.Pictograms.Coefficients );
                   
                 end,
               
               XLeadingModule :=
                 function( mat )
                   
                   return homalgSendBlocking( [ "matrix(lead(module(", mat, ")))" ], [ "matrix" ], HOMALG_IO.Pictograms.LeadingModule );
                   
                 end,
               
               XMatrixOfSymbols :=
                 function( mat )
                   
                   return homalgSendBlocking( [ "MatrixOfSymbols(", mat, ")" ], [ "matrix" ], HOMALG_IO.Pictograms.MatrixOfSymbols );
                   
                 end,
               
               XMatrixOfSymbols_workaround :=
                 function( mat )
                   
                   return homalgSendBlocking( [ "MatrixOfSymbols_workaround(", mat, ")" ], [ "matrix" ], HOMALG_IO.Pictograms.MatrixOfSymbols );
                   
                 end,
               
               XPullback :=
                 function( phi, M )
                   
                   if not IsBound( phi!.RingMap ) then
                       phi!.RingMap :=
                         homalgSendBlocking( [ Source( phi ), ImagesOfRingMap( phi ) ], [ "map" ], Range( phi ), HOMALG_IO.Pictograms.define );
                   fi;
                   
                   return homalgSendBlocking( [ phi!.RingMap, "(", M, ")" ], [ "matrix" ], Range( phi ), HOMALG_IO.Pictograms.Pullback );
                   
                 end,
               
               XRandomPol :=
                 function( arg )
                   local R;
                   
                   R := arg[1];
                   
                   return homalgSendBlocking( [ "sparsepoly(", arg{[ 2 .. Length( arg ) ]}, ")" ], [ "def" ], R, HOMALG_IO.Pictograms.RandomPol );
                   
                 end,
               
               XIsIrreducible :=
                 function( r )
                   
                   if Length( Indeterminates( HomalgRing( r ) ) ) > 2 then
                       Error( "is_irred in Singular assumes a bivariate polynomial\n" );
                   fi;
                   
                   return Int( homalgSendBlocking( [ "is_irred(", r, ")" ], "need_output", HOMALG_IO.Pictograms.IsIrreducible ) ) = 1;
                   
                 end,
               
        )
 );
