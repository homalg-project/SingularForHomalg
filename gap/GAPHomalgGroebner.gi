#############################################################################
##
##  GAPHomalgGroebner.gi                           SingularForHomalg package
##
##  Copyright 2013, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations for the external computer algebra system GAP
##  with SingularInterface.
##
#############################################################################

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
        "for homalg rings with Groebner basis computations provided by an external GAP equipped with SingularInterface",
        [ IsHomalgExternalSingularInterfaceRingObjectRep ],
        
  function( singular_ring )
    local RP;
    
    RP := rec(
              
              );
    
    ## RP_General
    AppendToAhomalgTable( RP, CommonHomalgTableForRings );
    
    ## RP_Tools
    AppendToAhomalgTable( RP, CommonHomalgTableForExternalSingularInterfaceTools );
    
    ## RP_Basic
    AppendToAhomalgTable( RP, CommonHomalgTableForExternalSingularInterfaceBasic );
    
    #todo: insert again, as soon as Singular really computes smith forms
    #if HasPrincipalIdealRing( singular_ring ) and IsPrincipalIdealRing( singular_ring ) then
    #    AppendToAhomalgTable( RP, CommonHomalgTableForExternalSingularInterfaceBestBasis );
    #fi;
    
    Objectify( TheTypeHomalgTable, RP );
    
    return RP;
    
end );
