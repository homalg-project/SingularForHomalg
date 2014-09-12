SetPackageInfo( rec(

PackageName := "SingularForHomalg",

Subtitle := "An interface between Singular and homalg using SingularInterface",

Version := Maximum( [
                   "2014.09.10", ## Mohamed's version
                   ## this line prevents merge conflicts
                   ] ),

# this avoids git-merge conflicts
Date := ~.Version{[ 1 .. 10 ]},
Date := Concatenation( ~.Date{[ 9, 10 ]}, "/", ~.Date{[ 6, 7 ]}, "/", ~.Date{[ 1 .. 4 ]} ),

ArchiveURL := Concatenation( "http://homalg.math.rwth-aachen.de/~barakat/homalg-project/SingularForHomalg-", ~.Version ),

ArchiveFormats := ".tar.gz",

Persons := [
  rec( 
    LastName      := "Barakat",
    FirstNames    := "Mohamed",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "mohamed.barakat@rwth-aachen.de",
    WWWHome       := "http://www.mathematik.uni-kl.de/~barakat/",
    PostalAddress := Concatenation( [
                       "Lehrstuhl B fuer Mathematik, RWTH Aachen\n",
                       "Templergraben 64\n",
                       "52062 Aachen\n",
                       "Germany" ] ),
    Place         := "Aachen",
    Institution   := "RWTH Aachen University"
  ),
],

Status := "dev",

README_URL := 
  "http://homalg.math.rwth-aachen.de/~barakat/homalg-project/SingularForHomalg/README.SingularForHomalg",
PackageInfoURL := 
  "http://homalg.math.rwth-aachen.de/~barakat/homalg-project/SingularForHomalg/PackageInfo.g",

PackageDoc := rec(
  BookName  := "SingularForHomalg",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "An interface between Singular and homalg using SingularInterface",
  Autoload  := false
),

Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [
                   [ "AutoDoc", ">= 2013.12.30" ],
                   [ "MatricesForHomalg", ">= 2013.01.09" ],
                   [ "RingsForHomalg", ">= 2013.02.23" ],
                   [ "HomalgToCAS", ">= 2013.01.09" ],
                   [ "SingularInterface", ">= 2014.09.12" ],
                   [ "GAPDoc", ">= 1.0" ]
                   ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ]
),

AvailabilityTest := function( )
    return true;
  end,

Autoload := false,

Keywords := [ "Singular", "libSingular", "SingularInterface", "interface" ]

));
