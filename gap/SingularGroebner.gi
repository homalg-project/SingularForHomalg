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
        [ IsSI_ring ],
        
  function( singular_ring )
    local RP;
    
    RP := rec(
              
              );
    
    ## RP_General
    AppendToAhomalgTable( RP, CommonHomalgTableForRings );
    
    ## RP_Tools
    AppendToAhomalgTable( RP, CommonHomalgTableForSingularInterfaceTools );
    
    ## RP_Basic
    AppendToAhomalgTable( RP, CommonHomalgTableForSingularInterfaceBasic );
    
    #todo: insert again, as soon as Singular really computes smith forms
    #if HasPrincipalIdealRing( singular_ring ) and IsPrincipalIdealRing( singular_ring ) then
    #    AppendToAhomalgTable( RP, CommonHomalgTableForSingularInterfaceBestBasis );
    #fi;
    
    Objectify( TheTypeHomalgTable, RP );
    
    return RP;
    
end );
