#############################################################################
##
##  SingularGroebner.gi                            SingularForHomalg package
##
##  Copyright 2012, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations for internal rings provided by Singular.
##
#############################################################################

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
        "for homalg rings with Groebner basis computations provided by Singular",
        [ IsSingularRing ],
        
  function( singular_ring )
    local RP;
    
    RP := rec(
              Zero := SI_poly( singular_ring, "0" ),
              
              One := SI_poly( singular_ring, "1" ),
              
              MinusOne := SI_poly( singular_ring, "-1" ),
              );
    
    ## RP_General
    AppendToAhomalgTable( RP, CommonHomalgTableForRings );
    
    ## RP_Tools
    AppendToAhomalgTable( RP, CommonHomalgTableForLibSingularTools );
    
    ## RP_Basic
    AppendToAhomalgTable( RP, CommonHomalgTableForLibSingularBasic );
    
    #todo: insert again, as soon as Singular really computes smith forms
    #if HasPrincipalIdealRing( singular_ring ) and IsPrincipalIdealRing( singular_ring ) then
    #    AppendToAhomalgTable( RP, CommonHomalgTableForLibSingularBestBasis );
    #fi;
    
    Objectify( TheTypeHomalgTable, RP );
    
    return RP;
    
end );
