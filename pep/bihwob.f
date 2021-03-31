      subroutine BIHWOB(jd, frw, x, y)
 
      implicit none
 
 
c*** start of declarations inserted by spag
      real      f1, f2, s, s2, t, t2, x, y
      integer   i, int, j, jd, nr
 
c*** end of declarations inserted by spag
 
 
c
c ash/forni  february 1975   subroutine bihwob
c***********includes rapid service values
c 12/10/80  final value 10/02/80  rapid service values 10/07/80-11/21/80
c
c        calculates earth wobble by second diff. interpolation from
c         5-day interval table
c$$$$$period of validity to be extended when routine revised
c        call xwobbl to go beyond table
c
c        common
      include 'fcntrl.inc'
      include 'funcon.inc'
      include 'inodta.inc'
      include 'nutprc.inc'
      include 'yvect.inc'
 
      real*4    result(2), y1(2), y2(2)
      real*10 frw, tt
      logical*1 nxtrp/.false./
      logical*1 lxtrp/.false./
      integer*2 cc(1008, 2)
      integer*2 xc(1008), yc(1008)
      equivalence (cc(1,1), xc), (cc(1,2), yc)
c
c      - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c
c        wobble at five days interval from b.i.h.
c        (bureau international de l'heure)
c
c        tabular points from  2440220 to  2441055 (julian day numbers)
c        (december 29,1968 to april 13,1971, 0 hr)
      integer*2 x6971(168)/  -149,  -149,  -149,  -145,  -137,  -128,
     1  -119,  -109,   -98,   -88,   -78,   -70,   -62,   -53,   -45,
     2   -40,   -34,   -30,   -25,   -20,   -14,    -8,    -1,     6,
     3    14,    21,    29,    37,    46,    54,    62,    71,    80,
     4    89,    99,   108,   117,   126,   134,   142,   147,   151,
     5   152,   152,   151,   145,   137,   129,   120,   110,    98,
     6    88,    79,    71,    65,    58,    50,    44,    39,    34,
     7    29,    25,    21,    14,     4,    -8,   -20,   -32,   -44,
     8   -59,   -74,   -89,  -103,  -117,  -129,  -140,  -151,  -160,
     9  -166,  -171,  -174,  -175,  -173,  -168,  -161,  -151,  -139,
     a  -128,  -119,  -113,  -109,  -106,  -106,  -104,  -101,   -96,
     b   -89,   -81,   -71,   -62,   -51,   -37,   -21,    -3,    17,
     c    37,    55,    72,    88,   104,   119,   133,   145,   157,
     d   168,   177,   186,   193,   199,   204,   207,   209,   209,
     e   208,   205,   202,   199,   195,   191,   187,   183,   175,
     f   160,   141,   120,    99,    78,    60,    48,    36,    24,
     g    12,     0,   -14,   -29,   -43,   -57,   -71,   -85,   -99,
     h  -111,  -122,  -133,  -143,  -152,  -162,  -174,  -186,  -196,
     i  -204,  -209,  -213,  -216,  -216,  -212,  -206,  -200,  -196/
      integer*2 y6971(168)/   238,   249,   261,   272,   282,   290,
     1   297,   303,   307,   311,   316,   322,   328,   332,   337,
     2   344,   350,   355,   360,   365,   368,   371,   372,   373,
     3   373,   372,   371,   368,   365,   361,   357,   352,   346,
     4   339,   332,   324,   317,   309,   300,   286,   273,   257,
     5   241,   224,   205,   188,   173,   160,   147,   136,   125,
     6   118,   115,   113,   111,   109,   108,   107,   106,   105,
     7   104,   103,   102,   101,   101,   103,   106,   110,   114,
     8   120,   125,   130,   135,   140,   146,   158,   175,   193,
     9   210,   230,   251,   271,   290,   307,   323,   337,   350,
     a   361,   371,   380,   388,   394,   399,   404,   410,   415,
     b   421,   427,   434,   439,   444,   447,   448,   449,   448,
     c   446,   442,   435,   426,   415,   402,   388,   373,   358,
     d   342,   326,   309,   292,   276,   260,   244,   228,   213,
     e   198,   183,   169,   155,   141,   128,   114,   101,    89,
     f    78,    70,    63,    57,    53,    46,    38,    30,    23,
     g    17,    13,    11,    13,    17,    22,    28,    35,    45,
     h    57,    71,    85,   101,   117,   133,   148,   163,   178,
     i   194,   211,   231,   253,   277,   301,   321,   340,   356/
c
c        tabular points from  2441060 to 2441895 (julian day numbers)
c        (april 18,1971 to july 31,1973, 0 hr)
      integer*2 x7173(168)/  -192,  -188,  -183,  -177,  -170,  -160,
     1  -150,  -140,  -129,  -117,  -104,   -85,   -61,   -30,     2,
     2    32,    60,    83,   103,   122,   140,   155,   170,   184,
     3   198,   212,   224,   235,   245,   253,   258,   261,   263,
     4   264,   264,   260,   252,   241,   229,   216,   203,   191,
     5   179,   168,   157,   146,   135,   122,   109,    96,    83,
     6    69,    55,    39,    22,     4,   -14,   -33,   -52,   -69,
     7   -83,   -96,  -107,  -117,  -127,  -139,  -151,  -163,  -174,
     8  -183,  -191,  -194,  -194,  -193,  -191,  -188,  -184,  -179,
     9  -173,  -167,  -160,  -153,  -145,  -134,  -120,  -105,   -89,
     a   -72,   -54,   -37,   -20,    -2,    16,    34,    52,    70,
     b    88,   102,   113,   123,   131,   139,   145,   149,   152,
     c   155,   157,   159,   161,   164,   168,   171,   174,   176,
     d   177,   179,   180,   180,   177,   174,   171,   167,   162,
     e   157,   151,   143,   134,   124,   114,   103,    92,    82,
     f    72,    63,    53,    44,    34,    24,    13,     2,   -10,
     g   -22,   -34,   -46,   -59,   -72,   -83,   -92,  -100,  -106,
     h  -111,  -114,  -116,  -117,  -117,  -117,  -117,  -116,  -114,
     i  -110,  -105,   -98,   -89,   -80,   -70,   -60,   -51,   -42/
      integer*2 y7173(168)/   370,   384,   397,   410,   424,   438,
     1   452,   466,   480,   493,   505,   514,   519,   523,   524,
     2   523,   520,   512,   500,   488,   476,   463,   450,   436,
     3   421,   404,   387,   369,   351,   334,   317,   300,   283,
     4   266,   249,   230,   211,   193,   175,   157,   139,   126,
     5   118,   110,   103,    97,    92,    86,    78,    70,    62,
     6    54,    48,    41,    35,    30,    26,    25,    27,    30,
     7    34,    41,    50,    61,    74,    89,   105,   122,   140,
     8   159,   178,   196,   214,   232,   249,   265,   281,   296,
     9   310,   323,   335,   346,   356,   366,   376,   385,   394,
     a   402,   409,   417,   424,   429,   433,   435,   436,   436,
     b   435,   433,   429,   424,   418,   410,   400,   388,   375,
     c   362,   349,   337,   325,   315,   304,   294,   283,   273,
     d   262,   254,   245,   236,   227,   218,   206,   192,   178,
     e   164,   150,   136,   126,   117,   108,   100,    92,    85,
     f    84,    87,    90,    95,   100,   104,   108,   111,   115,
     g   119,   124,   130,   138,   147,   156,   166,   176,   185,
     h   194,   204,   213,   220,   227,   233,   241,   250,   259,
     i   268,   277,   286,   294,   301,   308,   314,   319,   325/
c
c        tabular points from  2441900  to  2442735 (julian day numbers)
c        (august 5,1973 to  november 18, 1975, 0 hr)
      integer*2 x7375(168)/   -33,   -25,   -17,   -10,    -3,     3,
     1     8,    16,    25,    33,    41,    48,    55,    63,    71,
     2    78,    85,    92,    99,   104,   107,   110,   112,   115,
     3   118,   122,   126,   129,   131,   132,   131,   128,   123,
     4   116,   110,   104,    98,    93,    88,    84,    80,    76,
     5    71,    65,    58,    50,    42,    34,    26,    18,    10,
     6     4,    -2,    -7,   -11,   -17,   -20,   -23,   -25,   -27,
     7   -28,   -27,   -25,   -22,   -19,   -14,    -9,    -3,     2,
     8     7,    11,    14,    17,    18,    19,    20,    21,    20,
     9    19,    18,    18,    19,    20,    19,    18,    17,    14,
     a    10,     5,     0,    -5,   -10,   -14,   -17,   -20,   -23,
     b   -27,   -31,   -33,   -35,   -36,   -37,   -38,   -39,   -40,
     c   -39,   -37,   -34,   -30,   -24,   -20,   -16,   -12,    -9,
     d    -6,    -4,    -2,     0,     3,     7,    12,    19,    25,
     e    31,    37,    43,    48,    53,    57,    61,    66,    71,
     f    76,    83,    90,    98,   106,   114,   121,   127,   131,
     g   133,   134,   135,   135,   136,   136,   137,   137,   136,
     h   135,   132,   126,   119,   111,   102,    93,    83,    73,
     i    62,    50,    37,    24,    10,    -5,   -19,   -33,   -47/
      integer*2 y7375(168)/   330,   334,   337,   338,   339,   340,
     1   340,   341,   342,   344,   346,   347,   348,   347,   346,
     2   344,   341,   337,   333,   328,   322,   316,   310,   304,
     3   299,   292,   285,   277,   269,   260,   250,   239,   228,
     4   218,   208,   200,   194,   191,   188,   186,   184,   182,
     5   180,   179,   179,   179,   181,   183,   186,   189,   192,
     6   195,   198,   200,   202,   204,   205,   207,   208,   210,
     7   211,   212,   213,   214,   215,   215,   216,   216,   216,
     8   216,   217,   218,   219,   219,   219,   219,   218,   218,
     9   218,   218,   218,   218,   219,   221,   224,   227,   232,
     a   238,   244,   249,   254,   258,   261,   263,   265,   267,
     b   269,   271,   273,   275,   277,   279,   280,   281,   283,
     c   285,   288,   291,   294,   297,   302,   308,   314,   320,
     d   325,   329,   333,   336,   339,   342,   344,   344,   345,
     e   345,   344,   341,   336,   330,   323,   317,   310,   304,
     f   298,   291,   285,   278,   271,   264,   257,   249,   241,
     g   233,   225,   216,   208,   199,   190,   181,   173,   166,
     h   159,   152,   145,   139,   133,   128,   122,   117,   112,
     i   108,   105,   103,   102,   102,   103,   107,   114,   122/
c        tabular points from  2442740  to  2443575 (julian day numbers)
c        (november 23, 1975 to  march 7, 1978  0 hr)
      integer*2 x7578(168)/   -61,   -74,   -87,   -97,  -105,  -113,
     1  -120,  -125,  -130,  -133,  -135,  -136,  -137,  -138,  -138,
     2  -138,  -137,  -135,  -132,  -129,  -126,  -122,  -118,  -114,
     3  -110,  -105,  -100,   -93,   -85,   -76,   -67,   -57,   -46,
     4   -35,   -22,    -9,     5,    20,    35,    50,    66,    82,
     5    99,   116,   133,   150,   165,   179,   192,   204,   216,
     6   227,   237,   246,   254,   260,   265,   268,   267,   264,
     7   260,   255,   248,   240,   229,   217,   204,   190,   175,
     8   159,   142,   125,   108,   091,   074,   058,   040,   022,
     9   004,  -014,  -032,  -049,  -066,  -083,  -100,  -116,  -132,
     a  -148,  -163,  -178,  -192,  -204,  -214,  -222,  -228,  -233,
     b  -237,  -238,  -237,  -235,  -232,  -226,  -217,  -206,  -194,
     c  -181,  -167,  -152,  -135,  -117,  -097,  -076,  -054,  -032,
     d  -009,   014,   036,   058,   080,   102,   124,   145,   165,
     e   183,   200,   217,   233,   247,   260,   272,   282,   289,
     f   294,   298,   299,   299,   296,   291,   283,   273,   261,
     g   248,   234,   220,   206,   192,   178,   163,   147,   129,
     h   109,   088,   067,   045,   023,   003,  -016,  -035,  -053,
     i  -071,  -090,  -108,  -124,  -139,  -154,  -168,  -182,  -195/
      integer*2 y7578(168)/   131,   140,   149,   157,   165,   174,
     1   184,   195,   206,   217,   228,   239,   250,   262,   274,
     2   287,   300,   312,   324,   335,   345,   354,   363,   372,
     3   381,   390,   399,   409,   419,   428,   436,   443,   448,
     4   452,   454,   454,   453,   450,   445,   439,   432,   423,
     5   413,   403,   392,   380,   369,   358,   347,   336,   325,
     6   313,   300,   286,   272,   257,   242,   227,   214,   202,
     7   190,   177,   165,   154,   143,   133,   124,   116,   108,
     8   099,   091,   084,   077,   071,   068,   066,   066,   066,
     9   067,   069,   072,   076,   083,   092,   102,   114,   128,
     a   143,   159,   176,   194,   212,   230,   248,   267,   286,
     b   305,   324,   343,   362,   379,   395,   411,   426,   441,
     c   454,   467,   478,   487,   494,   499,   502,   505,   507,
     d   508,   508,   505,   501,   494,   487,   478,   468,   457,
     e   444,   431,   416,   400,   383,   367,   350,   332,   315,
     f   297,   278,   260,   241,   222,   203,   184,   166,   149,
     g   132,   116,   102,   089,   077,   066,   056,   047,   038,
     h   030,   024,   019,   016,   015,   015,   018,   023,   030,
     i   038,   049,   061,   073,   086,   099,   112,   126,   142/
c        tabular points from  2443580  to  2444415 (julian day numbers)
c        (march 12, 1978  to  june 24, 1980  0 hr)
      integer*2 x7880(168)/  -206,  -216,  -226,  -234,  -240,  -244,
     1  -247,  -248,  -247,  -244,  -239,  -233,  -226,  -216,  -206,
     2  -193,  -179,  -164,  -148,  -130,  -110,  -090,  -069,  -048,
     3  -026,  -004,   018,   040,   062,   084,   105,   124,   141,
     4   157,   172,   185,   199,   213,   226,   237,   247,   255,
     5   261,   265,   267,   268,   267,   265,   262,   257,   251,
     6   243,   234,   224,   213,   202,   191,   180,   169,   157,
     7   145,   133,   121,   108,   094,   079,   064,   048,   030,
     8   012,  -006,  -025,  -043,  -060,  -076,  -090,  -104,  -116,
     9  -127,  -137,  -146,  -154,  -161,  -166,  -171,  -175,  -178,
     a  -179,  -180,  -179,  -176,  -170,  -164,  -158,  -150,  -142,
     b  -134,  -125,  -113,  -101,   -86,   -70,   -53,   -36,   -20,
     c    -3,    12,    28,    43,    58,    71,    84,    95,   104,
     d   111,   117,   122,   127,   133,   137,   141,   145,   150,
     e   154,   157,   158,   158,   157,   156,   154,   152,   149,
     f   146,   142,   137,   131,   123,   116,   108,   100,    94,
     g    89,    83,    77,    71,    64,    55,    45,    34,    22,
     h     8,    -8,   -22,   -33,   -44,   -53,   -61,   -68,   -74,
     i   -78,   -82,   -84,   -85,   -85,   -84,   -82,   -80,   -75/
      integer*2 y7880(168)/   160,   180,   200,   220,   240,   261,
     1   282,   301,   321,   339,   356,   373,   390,   405,   418,
     2   429,   439,   446,   455,   463,   470,   477,   482,   486,
     3   487,   487,   486,   483,   480,   475,   468,   460,   452,
     4   443,   433,   421,   410,   399,   387,   374,   361,   348,
     5   334,   318,   301,   283,   265,   247,   229,   211,   193,
     6   176,   159,   143,   128,   114,   102,   092,   083,   076,
     7   070,   065,   061,   058,   055,   053,   052,   054,   057,
     8   060,   064,   070,   078,   087,   097,   108,   120,   133,
     9   147,   161,   174,   187,   200,   213,   225,   237,   249,
     a   260,   271,   282,   293,   305,   317,   328,   339,   349,
     b   359,   368,   376,   383,   390,   396,   402,   407,   411,
     c   415,   418,   420,   420,   419,   418,   417,   414,   410,
     d   406,   402,   398,   393,   387,   381,   374,   365,   354,
     e   343,   332,   321,   309,   299,   289,   279,   270,   260,
     f   251,   242,   234,   226,   218,   210,   203,   197,   191,
     g   186,   182,   178,   175,   175,   176,   178,   181,   184,
     h   188,   193,   198,   204,   210,   217,   224,   230,   236,
     i   242,   247,   252,   257,   262,   266,   270,   273,   276/
c        tabular points from  2444420  to  2444515 (julian day numbers)
c        (june 29, 1980  to  october 2, 1980  0 hr)
c     integer*2 x8082( 20)/   -71,   -64,   -59,   -53,   -48,   -42,
c     integer*2 y8082( 20)/   279,   282,   285,   289,   293,   296,
c           rapid service values 2444520 to 2444565 (julian day numbers)
c           (october 7, 1980  to  november 21, 1980,  0 hr)
      integer*2 x8082( 30)/   -71,   -64,   -59,   -53,   -48,   -42,
     1   -37,   -32,   -27,   -23,   -18,   -15,   -11,    -8,    -4,
     2    -1,     2,     6,     9,    10,
     3    21,    16,    11,     7,     2,     2,    -2,    -7,   -12,
     4    -9/
      integer*2 y8082( 30)/   279,   282,   285,   289,   293,   296,
     1   299,   301,   304,   307,   310,   313,   315,   317,   320,
     2   323,   326,   329,   334,   339,
     4   320,   325,   330,   337,   347,   357,   367,   376,   381,
     5   386/
 
      equivalence (xc, x6971), (xc(169), x7173),
     .            (xc(337), x7375), (xc(505), x7578),
     .            (xc(673), x7880), (xc(841), x8082)
      equivalence (yc, y6971), (yc(169), y7173),
     .            (yc(337), y7375), (yc(505), y7578),
     .            (yc(673), y7880), (yc(841), y8082)
c
c$$$$$ extend table when routine revised from bih  final values
c
c$$$  julian day number of given calendar date =
c$$$                   = julian date at midnight beginning of day + 0.5
c$$$                   = mjd + 2400001 (mjd=usno modified julian date)
c
c      - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c
c        wobble is taken from subroutine xwobbl  (extrapolation)
c           test on final jd - 5  of final bih values
      if(jd.ge.2444510) then
 
c test on final jd - 5  of rapid service values
         if(jd.ge.2444560) then
c$$$$$ date to be extended when routine revised
c
            if(.not.nxtrp) then
               write(Iout, 10) jd
   10          format(i17,
     .' WARNING:  WOBBLE BEING EXTRAPOLATED BEYOND END OF BIH TABLE ***'
     .)
               nxtrp = .true.
               Line  = Line + 1
            endif
            call XWOBBL(jd, frw, x, y)
            return
 
c warning message for use of rapid service values
         else if(.not.(lxtrp)) then
            write(Iout, 20) jd
   20       format(i17,
     . ' WARNING:  WOBBLE INTERPOLATION USING RAPID SERVICE VALUES ***'
     . )
            Line  = Line + 1
            lxtrp = .true.
         endif
      endif
c
c set up indices for  5 days b.i.h. interpolation
      tt  = ((jd-2440220) + frw)/5._10
      int = tt
      t   = tt - int
c
c second difference interpolation
      t2 = t*t
      s  = 1._10 - t
      s2 = s*s
      do j = 1, 2
         do i = 1, 2
            nr    = int + i
            f1    = cc(nr, j)
            f2    = 0.1666667E0*(cc(nr+1,j) + cc(nr-1,j))
            y1(i) = 1.3333333E0*f1 - f2
            y2(i) = -0.3333333E0*f1 + f2
            end do
         result(j) = t*(y1(2) + t2*y2(2)) + s*(y1(1) + s2*y2(1))
         end do
c diurnal polar motion now calculated in radctl and ferctl
c using vlbi3 routines
c
c
      x = result(1)*1.0E-03
      y = result(2)*1.0E-03
 
      return
      end
