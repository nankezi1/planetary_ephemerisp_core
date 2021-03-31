      real function EATMDL(wetz, dryz, zen)
 
      implicit none
 
 
c*** start of declarations inserted by spag
      real      dryz, elev, f, r, rd, rdp1, rdp5, rp5, rw, rwp1, rwp5, 
     .          wetz, zen
      integer   n
 
c*** end of declarations inserted by spag
 
 
c
c w. r. snow   eatmdl   sept 1976
c
c     this function computes the phase or group delay in seconds caused
c     by the wet and dry components of the earth's neutral atmosphere
c             wetz - wet zenith correction (sec.)
c             dryz - dry zenith correction (sec.)
c             zen  - zenith angle (rad.)
c     this model uses the mapping table presented in
c     jpl iom 391.3-352 may 25, 1971
      dimension rdp1(100), rwp1(100), rdp5(102), rwp5(102), rp5(63)
      data rdp1/33.8546, 32.6543, 31.5170, 30.4389, 29.4161, 28.4452,
     .     27.5232, 26.6469, 25.8136, 25.0208, 24.2659, 23.5468,
     .     22.8614, 22.2077, 21.5839, 20.9882, 20.4191, 19.8750,
     .     19.3546, 18.8566, 18.3797, 17.9228, 17.4848, 17.0647,
     .     16.6616, 16.2745, 15.9027, 15.5454, 15.2017, 14.8711,
     .     14.5529, 14.2464, 13.9511, 13.6665, 13.3921, 13.1273,
     .     12.8717, 12.6248, 12.3864, 12.1559, 11.9331, 11.7176,
     .     11.5090, 11.3071, 11.1116, 10.9222, 10.7386, 10.5606,
     .     10.3880, 10.2205, 10.0580, 9.9002, 9.7469, 9.5980, 9.4532,
     .     9.3126, 9.1757, 9.0426, 8.9131, 8.7870, 8.6643, 8.5447,
     .     8.4283, 8.3148, 8.2041, 8.0963, 7.9911, 7.8885, 7.7883,
     .     7.6906, 7.5952, 7.5020, 7.4110, 7.3221, 7.2352, 7.1503,
     .     7.0673, 6.9861, 6.9067, 6.8290, 6.7531, 6.6787, 6.6059,
     .     6.5346, 6.4648, 6.3965, 6.3295, 6.2639, 6.1996, 6.1366,
     .     6.0748, 6.0143, 5.9549, 5.8966, 5.8395, 5.7834, 5.7284,
     .     5.6744, 5.6214, 5.5693/
      data rwp1/59.5419, 55.8510, 52.4979, 49.4456, 46.6616, 44.1173,
     .     41.7876, 39.6501, 37.6852, 35.8756, 34.2059, 32.6624,
     .     31.2331, 29.9071, 28.6749, 27.5279, 26.4584, 25.4597,
     .     24.5256, 23.6506, 22.8297, 22.0586, 21.3331, 20.6498,
     .     20.0052, 19.3964, 18.8208, 18.2758, 17.7593, 17.2692,
     .     16.8037, 16.3610, 15.9397, 15.5383, 15.1556, 14.7901,
     .     14.4411, 14.1073, 13.7878, 13.4819, 13.1886, 12.9073,
     .     12.6373, 12.3779, 12.1286, 11.8887, 11.6578, 11.4354,
     .     11.2211, 11.0144, 10.8149, 10.6224, 10.4364, 10.2566,
     .     10.0828, 9.9146, 9.7518, 9.5942, 9.4414, 9.2934, 9.1498,
     .     9.0105, 8.8754, 8.7441, 8.6166, 8.4927, 8.3723, 8.2552,
     .     8.1413, 8.0304, 7.9226, 7.8175, 7.7161, 7.6154, 7.5181,
     .     7.4234, 7.3309, 7.2407, 7.1527, 7.0668, 6.9829, 6.9010,
     .     6.8210, 6.7428, 6.6663, 6.5916, 6.5185, 6.4471, 6.3771,
     .     6.3087, 6.2418, 6.1762, 6.1120, 6.0491, 5.9875, 5.9272,
     .     5.8680, 5.8101, 5.7532, 5.6975/
      data rdp5/5.8395, 5.5693, 5.3228, 5.0970, 4.8894, 4.6981, 4.5212,
     .     4.3572, 4.2047, 4.0627, 3.9301, 3.8060, 3.6897, 3.5805,
     .     3.4777, 3.3808, 3.2893, 3.2028, 3.1210, 3.0434, 2.9697,
     .     2.8997, 2.8332, 2.7697, 2.7093, 2.6516, 2.5964, 2.5437,
     .     2.4933, 2.4450, 2.3987, 2.3542, 2.3116, 2.2706, 2.2312,
     .     2.1933, 2.1569, 2.1217, 2.0879, 2.0552, 2.0237, 1.9933,
     .     1.9640, 1.9356, 1.9082, 1.8817, 1.8560, 1.8312, 1.8071,
     .     1.7838, 1.7612, 1.7395, 1.7183, 1.6977, 1.6778, 1.6584,
     .     1.6396, 1.6213, 1.6036, 1.5863, 1.5696, 1.5533, 1.5374,
     .     1.5220, 1.5070, 1.4924, 1.4782, 1.4644, 1.4509, 1.4378,
     .     1.4251, 1.4126, 1.4005, 1.3887, 1.3772, 1.3660, 1.3551,
     .     1.3444, 1.3340, 1.3239, 1.3140, 1.3044, 1.2950, 1.2858,
     .     1.2769, 1.2682, 1.2596, 1.2513, 1.2432, 1.2353, 1.2276,
     .     1.2201, 1.2128, 1.2056, 1.1986, 1.1918, 1.1852, 1.1787,
     .     1.1723, 1.1662, 1.1601, 1.1543/
      data rwp5/5.9875, 5.6975, 5.4344, 5.1948, 4.9755, 4.7742, 4.5888,
     .     4.4175, 4.2588, 4.1113, 3.9739, 3.8456, 3.7256, 3.6131,
     .     3.5074, 3.4080, 3.3142, 3.2257, 3.1421, 3.0628, 2.9877,
     .     2.9164, 2.8486, 2.7840, 2.7226, 2.6639, 2.6080, 2.5545,
     .     2.5034, 2.4544, 2.4075, 2.3625, 2.3194, 2.2779, 2.2381,
     .     2.1998, 2.1629, 2.1275, 2.0933, 2.0603, 2.0286, 1.9979,
     .     1.9683, 1.9397, 1.9120, 1.8853, 1.8594, 1.8343, 1.8101,
     .     1.7866, 1.7638, 1.7422, 1.7209, 1.7002, 1.6801, 1.6606,
     .     1.6417, 1.6234, 1.6055, 1.5882, 1.5713, 1.5550, 1.5391,
     .     1.5236, 1.5085, 1.4939, 1.4796, 1.4657, 1.4522, 1.4390,
     .     1.4262, 1.4137, 1.4016, 1.3897, 1.3782, 1.3669, 1.3560,
     .     1.3453, 1.3348, 1.3247, 1.3148, 1.3051, 1.2957, 1.2865,
     .     1.2775, 1.2688, 1.2602, 1.2519, 1.2438, 1.2358, 1.2281,
     .     1.2206, 1.2132, 1.2060, 1.1990, 1.1922, 1.1855, 1.1790,
     .     1.1727, 1.1665, 1.1605, 1.1546/
      data rp5/1.1601, 1.1543, 1.1485, 1.1430, 1.1375, 1.1322, 1.1270,
     .     1.1220, 1.1171, 1.1123, 1.1076, 1.1031, 1.0987, 1.0944,
     .     1.0902, 1.0861, 1.0822, 1.0783, 1.0746, 1.0710, 1.0674,
     .     1.0640, 1.0607, 1.0575, 1.0544, 1.0513, 1.0484, 1.0456,
     .     1.0428, 1.0402, 1.0377, 1.0352, 1.0328, 1.0305, 1.0283,
     .     1.0262, 1.0242, 1.0223, 1.0204, 1.0187, 1.0170, 1.0154,
     .     1.0139, 1.0124, 1.0111, 1.0098, 1.0086, 1.0075, 1.0065,
     .     1.0055, 1.0046, 1.0038, 1.0031, 1.0024, 1.0019, 1.0014,
     .     1.0010, 1.0006, 1.0003, 1.0002, 1.0000, 1.0000, 1.0000/
