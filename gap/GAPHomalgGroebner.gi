#############################################################################
##
##  LibSingGroebner.gi                             SingularForHomalg package
##
##  Copyright 2013, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations for the external computer algebra system GAP with LibSing.
##
#############################################################################

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
        "for homalg rings with Groebner basis computations provided by an external GAP equipped with libsing",
        [ IsHomalgExternalLibSingRingObjectRep ],
        
  function( singular_ring )
    local RP;
    
    RP := rec(
              
              );
    
    ## RP_General
    AppendToAhomalgTable( RP, CommonHomalgTableForRings );
    
    ## RP_Tools
    AppendToAhomalgTable( RP, CommonHomalgTableForExternalLibSingTools );
    
    ## RP_Basic
    AppendToAhomalgTable( RP, CommonHomalgTableForExternalLibSingBasic );
    
    #todo: insert again, as soon as Singular really computes smith forms
    #if HasPrincipalIdealRing( singular_ring ) and IsPrincipalIdealRing( singular_ring ) then
    #    AppendToAhomalgTable( RP, CommonHomalgTableForExternalLibSingBestBasis );
    #fi;
    
    Objectify( TheTypeHomalgTable, RP );
    
    return RP;
    
end );
