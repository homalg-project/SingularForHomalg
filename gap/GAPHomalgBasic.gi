#############################################################################
##
##  GAPHomalgBasic.gi                              SingularForHomalg package
##
##  Copyright 2013, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations for the external computer algebra system GAP with LibSing.
##
#############################################################################

####################################
#
# global variables:
#
####################################

InstallValue( CommonHomalgTableForExternalLibSingBasic,
        
        rec(
               ## Must only then be provided by the RingPackage in case the default
               ## "service" function does not match the Ring

##  <#GAPDoc Label="BasisOfRowModule:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M" Name="BasisOfRowModule" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="BasisOfRowModule" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
BasisOfRowModule :=
  function( M )
    local N;
    
    N := HomalgVoidMatrix(
      "unknown_number_of_rows",
      NrColumns( M ),
      HomalgRing( M )
    );
    
    homalgSendBlocking(
            [ N, " := SIH_BasisOfColumnModule(", M, ")" ],
            "need_command",
            HOMALG_IO.Pictograms.BasisOfModule
            );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="BasisOfColumnModule:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M" Name="BasisOfColumnModule" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="BasisOfColumnModule" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
BasisOfColumnModule :=
  function( M )
    local N;
    
    N := HomalgVoidMatrix(
      NrRows( M ),
      "unknown_number_of_columns",
      HomalgRing( M )
    );
    
    homalgSendBlocking(
            [ N, " := SIH_BasisOfRowModule(", M, ")" ],
            "need_command",
            HOMALG_IO.Pictograms.BasisOfModule
            );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="BasisOfRowsCoeff:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M, T" Name="BasisOfRowsCoeff" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="BasisOfRowsCoeff" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
BasisOfRowsCoeff :=
  function( M, T )
    local v, N;
    
    v := homalgStream( HomalgRing( M ) )!.variable_name;
    
    N := HomalgVoidMatrix(
      "unknown_number_of_rows",
      NrColumns( M ),
      HomalgRing( M )
    );
    
    homalgSendBlocking(
      [
        v, "l := SIH_BasisOfColumnsCoeff(", M, "); ",
        N, " := ", v, "l[1]; ",
        T, " := ", v, "l[2]"
      ],
      "need_command",
      HOMALG_IO.Pictograms.BasisCoeff
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="BasisOfColumnsCoeff:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M, T" Name="BasisOfColumnsCoeff" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="BasisOfColumnsCoeff" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
BasisOfColumnsCoeff :=
  function( M, T )
    local v, N;
    
    v := homalgStream( HomalgRing( M ) )!.variable_name;
    
    N := HomalgVoidMatrix(
      NrRows( M ),
      "unknown_number_of_columns",
      HomalgRing( M )
    );
    
    homalgSendBlocking(
      [
        v, "l := SIH_BasisOfRowsCoeff(", M, "); ",
        N, " := ", v, "l[1]; ",
        T, " := ", v, "l[2]"
      ],
      "need_command",
      HOMALG_IO.Pictograms.BasisCoeff
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="DecideZeroRows:ExternalLibSing">
##  <ManSection>
##    <Func Arg="A, B" Name="DecideZeroRows" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="DecideZeroRows" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
DecideZeroRows :=
  function( A, B )
    local N;
    
    N := HomalgVoidMatrix(
      NrRows( A ),
      NrColumns( A ),
      HomalgRing( A )
    );
    
    homalgSendBlocking(
      [ N, " := SIH_DecideZeroColumns( ", A, B, " )" ],
      "need_command",
      HOMALG_IO.Pictograms.DecideZero
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="DecideZeroColumns:ExternalLibSing">
##  <ManSection>
##    <Func Arg="A, B" Name="DecideZeroColumns" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="DecideZeroColumns" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
DecideZeroColumns :=
  function( A, B )
    local N;
    
    N := HomalgVoidMatrix(
      NrRows( A ),
      NrColumns( A ),
      HomalgRing( A )
    );
    
    homalgSendBlocking(
      [ N, " := SIH_DecideZeroRows( ", A, B, " )" ],
      "need_command",
      HOMALG_IO.Pictograms.DecideZero
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="DecideZeroRowsEffectively:ExternalLibSing">
##  <ManSection>
##    <Func Arg="A, B, T" Name="DecideZeroRowsEffectively" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="DecideZeroRowsEffectively" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
DecideZeroRowsEffectively :=
  function( A, B, T )
    local v, N;
    
    v := homalgStream( HomalgRing( A ) )!.variable_name;
    
    N := HomalgVoidMatrix(
      NrRows( A ),
      NrColumns( A ),
      HomalgRing( A )
    );
    
    homalgSendBlocking(
      [
        v, "l := SIH_DecideZeroColumnsEffectively(", A, B, "); ",
        N, " := ", v, "l[1]; ",
        T, " := ", v, "l[2]"
      ],
      "need_command",
      HOMALG_IO.Pictograms.DecideZeroEffectively
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="DecideZeroColumnsEffectively:ExternalLibSing">
##  <ManSection>
##    <Func Arg="A, B, T" Name="DecideZeroColumnsEffectively" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="DecideZeroColumnsEffectively" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
DecideZeroColumnsEffectively :=
  function( A, B, T )
    local v, N;
    
    v := homalgStream( HomalgRing( A ) )!.variable_name;
    
    N := HomalgVoidMatrix(
      NrRows( A ),
      NrColumns( A ),
      HomalgRing( A )
    );
    
    homalgSendBlocking(
      [
        v, "l := SIH_DecideZeroRowsEffectively(", A, B, "); ",
        N, " := ", v, "l[1]; ",
        T, " := ", v, "l[2]"
      ],
      "need_command",
      HOMALG_IO.Pictograms.DecideZeroEffectively
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="SyzygiesGeneratorsOfRows:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M" Name="SyzygiesGeneratorsOfRows" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="SyzygiesGeneratorsOfRows" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
SyzygiesGeneratorsOfRows :=
  function( M )
    local N;
    
    N := HomalgVoidMatrix(
      "unknown_number_of_rows",
      NrRows( M ),
      HomalgRing( M )
    );
    
    homalgSendBlocking(
      [ N, " := SIH_SyzygiesGeneratorsOfColumns(", M, ")" ],
      "need_command",
      HOMALG_IO.Pictograms.SyzygiesGenerators
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="SyzygiesGeneratorsOfColumns:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M" Name="SyzygiesGeneratorsOfColumns" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="SyzygiesGeneratorsOfColumns" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
SyzygiesGeneratorsOfColumns :=
  function( M )
    local N;
    
    N := HomalgVoidMatrix(
      NrColumns( M ),
      "unknown_number_of_columns",
      HomalgRing( M )
    );
    
    homalgSendBlocking(
      [ N, " := SIH_SyzygiesGeneratorsOfRows(", M, ")" ],
      "need_command",
      HOMALG_IO.Pictograms.SyzygiesGenerators
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="RelativeSyzygiesGeneratorsOfRows:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M, M2" Name="RelativeSyzygiesGeneratorsOfRows" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="RelativeSyzygiesGeneratorsOfRows" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
RelativeSyzygiesGeneratorsOfRows :=
  function( M, M2 )
    local N;
    
    N := HomalgVoidMatrix(
      "unknown_number_of_rows",
      NrRows( M ),
      HomalgRing( M )
    );
    
    homalgSendBlocking(
      [ N, " := SIH_RelativeSyzygiesGeneratorsOfColumns(", M, M2, ")" ],
      "need_command",
      HOMALG_IO.Pictograms.SyzygiesGenerators
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="RelativeSyzygiesGeneratorsOfColumns:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M, M2" Name="RelativeSyzygiesGeneratorsOfColumns" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="RelativeSyzygiesGeneratorsOfColumns" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
RelativeSyzygiesGeneratorsOfColumns :=
  function( M, M2 )
    local N;
    
    N := HomalgVoidMatrix(
      NrColumns( M ),
      "unknown_number_of_columns",
      HomalgRing( M )
    );
    
    homalgSendBlocking(
      [ N, " := SIH_RelativeSyzygiesGeneratorsOfRows(", M, M2, ")" ],
      "need_command",
      HOMALG_IO.Pictograms.SyzygiesGenerators
    );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="ReducedSyzygiesGeneratorsOfRows:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M" Name="ReducedSyzygiesGeneratorsOfRows" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="ReducedSyzygiesGeneratorsOfRows" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
XReducedSyzygiesGeneratorsOfRows :=
  function( M )
    local N;
    
    N := HomalgVoidMatrix(
      "unknown_number_of_rows",
      NrRows( M ),
      HomalgRing( M )
    );
    
    M := Eval( M )!.matrix;
    
    SetEval( N, homalgInternalMatrixHull( SIH_ReducedSyzygiesGeneratorsOfColumns( M ) ) );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="ReducedSyzygiesGeneratorsOfColumns:ExternalLibSing">
##  <ManSection>
##    <Func Arg="M" Name="ReducedSyzygiesGeneratorsOfColumns" Label="in the homalg table for LibSing"/>
##    <Returns></Returns>
##    <Description>
##      This is the entry of the &homalg; table, which calls the corresponding macro <Ref Func="ReducedSyzygiesGeneratorsOfColumns" Label="Singular macro"/> inside the computer algebra system.
##      <Listing Type="Code"><![CDATA[
XReducedSyzygiesGeneratorsOfColumns :=
  function( M )
    local N;
    
    N := HomalgVoidMatrix(
      NrColumns( M ),
      "unknown_number_of_columns",
      HomalgRing( M )
    );
    
    M := Eval( M )!.matrix;
    
    SetEval( N, homalgInternalMatrixHull( SIH_ReducedSyzygiesGeneratorsOfRows( M ) ) );
    
    return N;
    
  end,
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

        )
 );
