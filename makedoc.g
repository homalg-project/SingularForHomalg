LoadPackage( "AutoDoc" );

AutoDoc( "SingularForHomalg" :
        
        scaffold := rec( entities := [ "homalg", "GAP4" ],
                         ),
        
        autodoc := rec( files := [  ] ),
        
        maketest := rec( folder := ".",
                         commands :=
                         [ "LoadPackage( \"SingularForHomalg\" );",
                           "LoadPackage( \"IO_ForHomalg\" );",
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
