LoadPackage( "SingularForHomalg" );

homalgIOMode( "D" );

SetAssertionLevel( 6 );

Q := HomalgFieldOfRationalsInExternalLibSingular( );

Qxyz := Q * "x,y,z";

wmat := HomalgMatrix( "[ \
xy,  yz,    z,        0,         0,    \
x3z,x2z2,0,        xz2,     -z2, \
x4,  x3z,  0,        x2z,     -xz, \
0,    0,      xy,      -y2,      x2-1,\
0,    0,      x2z,    -xyz,    yz,  \
0,    0,      x2y-x2,-xy2+xy,y2-y \
]", 6, 5, Qxyz );

LoadPackage( "Modules" );

W := LeftPresentation( wmat );

## the module is isomorphic to LeftPresentation of the multiple extension:
## x,z,1,0, 0, 0,0, 0,    0,  0, 
## 0,0,y,-z,0, 0,0, 0,    0,  0, 
## 0,0,x,0, -z,1,0, 0,    0,  0, 
## 0,0,0,x, -y,0,1, 0,    0,  0, 
## 0,0,0,0, 0, y,-z,0,    0,  0, 
## 0,0,0,0, 0, x,0, -z,   0,  -1,
## 0,0,0,0, 0, 0,x, -y,   -1, 0, 
## 0,0,0,0, 0, 0,-y,x^2-1,0,  0, 
## 0,0,0,0, 0, 0,0, 0,    z,  0, 
## 0,0,0,0, 0, 0,0, 0,    y-1,0, 
## 0,0,0,0, 0, 0,0, 0,    0,  z, 
## 0,0,0,0, 0, 0,0, 0,    0,  y, 
## 0,0,0,0, 0, 0,0, 0,    0,  x

BasisOfModule( W );
syz := SyzygiesGenerators( W );
Y := Hom( Qxyz, W );
iota := TorsionObjectEmb( W );
pi := TorsionFreeFactorEpi( W );
C := HomalgComplex( pi, 0 );
Add( C, iota );
T := TorsionObject( W );
F := TorsionFreeFactor( W );
O := HomalgCocomplex( iota, -1 );
Add( O, pi );

SetAsOriginalPresentation( W );

wmor := HomalgMatrix( "[ \
x2+y-z,xz-z,  0,        z,         -z,   \
x-1,    x+y-1,  -y,       -1,        0,    \
x3+y,  x2z+y,x2+y2+y,-xy+xz+y,xy-z,\
x,      x,      x,        y2+x,     1,    \
0,      0,      -xy,     y2,       1     \
]", 5, 5, Qxyz );

phi := HomalgMap( wmor, W, W );
