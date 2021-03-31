      subroutine PEPNUT(t, dpsi, deps)
 
      implicit none
 
 
c*** start of declarations inserted by spag
      real      arg
      integer   i, j
 
c*** end of declarations inserted by spag
 
 
c
c     this subroutine evaluates the nutation series and returns the
c      values for nutation in longitude and nutation in obliquity for
c      j. m. wahr's nutation series for axis b for earth model 1066a.
c     written by g.kaplan of usno from wahr's thesis results.
c     modified 13 april 81 by r.king of mit to agree with the slightly
c      different values given in wahr's paper in geophys.j.r.astr.soc.
c     added to pep 1989 december by j.f.chandler.
c
c           arguments
c t    = tdb time in julian centuries since j2000.0 (in)
c dpsi = nutation in longitude in radians (out)
c deps = nutation in obliquity in radians (out)
c
      real*10 t
      real*4    dpsi, deps
c
c commons
      include 'funcon.inc'
 
      real*10 dpsi8, deps8, el, elp, f, d, omega, dblarg, elc(5), 
     .          elpc(5), fc(5), dc(5), omc(5)
      real*4    x(9, 106), x1(180), x2(180), x3(180), x4(180), x5(180),
     .          x6(54)
      equivalence(x(1,1), x1)
      equivalence(x(1,21), x2)
      equivalence(x(1,41), x3)
      equivalence(x(1,61), x4)
      equivalence(x(1,81), x5)
      equivalence(x(1,101), x6)

      data elc/  0.064_10, 31.31_10,  715922.633_10, 485866.733_10,
     . 1325._10/
      data elpc/-0.012_10, -0.577_10,1292581.224_10,1287099.804_10,
     . 99._10/
      data fc/   0.011_10,-13.257_10, 295263.137_10, 335778.877_10,
     . 1342._10/
      data dc/   0.019_10, -6.891_10,1105601.328_10,1072261.307_10,
     . 1236._10/
      data omc/  0.008_10,  7.455_10,-482890.539_10, 450160.28_10,
     . -5._10/
c
c
c     table of multiples of arguments and coefficients
c
c                   multiple of           longitude     obliquity
c              l    l'   f    d  node    coeff. of sin  coeff. of cos
      data x1/ 3.,  0.,  0.,  0.,  0.,       2.,    0.0,      0.,  0.0,
     .         2.,  1.,  0., -2.,  0.,       1.,    0.0,      0.,  0.0,
     .         2.,  0., -2.,  0.,  0.,      11.,    0.0,      0.,  0.0,
     .         2.,  0.,  0., -2.,  0.,      48.,    0.0,      1.,  0.0,
     .         2.,  0.,  0., -4.,  0.,      -1.,    0.0,      0.,  0.0,
     .         2.,  0.,  0.,  2.,  0.,       1.,    0.0,      0.,  0.0,
     .         2.,  0.,  0.,  0.,  0.,      29.,    0.0,     -1.,  0.0,
     .         1., -1.,  0., -1.,  0.,      -3.,    0.0,      0.,  0.0,
     .         1., -1.,  0., -2.,  0.,       1.,    0.0,      0.,  0.0,
     .         1., -1.,  0.,  0.,  0.,       5.,    0.0,      0.,  0.0,
     .         1.,  1.,  0., -2.,  0.,      -7.,    0.0,      0.,  0.0,
     .         1.,  1.,  0.,  0.,  0.,      -3.,    0.0,      0.,  0.0,
     .         1.,  0., -2., -2.,  0.,      -1.,    0.0,      0.,  0.0,
     .         1.,  0., -2.,  2.,  0.,      -1.,    0.0,      0.,  0.0,
     .         1.,  0., -2.,  0.,  0.,       4.,    0.0,      0.,  0.0,
     .         1.,  0.,  2., -2.,  0.,      -1.,    0.0,      0.,  0.0,
     .         1.,  0.,  2.,  0.,  0.,       3.,    0.0,      0.,  0.0,
     .         1.,  0.,  0., -1.,  0.,      -4.,    0.0,      0.,  0.0,
     .         1.,  0.,  0., -2.,  0.,    -158.,    0.0,     -1.,  0.0,
     .         1.,  0.,  0., -4.,  0.,      -1.,    0.0,      0.,  0.0/
      data x2/ 1.,  0.,  0.,  2.,  0.,       6.,    0.0,      0.,  0.0,
     .         1.,  0.,  0.,  0.,  0.,     712.,    0.1,     -7.,  0.0,
     .         0.,  1., -2.,  2.,  0.,      -1.,    0.0,      0.,  0.0,
     .         0.,  1.,  2., -2.,  0.,      -1.,    0.0,      0.,  0.0,
     .         0.,  1.,  0., -2.,  0.,      -4.,    0.0,      0.,  0.0,
     .         0.,  1.,  0.,  2.,  0.,      -1.,    0.0,      0.,  0.0,
     .         0.,  1.,  0.,  1.,  0.,       1.,    0.0,      0.,  0.0,
     .         0.,  0.,  2., -2.,  0.,     -22.,    0.0,      0.,  0.0,
     .         0.,  0.,  2.,  0.,  0.,      26.,    0.0,     -1.,  0.0,
     .         0.,  0.,  0.,  2.,  0.,      63.,    0.0,     -2.,  0.0,
     .         0.,  0.,  0.,  1.,  0.,      -4.,    0.0,      0.,  0.0,
     .        -1., -1.,  0.,  2.,  1.,       1.,    0.0,      0.,  0.0,
     .        -1.,  0.,  2., -2.,  1.,      -2.,    0.0,      1.,  0.0,
     .        -1.,  0.,  2.,  2.,  1.,     -10.,    0.0,      5.,  0.0,
     .        -1.,  0.,  2.,  0.,  1.,      21.,    0.0,    -10.,  0.0,
     .        -1.,  0.,  0.,  2.,  1.,      16.,    0.0,     -8.,  0.0,
     .        -1.,  0.,  0.,  1.,  1.,       1.,    0.0,      0.,  0.0,
     .        -1.,  0.,  0.,  0.,  1.,     -58.,   -0.1,     32.,  0.0,
     .        -2.,  0.,  2.,  0.,  1.,      46.,    0.0,    -24.,  0.0,
     .        -2.,  0.,  0.,  2.,  1.,      -6.,    0.0,      3.,  0.0/
