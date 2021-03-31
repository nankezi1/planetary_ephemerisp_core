      real*10 function SDPSI(t)
 
      implicit none
 
c
c m.e.ash   oct 1967    function sdpsi
c evaluate the 46 short period terms of the nutation in longitude
c (explanatory supplement to the ephemeris, p.45)
c
      real*10 t, dp2, NUTRM
c t  =julian centuries since jed 2415020.0
c
      dp2 = 0.0_10
      dp2 = dp2 + NUTRM(0._10,0._10,+2._10,0._10,+2._10,
     .      -2037._10 - 0.2_10*t, 1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,0._10,0._10,0._10,
     .      +675._10 + 0.1_10*t, 1)
      dp2 = dp2 + NUTRM(0._10,0._10,+2._10,0._10,+1._10,
     .      -342._10 - 0.4_10*t, 1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,+2._10,0._10,+2._10,-261._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,0._10,-2._10,0._10,-149._10,1)
      dp2 = dp2 + NUTRM(-1._10,0._10,+2._10,0._10,+2._10,+114._10,1)
      dp2 = dp2 + NUTRM(0._10,0._10,0._10,+2._10,0._10,+60._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,0._10,0._10,+1._10,+58._10,1)
      dp2 = dp2 + NUTRM(-1._10,0._10,0._10,0._10,+1._10,-57._10,1)
      dp2 = dp2 + NUTRM(-1._10,0._10,+2._10,+2._10,+2._10,-52._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,+2._10,0._10,+1._10,-44._10,1)
      dp2 = dp2 + NUTRM(0._10,0._10,+2._10,+2._10,+2._10,-32._10,1)
      dp2 = dp2 + NUTRM( + 2._10,0._10,0._10,0._10,0._10,+28._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,+2._10,-2._10,+2._10,+26._10,1)
      dp2 = dp2 + NUTRM( + 2._10,0._10,+2._10,0._10,+2._10,-26._10,1)
      dp2 = dp2 + NUTRM(0._10,0._10,+2._10,0._10,0._10,+25._10,1)
      dp2 = dp2 + NUTRM(-1._10,0._10,+2._10,0._10,+1._10,+19._10,1)
      dp2 = dp2 + NUTRM(-1._10,0._10,0._10,+2._10,+1._10,+14._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,0._10,-2._10,+1._10,-13._10,1)
      dp2 = dp2 + NUTRM(-1._10,0._10,+2._10,+2._10,+1._10,-9._10,1)
      dp2 = dp2 + NUTRM( + 1._10,+1._10,0._10,-2._10,0._10,-7._10,1)
      dp2 = dp2 + NUTRM(0._10,+1._10,+2._10,0._10,+2._10,+7._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,0._10,+2._10,0._10,+6._10,1)
      dp2 = dp2 + NUTRM(0._10,0._10,0._10,+2._10,+1._10,-6._10,1)
      dp2 = dp2 + NUTRM(0._10,-1._10,+2._10,0._10,+2._10,-6._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,+2._10,+2._10,+2._10,-6._10,1)
      dp2 = dp2 + NUTRM( + 2._10,0._10,+2._10,-2._10,+2._10,+6._10,1)
      dp2 = dp2 + NUTRM(0._10,0._10,0._10,-2._10,+1._10,-5._10,1)
      dp2 = dp2 + NUTRM(0._10,0._10,+2._10,+2._10,+1._10,-5._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,+2._10,-2._10,+1._10,+5._10,1)
      dp2 = dp2 + NUTRM(0._10,0._10,0._10,+1._10,0._10,-4._10,1)
      dp2 = dp2 + NUTRM(0._10,+1._10,0._10,-2._10,0._10,-4._10,1)
      dp2 = dp2 + NUTRM( + 1._10,-1._10,0._10,0._10,0._10,+4._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,-2._10,0._10,0._10,+4._10,1)
      dp2 = dp2 + NUTRM( + 2._10,0._10,+2._10,0._10,+1._10,-4._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,+2._10,0._10,0._10,+3._10,1)
      dp2 = dp2 + NUTRM( + 1._10,+1._10,0._10,0._10,0._10,-3._10,1)
      dp2 = dp2 + NUTRM( + 1._10,-1._10,+2._10,0._10,+2._10,-3._10,1)
      dp2 = dp2 + NUTRM(-2._10,0._10,0._10,0._10,+1._10,-2._10,1)
      dp2 = dp2 + NUTRM(-1._10,0._10,+2._10,-2._10,+1._10,-2._10,1)
      dp2 = dp2 + NUTRM( + 2._10,0._10,0._10,0._10,+1._10,+2._10,1)
      dp2 = dp2 + NUTRM(-1._10,-1._10,+2._10,+2._10,+2._10,-2._10,1)
      dp2 = dp2 + NUTRM(0._10,-1._10,+2._10,+2._10,+2._10,-2._10,1)
      dp2 = dp2 + NUTRM( + 1._10,0._10,0._10,0._10,+2._10,-2._10,1)
      dp2 = dp2 + NUTRM( + 1._10,+1._10,+2._10,0._10,+2._10,+2._10,1)
      dp2 = dp2 + NUTRM( + 3._10,0._10,+2._10,0._10,+2._10,-2._10,1)
 
      SDPSI = dp2
      return
      end
