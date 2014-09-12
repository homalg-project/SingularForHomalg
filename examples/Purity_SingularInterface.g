#! @System Purity_SingularInterface

LoadPackage( "SingularForHomalg" );

#!  This examples tests &Singular;'s interpreter procedures
#!  which have been automatically wrapped by &SingularInterface;.
#!  This is Example B.3 in <Cite Key="BaSF"/>.

#! @Example
R := HomalgFieldOfRationalsInSingularInterface( ) * "x,y,z";
#! Q[x,y,z]
wmat := HomalgMatrix( "[ \
xy,  yz,    z,        0,         0,    \
x3z,x2z2,0,        xz2,     -z2, \
x4,  x3z,  0,        x2z,     -xz, \
0,    0,      xy,      -y2,      x2-1,\
0,    0,      x2z,    -xyz,    yz,  \
0,    0,      x2y-x2,-xy2+xy,y2-y \
]", 6, 5, R );
#! <A 6 x 5 matrix over an internal ring>
LoadPackage( "Modules" );
#! true
W := LeftPresentation( wmat );
#! <A left module presented by 6 relations for 5 generators>
filt := PurityFiltration( W );
#! <The ascending purity filtration with degrees [ -3 .. 0 ] and graded parts:
#!  0:  <A codegree-[ 1, 1 ]-pure rank 2 left module presented by 3 relations for 4\
#!       generators>
#! -1:  <A codegree-1-pure grade 1 left module presented by 4 relations for 3 gener\
#!       ators>
#! -2:  <A cyclic reflexively pure grade 2 left module presented by 2 relations for\
#!       a cyclic generator>
#! -3:  <A cyclic reflexively pure grade 3 left module presented by 3 relations for\
#!       a cyclic generator>
#! of
#! <A non-pure rank 2 left module presented by 6 relations for 5 generators>>
W;
#! <A non-pure rank 2 left module presented by 6 relations for 5 generators>
II_E := SpectralSequence( filt );
#! <A stable homological spectral sequence with sheets at levels
#! [ 0 .. 4 ] each consisting of left modules at bidegrees [ -3 .. 0 ]x
#! [ 0 .. 3 ]>
Display( II_E );
#! The associated transposed spectral sequence:
#! 
#! a homological spectral sequence at bidegrees
#! [ [ 0 .. 3 ], [ -3 .. 0 ] ]
#! ---------
#! Level 0:
#! 
#!  * * * *
#!  * * * *
#!  . * * *
#!  . . * *
#! ---------
#! Level 1:
#! 
#!  * * * *
#!  . . . .
#!  . . . .
#!  . . . .
#! ---------
#! Level 2:
#! 
#!  s . . .
#!  . . . .
#!  . . . .
#!  . . . .
#! 
#! Now the spectral sequence of the bicomplex:
#! 
#! a homological spectral sequence at bidegrees
#! [ [ -3 .. 0 ], [ 0 .. 3 ] ]
#! ---------
#! Level 0:
#! 
#!  * * * *
#!  * * * *
#!  . * * *
#!  . . * *
#! ---------
#! Level 1:
#! 
#!  * * * *
#!  * * * *
#!  . * * *
#!  . . . *
#! ---------
#! Level 2:
#! 
#!  s . . .
#!  * s . .
#!  . * * .
#!  . . . *
#! ---------
#! Level 3:
#! 
#!  s . . .
#!  * s . .
#!  . . s .
#!  . . . *
#! ---------
#! Level 4:
#! 
#!  s . . .
#!  . s . .
#!  . . s .
#!  . . . s
#! 
m := IsomorphismOfFiltration( filt );
#! <A non-zero isomorphism of left modules>
IsIdenticalObj( Range( m ), W );
#! true
Source( m );
#! <A left module presented by 12 relations for 9 generators (locked)>
Display( Source( m ) );
#! 0,  0,x, -y,0,1, 0,    0,  0,
#! x*y,0,-z,0, 0,0, 0,    0,  0,
#! x^2,0,0, -z,1,0, 0,    0,  0,
#! 0,  0,0, 0, y,-z,0,    0,  0,
#! 0,  0,0, 0, 0,x, -y,   -1, 0,
#! 0,  0,0, 0, x,0, -z,   0,  -1,
#! 0,  0,0, 0, 0,-y,x^2-1,0,  0,
#! 0,  0,0, 0, 0,0, 0,    z,  0,
#! 0,  0,0, 0, 0,0, 0,    y-1,0,
#! 0,  0,0, 0, 0,0, 0,    0,  z,
#! 0,  0,0, 0, 0,0, 0,    0,  y,
#! 0,  0,0, 0, 0,0, 0,    0,  x
#! 
#! Cokernel of the map
#! 
#! Q[x,y,z]^(1x12) --> Q[x,y,z]^(1x9),
#! 
#! currently represented by the above matrix
Display( filt );
#! Degree 0:
#! 
#! 0,  0,x, -y,
#! x*y,0,-z,0,
#! x^2,0,0, -z
#! 
#! Cokernel of the map
#! 
#! Q[x,y,z]^(1x3) --> Q[x,y,z]^(1x4),
#! 
#! currently represented by the above matrix
#! ----------
#! Degree -1:
#! 
#! y,-z,0,
#! 0,x, -y,
#! x,0, -z,
#! 0,-y,x^2-1
#! 
#! Cokernel of the map
#! 
#! Q[x,y,z]^(1x4) --> Q[x,y,z]^(1x3),
#! 
#! currently represented by the above matrix
#! ----------
#! Degree -2:
#! 
#! Q[x,y,z]/< z, y-1 >
#! ----------
#! Degree -3:
#! 
#! Q[x,y,z]/< z, y, x >
Display( m );
#! 1,   0,     0,  0,   0,
#! 0,   1,     0,  0,   0,
#! 0,   -y,    -1, 0,   0,
#! 0,   -x,    0,  -1,  0,
#! -x^2,-x*z,  0,  -z,  0,
#! 0,   0,     x,  -y,  0,
#! 0,   0,     0,  0,   -1,
#! 0,   0,     x^2,-x*y,y,
#! -x^3,-x^2*z,0,  -x*z,z
#! 
#! the map is currently represented by the above 9 x 5 matrix
#! @EndExample
#Display( StringTime( homalgTime( R ) ) );
