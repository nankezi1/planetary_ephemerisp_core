      real*10 function SDEPS(t)
 
      implicit none
 
c
c m.e.ash   oct 1967   function sdeps
c evaluate the 24 short period terms of the nutation in obliquity
c (explanatory supplement to the ephemeris, p.45)
c
      real*10 t, de2, NUTRM
c t  =julian centuries since jed 2415020.0
c
      de2 = 0.0_10
      de2 = de2 + NUTRM(0._10,0._10,+2._10,0._10,+2._10,
     .      +884._10 - 0.5_10*t, 2)
      de2 = de2 + NUTRM(0._10,0._10,+2._10,0._10,+1._10,+183._10,2)
      de2 = de2 + NUTRM( + 1._10,0._10,+2._10,0._10,+2._10,
     .      +113._10 - 0.1_10*t, 2)
      de2 = de2 + NUTRM(-1._10,0._10,+2._10,0._10,+2._10,-50._10,2)
      de2 = de2 + NUTRM( + 1._10,0._10,0._10,0._10,+1._10,-31._10,2)
      de2 = de2 + NUTRM(-1._10,0._10,0._10,0._10,+1._10,+30._10,2)
      de2 = de2 + NUTRM(-1._10,0._10,+2._10,+2._10,+2._10,+22._10,2)
      de2 = de2 + NUTRM( + 1._10,0._10,+2._10,0._10,+1._10,+23._10,2)
      de2 = de2 + NUTRM(0._10,0._10,+2._10,+2._10,+2._10,+14._10,2)
      de2 = de2 + NUTRM( + 1._10,0._10,+2._10,-2._10,+2._10,-11._10,2)
      de2 = de2 + NUTRM( + 2._10,0._10,+2._10,0._10,+2._10,+11._10,2)
      de2 = de2 + NUTRM(-1._10,0._10,+2._10,0._10,+1._10,-10._10,2)
      de2 = de2 + NUTRM(-1._10,0._10,0._10,+2._10,+1._10,-7._10,2)
      de2 = de2 + NUTRM( + 1._10,0._10,0._10,-2._10,+1._10,+7._10,2)
      de2 = de2 + NUTRM(-1._10,0._10,+2._10,+2._10,+1._10,+5._10,2)
      de2 = de2 + NUTRM(0._10,+1._10,+2._10,0._10,+2._10,-3._10,2)
      de2 = de2 + NUTRM(0._10,0._10,0._10,+2._10,+1._10,+3._10,2)
      de2 = de2 + NUTRM(0._10,-1._10,+2._10,0._10,+2._10,+3._10,2)
      de2 = de2 + NUTRM( + 1._10,0._10,+2._10,+2._10,+2._10,+3._10,2)
      de2 = de2 + NUTRM( + 2._10,0._10,+2._10,-2._10,+2._10,-2._10,2)
      de2 = de2 + NUTRM(0._10,0._10,0._10,-2._10,+1._10,+3._10,2)
      de2 = de2 + NUTRM(0._10,0._10,+2._10,+2._10,+1._10,+3._10,2)
      de2 = de2 + NUTRM( + 1._10,+0._10,+2._10,-2._10,+1._10,-3._10,2)
      de2 = de2 + NUTRM( + 2._10,0._10,+2._10,0._10,+1._10,+2._10,2)
 
      SDEPS = de2
      return
      end