c**  /        -1.,  0.,  0., -2.,  1.,      -2.,    0.0,      1.,  0.0,
      data x3/-2.,  0.,  0.,  0.,  1.,      -2.,    0.0,      1.,  0.0,
     .         2.,  0., -2.,  0.,  1.,       1.,    0.0,      0.,  0.0,
     .         2.,  0.,  2., -2.,  1.,       1.,    0.0,     -1.,  0.0,
     .         2.,  0.,  2.,  0.,  1.,      -5.,    0.0,      3.,  0.0,
     .         2.,  0.,  0., -2.,  1.,       4.,    0.0,     -2.,  0.0,
     .         2.,  0.,  0.,  0.,  1.,       2.,    0.0,     -1.,  0.0,
     .         1.,  1.,  0., -2.,  1.,      -1.,    0.0,      0.,  0.0,
     .         1.,  0.,  2., -2.,  1.,       6.,    0.0,     -3.,  0.0,
     .         1.,  0.,  2.,  2.,  1.,      -1.,    0.0,      1.,  0.0,
     .         1.,  0.,  2.,  0.,  1.,     -51.,    0.0,     27.,  0.0,
     .         1.,  0.,  0., -2.,  1.,     -13.,    0.0,      7.,  0.0,
     .         1.,  0.,  0.,  2.,  1.,      -1.,    0.0,      0.,  0.0,
     .         1.,  0.,  0.,  0.,  1.,      63.,    0.1,    -33.,  0.0,
     .         0., -2.,  2., -2.,  1.,      -2.,    0.0,      1.,  0.0,
     .         0., -1.,  2., -2.,  1.,      -5.,    0.0,      3.,  0.0,
     .         0., -1.,  2.,  0.,  1.,      -1.,    0.0,      0.,  0.0,
     .         0., -1.,  0.,  0.,  1.,     -12.,    0.0,      6.,  0.0,
     .         0.,  1.,  2., -2.,  1.,       4.,    0.0,     -2.,  0.0,
     .         0.,  1.,  2.,  0.,  1.,       1.,    0.0,      0.,  0.0,
     .         0.,  1.,  0.,  0.,  1.,     -15.,    0.0,      9.,  0.0/
      data x4/ 0.,  0., -2.,  2.,  1.,       1.,    0.0,      0.,  0.0,
     .         0.,  0., -2.,  0.,  1.,      -1.,    0.0,      0.,  0.0,
     .         0.,  0.,  2., -2.,  1.,     129.,    0.1,    -70.,  0.0,
     .         0.,  0.,  2.,  2.,  1.,      -7.,    0.0,      3.,  0.0,
     .         0.,  0.,  2.,  0.,  1.,    -386.,   -0.4,    200.,  0.0,
     .         0.,  0.,  0., -2.,  1.,      -5.,    0.0,      3.,  0.0,
     .         0.,  0.,  0.,  2.,  1.,      -6.,    0.0,      3.,  0.0,
     .        -1., -1.,  2.,  2.,  2.,      -3.,    0.0,      1.,  0.0,
     .        -1.,  0.,  4.,  0.,  2.,       1.,    0.0,      0.,  0.0,
     .        -1.,  0.,  2.,  4.,  2.,      -2.,    0.0,      1.,  0.0,
     .        -1.,  0.,  2.,  2.,  2.,     -59.,    0.0,     26.,  0.0,
     .        -1.,  0.,  2.,  0.,  2.,     123.,    0.0,    -53.,  0.0,
     .        -1.,  0.,  0.,  0.,  2.,       1.,    0.0,     -1.,  0.0,
     .        -2.,  0.,  2.,  4.,  2.,      -1.,    0.0,      1.,  0.0,
     .        -2.,  0.,  2.,  2.,  2.,       1.,    0.0,     -1.,  0.0,
     .        -2.,  0.,  2.,  0.,  2.,      -3.,    0.0,      1.,  0.0,
     .         3.,  0.,  2., -2.,  2.,       1.,    0.0,      0.,  0.0,
     .         3.,  0.,  2.,  0.,  2.,      -3.,    0.0,      1.,  0.0,
     .         2.,  0.,  2., -2.,  2.,       6.,    0.0,     -3.,  0.0,
     .         2.,  0.,  2.,  2.,  2.,      -1.,    0.0,      0.,  0.0/
      data x5/ 2.,  0.,  2.,  0.,  2.,     -31.,    0.0,     13.,  0.0,
     .         1., -1.,  2.,  0.,  2.,      -3.,    0.0,      1.,  0.0,
     .         1.,  1.,  2., -2.,  2.,       1.,    0.0,     -1.,  0.0,
     .         1.,  1.,  2.,  0.,  2.,       2.,    0.0,     -1.,  0.0,
     .         1.,  0.,  2., -2.,  2.,      29.,    0.0,    -12.,  0.0,
     .         1.,  0.,  2.,  2.,  2.,      -8.,    0.0,      3.,  0.0,
     .         1.,  0.,  2.,  0.,  2.,    -301.,    0.0,    129., -0.1,
     .         1.,  0.,  0.,  0.,  2.,      -2.,    0.0,      1.,  0.0,
     .         0., -1.,  2.,  2.,  2.,      -3.,    0.0,      1.,  0.0,
     .         0., -1.,  2.,  0.,  2.,      -7.,    0.0,      3.,  0.0,
     .         0.,  1.,  2.,  0.,  2.,       7.,    0.0,     -3.,  0.0,
     .         0.,  1.,  0.,  0.,  2.,       1.,    0.0,      0.,  0.0,
     .         0.,  0.,  4., -2.,  2.,       1.,    0.0,      0.,  0.0,
     .         0.,  0.,  2., -1.,  2.,      -1.,    0.0,      0.,  0.0,
     .         0.,  0.,  2.,  4.,  2.,      -1.,    0.0,      0.,  0.0,
     .         0.,  0.,  2.,  2.,  2.,     -38.,    0.0,     16.,  0.0,
     .         0.,  0.,  2.,  1.,  2.,       2.,    0.0,     -1.,  0.0,
     .         0.,  0.,  2.,  0.,  2.,   -2274.,   -0.2,    977., -0.5,
     .         0.,  0.,  0.,  0.,  2.,    2062.,    0.2,   -895.,  0.5,
     .         0.,  2.,  0.,  0.,  0.,      17.,   -0.1,      0.,  0.0/
      data x6/ 0.,  1.,  0.,  0.,  0.,    1426.,   -3.4,     54., -0.1,
     .         0., -1.,  2., -2.,  2.,     217.,   -0.5,    -95.,  0.3,
     .         0.,  2.,  2., -2.,  2.,     -16.,    0.1,      7.,  0.0,
     .         0.,  1.,  2., -2.,  2.,    -517.,    1.2,    224., -0.6,
     .         0.,  0.,  2., -2.,  2.,  -13187.,   -1.5,   5736., -3.1,
     .         0.,  0.,  0.,  0.,  1., -171996., -174.2,  92025.,  8.9/