c     rwp1 0.1 degree increment for wet correction (0.2-10.0 deg)
c     rdp1 0.1 degree increment for dry correction (0.2-10.0 deg)
c     rwp5 0.5 degree increment for wet correction (10.0-60.0 deg)
c     rdp5 0.5 degree increment for dry correction (10.0-60.0 deg)
c     rp5 0.5 degree increment for wet & dry correction (60.0-90.0 deg)
      elev = 90.0 - zen*57.295780
      if( elev .lt. 0.0 ) then
c mistake somewhere, elevation angle greater than 90.0 degrees
c call suicid to print message but don't end it all
         EATMDL = 0.0
      else if( elev .gt. 90.0 ) then
         EATMDL = 0.0
      else
         if( dryz .eq. 0.0 ) then
 
c no zenith corrections input use gds yearly ave.
            dryz = 2.06/2.997925E+8
            wetz = 0.065/2.997925E+8
         endif
         if( elev .lt. 10.0 ) then
            if( elev .lt. 0.2 ) then
c elevation less than 0.2 deg use 0.1 deg correction
c for elevation less than 0.0 assume zero correction
               EATMDL = rwp1(1)*wetz + rdp1(1)*dryz
            else
               f  = amod(elev, 0.1)/0.1
               n  = elev/0.1
               rw = rwp1(n) + f*(rwp1(n+1) - rwp1(n)) + 0.5*f*(f - 1.0)
     .              *(rwp1(n+1) - 2.0*rwp1(n) + rwp1(n-1))
               rd = rdp1(n) + f*(rdp1(n+1) - rdp1(n)) + 0.5*f*(f - 1.0)
     .              *(rdp1(n+1) - 2.0*rdp1(n) + rdp1(n-1))
               EATMDL = rw*wetz + rd*dryz
            endif
         else if( elev .gt. 60.0 ) then
c elevations greater than 60.0 deg. use same scaling law for
c wet and dry components of correction
            f = amod(elev, 0.5)/0.5
            n = (elev/0.5) - 118
            r = rp5(n) + f*(rp5(n+1) - rp5(n)) + 0.5*f*(f - 1.0)
     .          *(rp5(n+1) - 2.0*rp5(n) + rp5(n-1))
            EATMDL = r*(wetz + dryz)
         else
            f  = amod(elev, 0.5)/0.5
            n  = (elev/0.5) - 18
            rw = rwp5(n) + f*(rwp5(n+1) - rwp5(n)) + 0.5*f*(f - 1.0)
     .           *(rwp5(n+1) - 2.0*rwp5(n) + rwp5(n-1))
            rd = rdp5(n) + f*(rdp5(n+1) - rdp5(n)) + 0.5*f*(f - 1.0)
     .           *(rdp5(n+1) - 2.0*rdp5(n) + rdp5(n-1))
            EATMDL = rw*wetz + rd*dryz
         endif
      endif
      return
      end
