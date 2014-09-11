LoadPackage( "AutoDoc" );

AutoDoc( "SingularForHomalg" :
        
        scaffold := rec( entities := [
                            "homalg",
                            "GAP4",
                            "Singular",
                            "SingularInterface",
                            "IO",
                            "IO_ForHomalg",
                            ],
                         ),
        
        autodoc := rec( files := [ "doc/Intros.autodoc" ] ),
        
        maketest := rec( folder := ".",
                         commands :=
                         [ "LoadPackage( \"SingularForHomalg\" );",
                           "LoadPackage( \"IO_ForHomalg\" );",
                           "LoadPackage( \"Modules\" );",
                           "HOMALG_IO.show_banners := false;",
                           "HOMALG_IO.suppress_PID := true;",
                           "HOMALG_IO.use_common_stream := true;",
                           ],
                         ),
        
        Bibliography := "SingularForHomalg.bib"
        
);

# Create VERSION file for "make towww"
PrintTo( "VERSION", PackageInfo( "SingularForHomalg" )[1].Version );

QUIT;