c
c     computation of  fundamental arguments
c
c     t is tdb time in julian centuries since j2000 (tdb jd 2451545.0)
c
      el = MOD((((elc(1)*t+elc(2))*t+elc(3))*t+elc(4))
     .     *Convds + MOD(elc(5)*t,1._10)*Twopi, Twopi)
 
      elp = MOD((((elpc(1)*t+elpc(2))*t+elpc(3))*t+elpc(4))
     .      *Convds + MOD(elpc(5)*t,1._10)*Twopi, Twopi)
 
      f = MOD((((fc(1)*t+fc(2))*t+fc(3))*t+fc(4))
     .    *Convds + MOD(fc(5)*t,1._10)*Twopi, Twopi)
 
      d = MOD((((dc(1)*t+dc(2))*t+dc(3))*t+dc(4))
     .    *Convds + MOD(dc(5)*t,1._10)*Twopi, Twopi)
 
      omega = MOD((((omc(1)*t+omc(2))*t+omc(3))*t+omc(4))
     .        *Convds + MOD(omc(5)*t,1._10)*Twopi, Twopi)
 
      dpsi8 = 0._10
      deps8 = 0._10
c
c sum nutation series terms
c
      do j = 1, 106
         i = j
 
c formation of multiples of arguments
         dblarg = x(1,i)*el + x(2,i)*elp + x(3,i)*f + x(4,i)*d
     .            + x(5,i)*omega
         arg    = MOD(dblarg, Twopi)
 
c evaluate nutation
         dpsi8 = (x(6,i) + x(7,i)*t)*sin(arg) + dpsi8
         deps8 = (x(8,i) + x(9,i)*t)*cos(arg) + deps8
      end do
 
      dpsi = dpsi8*1E-4_10*Convds
      deps = deps8*1E-4_10*Convds
 
      return
      end