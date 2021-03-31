      program prepmnpt

C         PROGRAM TO WRITE OBSLIB TAPE FROM LASER NORMAL POINTS
C
C   R.KING  SEPT 1975  -RETYPED FROM LINCOLN LISTING OF 26 NOV 76
C   MODIFIED APRIL 22 BY PJM TO ACCOUNT FOR K' ERROR OF 1.4 NANO LATE
C       1975.   OCT75 THRU FEB 76
C   MODIFIED SEPT 1987 TO READ NEW MINI-NORMAL-POINTS
C       AND TO COMPILE UNDER FORTRAN 77
c   modified 2008 May 5 to use obsio for output
c   modified 2012 Mar 8/12 to handle CSTG format
c   modified 2012 Nov 6 to allow additional error component
c input file on fortran unit 5:
c 1) title card
c 2) ntape (8x,i4)
c 3-n) various formats, depending on the first character.
c     ' ' - end of series. must be followed by INPUT1 namelist, specifying
c           next series name and number
c     '5' - mini-normal-point (one card). must be sorted into series
c           with same observing site and target and century
c     'Z' - old normal point format
c     '9' - CSTG format
c     'SER' - specifies the series name for the next series, cols 5-8
c     'RSS' - specifies an error component (in ps) to be added in
c             quadrature to the quoted values from here on, cols 5-8
C
      implicit none

      include 'pepglob.inc'

C        COMMON
      include 't1a.inc'
      include 't2a.inc'
      INTEGER*4 ZT2A/10096/
      include 't3a.inc'
      INTEGER*4 ZT3A/11124/
      include 't4a.inc'
      INTEGER*4 ZT4A/18638/

      CHARACTER*1 REC,DQUAL,VERSN
      CHARACTER*80 BUF80
C
      INTEGER*2 NCODZ/0/,SVTIME,IYR2,ITIME,ITIMF/3/,ONEI2/1/,IDUM2
C
      INTEGER*4 ELECDL,FDEVS,GEOMDL,HUM,I,IC,ICLOCK,IDATE1,IDATE2,IDRK,
     . IENERG,IEOF,IERR,IFREQ,IMNR,INDIC,IPRES,IPULSE,IRES,ISNR,ISPAT,
     . ISPEC,ISPOT,ISTA,ISTAXX,ISTR,ITEMP,ITIME1,ITIME2,IYEAR4,J,LAMDA,
     . LCOLOR,NSHOT,NUMSHT,OBSTYP,RCODE,SEEING,STARID,TYPE,WIND,IDELAY,
     . IERRPAS,ICSTG,ITERM/6/,IPRINT/8/,IN/5/,IABS2/2/
C EXTERNAL FUNCTIONS
      INTEGER*4 JULDAY
C
      REAL*10 JD,JD0,FRACT,DELAY,GD,ED,RESLT1,FDEVX,PRES,SVFREQ,
     . TEMP,UTREC,LTVEL/2.99792458E8_10/,DSEC,SHOTSQ
      REAL*4 CLKERR,ENERGY,FREQZ,ERRINC/0./

      CHARACTER*8 DATE(3),CERGA,SVSITE,MAU1,MAU2/'MAU2MLT'/
      INTEGER*4 STACD(9)/   71110,   71111,   71112,   01910,   70610,
     .     -1,   56610,   2*1/
      INTEGER*4 STASOD(9)/     -1,      -1,70802419,78457801,70459501,
     . 79417701,  3*1/
      CHARACTER*8 STN(9)/  'TEXL',  'MLRS',  'MLR2', 'CERGA','ApachePt',
     . 'MLRO', 'MAU1SLR', 2*' '/
      EQUIVALENCE (CERGA,STN(4)),(MAU1,STN(7))

C
      CHARACTER*4 REFL(0:4)/'AP11','LUN1','AP14','AP15','LUN2'/,
     . SPOT1,SVSPOT
C
      NAMELIST /INPUT1/ NSEQA,IABS2,SERA,RITA,ACCTMA,SPOTA,FDEVA,FREQA,
     1                  SITA
C
C INITIALIZATION
      CALL ZFILL(JDGS0A,ZT2A)
      CALL ZFILL(RITA,ZT3A)
      CALL ZFILL(RESLTA,ZT4A)
      ACCTMA=1E-12
      ERWGTA(1)=1.
      ERWGTA(2)=1.
      FDEVA=-300.
      FREQA=4.3178E14_10
      LNKLVA='PREP'
      NCENTA=3
      NCODFA=1
      NOBCNA=2
      NPLNTA=10
      NUM1A=1
      PNAMA='  MOON  '
      RITA='TEXL    '
      SITA='TEXL    '

      ICSTG=0
      IEOF=-1
      INDIC=-1
      SVFREQ=-1._10
      SVTIME=-999

C         READ TITLE, DATE, AND NTAPE
C         WRITE TYPES 1 AND 2 RECORDS ON OBSLIB
C
      R1A(1)='PREPMNPT'
      READ(IN,100) (R1A(I),I=2,10)
  100 FORMAT(9A8)
      READ(IN,110) NTAPA
C     NTAPE IN COLUMNS 11 AND 12
  110 FORMAT(8X,I4)

      CALL TODAY(DATE)
      R1A(11)=DATE(1)
      WRITE(ITERM,120) R1A
      WRITE(IPRINT,120) R1A
  120 FORMAT( ' RECORD 1    TITLE: ',10A8/
     1        '             DATE:  ',A8/)
      TYPE=1
      CALL OBSIO(0,IABS2,TYPE,1,IC)
      IF(IC.NE.1) GOTO 950
      WRITE(IPRINT,130) NTAPA,NPG2A,ITRTA
  130 FORMAT(' RECORD 2    NTAPE=',I4,'   NPAGE=',I4,
     1  '   ITERAT=',I4,'    1420 I*2 ZEROS '//)
      TYPE=2
      CALL OBSIO(0,IABS2,TYPE,1,IC)
      IF(IC.NE.1) GOTO 950
C-----------------------------------------------------------------------
C
C
C         READ INPUT NORMAL POINT RECORDS
C
  400 READ(IN,401,END=610) BUF80
  401 FORMAT(A80)
      IF(BUF80(1:3).EQ.'SER') THEN
         SERA=BUF80(5:8)
         ICSTG=0
         GOTO 400
      ELSE IF(BUF80(1:3).EQ.'RSS') THEN
         READ(BUF80,'(4X,12PF4.0)') ERRINC
         GOTO 400
      ENDIF
      IF(BUF80(1:1).EQ.' ') GOTO 600
      IEOF=-1
      IF(BUF80(1:5).EQ.'88888') THEN
C SKIP CSTG ENGINEERING HEADER AND DATA
         READ(IN,401,END=610)
         ICSTG=-1
         GOTO 400
      ENDIF
      IF(BUF80(1:5).EQ.'99999') GOTO 480
      IF(ICSTG.EQ.1) GOTO 485
      IF(ICSTG.EQ.-1) GOTO 400
      IF(BUF80(1:1).EQ.'5') GOTO 440
      IF(BUF80(1:1).EQ.'Z') GOTO 405
C
      WRITE(ITERM,402) BUF80
      WRITE(IPRINT,402) BUF80
  402 FORMAT(1X,'UNIDENTIFIED CARD AT 401:'/A80 )
      GOTO 400
C
C
C          READ Z CARD
C
  405 READ(BUF80,406) REC,ISTA,JD0,ICLOCK,ITEMP,HUM,WIND,
     1             SEEING,IENERG,IFREQ,IPULSE,IRES,
     2             IDRK,IMNR,ISTR,STARID,ISPEC,ISPAT,
     3             NUMSHT,IYEAR4,IMNTHA,IDAYA
  406 FORMAT(A1,I3,D10.3,   I8,I3,3I2,3X,I3,I5,5I3,A5,
     1       2I3,2I4,2I2)
C
C        READ P CARD
C
      READ(IN,420) REC,ISPOT,JDA,FRACT,ISTAXX,RCODE,OBSTYP,
     1             ITIME1,DELAY,IERR,ELECDL,GEOMDL,NSHOT,FDEVS,
     2             ITIME2,IPRES,IYEAR4,IMNTHA,IDAYA
  420 FORMAT(A1,I3,I7,D10.10,I5,1X,I1,A1,I1,D12.10,I5,I6,I5,
     1        I3,I5,I1,I5,I4,2I2)
      IF(REC.EQ.'P' .OR. REC.EQ.'N') GOTO 425
      WRITE(ITERM,422) REC,ISPOT,IYEAR4,IMNTHA,IDAYA
      WRITE(IPRINT,422) REC,ISPOT,IYEAR4,IMNTHA,IDAYA
  422 FORMAT(1X,'NORMAL PT MISSING AT 420, DATA IS',
     1           A1,I3,' ... ',I4,2I2)
      GOTO 400
  425 IDATE2= IYEAR4*10000 + IMNTHA*100 + IDAYA
C     CHECK FOR SHOT WITHIN 42 MIN OF START OF RUN
      JD= JDA + FRACT
C     TEMPORARY FIX:  CHECK FOR SHOT WITHIN 144 MIN OF START OF RUN
      IF(ABS(JD0-JD) .LT. 0.1_10) GOTO 430
      WRITE(ITERM,428) IDATE1,IDATE2
      WRITE(IPRINT,428) IDATE1,IDATE2
  428 FORMAT(1X,'DATE DISCREPANCY, IDATE1=',I10,'  IDATE2='
     1       ,I10,'   POINT SKIPPED')
      GOTO 400
  430 CLKERR= ICLOCK*1.E-6
      ENERGY= IENERG*1.E-6
      TEMP = ITEMP
      PRES = IPRES*0.1_10
C     FREQ FROM Z-CARD NOT USED
      FREQZ= IFREQ*1.E+10
C**   TEMPORARY FIX FOR TEXAS ERROR IN RECORDING LASER FREQUENCY
      IF(FREQA.LT.2E14_10) FREQA= FREQA*10._10
      SITA=RITA
      IF(IYEAR4.GE.1972) FDEVA=0.
      SPOT1= REFL(RCODE)
      IF(SPOT1.EQ.SPOTA) GOTO 435
      WRITE(ITERM,434) SPOT1,SPOTA,IDATE2,JD
      WRITE(IPRINT,434) SPOT1,SPOTA,IDATE2,JD
  434 FORMAT(1X,' SPOT1 ',A4,' .NE. SPOT',1X,A4,' AT ',I10,7PD20.4,
     1  'POINT SKIPPED')
      GOTO 400
  435 ERRORA(1)= IERR*1E-10
C     TEMPORARY PATCH FOR CERGA DATA WITH NO ASSIGNED ERRORS
      IF(RITA.EQ.CERGA .AND. ERRORA(1).EQ.0)
     1       ERRORA(1)= (.4+12./NSHOT)*1.E-9
      IF(ERRINC.NE.0.) ERRORA(1)=SQRT(ERRORA(1)**2+ERRINC**2)
C     THIS PATCH TO MODIFY ELECTRONIC DELAY
      IF(JD .GT. 2442720.  .AND. JD .LT. 2442840.)
     1  ELECDL = ELECDL - 0.1167*(JD-2442720.)
      ED= ELECDL*1.E-10_10
      GD= GEOMDL*1.E-10_10
      RESLT1= DELAY - ED - GD
      FDEVX= FDEVS*1.E-11_10
      RESLTA(1)= RESLT1*(1._10 - FDEVX)
      FRACT= FRACT + .5_10
      IF(FRACT.GE.1._10) THEN
         FRACT= FRACT - 1._10
         JDA= JDA + 1
      ENDIF
      UTREC= FRACT*8.64E4_10
      IHRA= (UTREC + 1.E-3_10)/3600._10
      IMINA= (UTREC + 1.E-3_10 - 3600._10*IHRA)/60._10
      DSEC= UTREC - 3600*IHRA - 60*IMINA
      DSEC= DSEC + CLKERR
      ITIME=IYEAR4/100-19
      IYEARA= MOD(IYEAR4,100)
      GOTO 450
C
C
C         READ MINI-NORMAL-POINT CARD
C
  440 READ(BUF80,441) REC,LCOLOR,IYEAR4,IMNTHA,IDAYA,IHRA,IMINA,DSEC
     1              , DELAY,RCODE,ISTA,NSHOT,IERR,ISNR,DQUAL
     2              , IPRES,ITEMP,HUM,LAMDA,VERSN
  441 FORMAT( A1,I1,I4,4I2,D9.7,D14.13,I1,I5,I3,I6,I3,A1,I6,1X
     1      , I3,I2,I5,A1 )
C
      ITIME=IYEAR4/100-19
      IYEARA= MOD(IYEAR4,100)
      IYR2=IYEARA+ITIME*100
      JDA= JULDAY(IMNTHA,IDAYA,IYR2)
  444 JD = JDA + IHRA/24._10 + IMINA/1440._10 + DSEC/86400._10 - 0.5_10
      DO I=1,9
         IF(ISTA.EQ.STACD(I) .OR. ISTA.EQ.STASOD(I) .OR.
     .    ISTA.EQ.STASOD(I)/10000) THEN
            RITA=STN(I)
            SITA=RITA
            IF(SITA.EQ.MAU1) RITA=MAU2
            GOTO 442
         ENDIF
      END DO
      GOTO 970
  442 SPOTA= REFL(RCODE)
      ERRORA(1)= IERR*1E-13
      IF(ERRINC.NE.0.) ERRORA(1)=SQRT(ERRORA(1)**2+ERRINC**2)
      PRES= IPRES*1E-2_10
      TEMP= ITEMP*1E-1_10
      FREQA= LTVEL/(LAMDA*1E-10_10)
      RESLTA(1)= DELAY
      ED = 0._10
      GD = 0._10
      CLKERR = 0.
C
C SEE IF SERIES CONTINUES
  450 IF(SVFREQ.EQ.FREQA .AND. SVSPOT.EQ.SPOTA .AND. SVTIME.EQ.ITIME
     . .AND. SVSITE.EQ.RITA) GOTO 350
      FDEVA=-300.
      IF(IYEAR4.GE.1972) FDEVA=0.
C
  300 CONTINUE
      IF(INDIC.GE.0) THEN
C           WRITE NULL TYPE 4 FROM PREVIOUS SERIES
         TYPE=4
         CALL OBSIO(0,IABS2,TYPE,2,IC)
         IF(IC.NE.1) GOTO 950
         INDIC=-1
      ENDIF
C
C           SET UP FOR NEW SERIES
      IF(IEOF.GT.0) GOTO 999
      IF(IEOF.EQ.-1) NSEQA=NSEQA+10
      NCODEA=1
      NUMPRA=2
      ITIMA=ITIME
      IF(ITIMA.GT.0) ITIMA=10*ITIMA+ITIMF
      IF(ITIMA.EQ.0 .AND. IYEARA.GT.60) ITIMA=ITIMF

      SVFREQ=FREQA
      SVSPOT=SPOTA
      SVTIME=ITIME
      SVSITE=RITA

C         WRITE TYPE 3 RECORD ON OBSLIB
C
      TYPE=3
      CALL OBSIO(0,IABS2,TYPE,1,IC)
      IF(IC.NE.1) GOTO 950
C
      WRITE(IPRINT,310) SERA,NSEQA,NCODFA,NPLNTA,RITA,SITA,SPOTA,
     1             ERWGTA,ACCTMA,FDEVA,FREQA,
     2       ITIME,NREWNA,NPG3A,PNAMA,NCENTA,NOBCNA,(OBSCNA(I),I=1,2)
  310 FORMAT(///' RECORD 3    SERIES',1X,A4,'   NSEQ=',I4,
     1  '   NCODF=',I2,'   NPLNT=',I2,'   SITE1=',A8,
     2  '   SITE2=',A8,/,10X,'   SPOT=',A4,'   ERRWGT=',
     3  1P2E9.2,'  ACCTIM=',E8.2,'   FDEV=',0PF6.1,/,10X,
     4  '   FREQ=',1PD22.15,' ITIME=',I2,
     5  '   NREWND=',I2,'  NPAGE=',I4,'  PLANET=',A8,/,10X,
     6  '   NCENTB=',I2,' 355 I*2 ZEROS   NOBCON=',
     7  I2,'  OBSCON(1-2)=',2D8.0,' 1775 I*4 ZEROS'/)
      WRITE(IPRINT,320)
  320 FORMAT(/' JULIAN DATE   DATE   HR MIN SECONDS    CLKERR',
     1         '  DELAY         N    ELECDL ',
     2       ' GEOMDL  TEMP  PRES  HUM  ERROR'/)
      INDIC=0
      IF(IEOF.EQ.0) GOTO 400

C
C         COMPUTE QUANTITIES FOR PEP TYPE 4 DATA RECORD
C
  350 SECA= DSEC
      SAVA(40)= DSEC
C     PEP UNITS OF ATMOSPHERE PARAMETERS ARE DEG KELVIN, MBAR,
C     AND PERCENT/100
      SAVA(41)= TEMP + 273.15
      SAVA(42)= PRES
      SAVA(43)= HUM/100.
      SAVA(44)= SAVA(41)
      SAVA(45)= SAVA(42)
      SAVA(46)= SAVA(43)
      NSAVA=46
      JDSA=JDA
C
C         PRINT OUT DATA AND WRITE TYPE 4 RECORD
C
      WRITE(IPRINT,460) JD,IMNTHA,IDAYA,IYEARA,IHRA,IMINA,SECA,CLKERR,
     1             DELAY,NSHOT,ED,GD,(SAVA(I),I=41,43),ERRORA(1)
  460 FORMAT(1X,F11.3,3I3,I4,I3,1X,F9.6,1X,1PE8.1,
     1       1X,0PF12.10,I3,1X,1PD8.1,D9.2,1X,
     2       0PF5.0,F6.1,F5.2,1PE10.2)
      TYPE=4
      CALL OBSIO(0,IABS2,TYPE,1,IC)
      IF(IC.NE.1) GOTO 950
      INDIC=INDIC+1
      GOTO 400
C
C         READ CSTG RECORDS
C
  480 ICSTG=1
      READ(IN,481) RCODE,IYEARA,IDAYA,ISTA,LAMDA,IERR,DQUAL,VERSN,
     . BUF80
  481 FORMAT(6X,I1,I2,I3,I8,I4,23X,I4,A1,2X,A1/ A80)
      IF(IYEARA.GT.60) THEN
         ITIME=0
      ELSE
         ITIME=1
      ENDIF
      IYR2=IYEARA+ITIME*100
      IYEAR4=1900+IYR2
      JDA=JULDAY(ONEI2,ONEI2,IYR2)+IDAYA-1
      CALL MDYJUL(IMNTHA,IDAYA,IDUM2,ITIME,JDA)
      IF(LAMDA.LT.3000) LAMDA=LAMDA*10
      IERRPAS=IERR*10
  485 READ(BUF80,486) DSEC,DELAY,IERR,IPRES,ITEMP,HUM,NSHOT,IDELAY,ISNR
  486 FORMAT(F12.7,F12.12,I7,I5,I4,I3,I4,1X,I1,1X,I2)
      IHRA=DSEC/3600
      DSEC=DSEC-IHRA*3600
      IMINA=DSEC/60
      DSEC=DSEC-IMINA*60
      DELAY=DELAY+IDELAY
      IPRES=IPRES*10
      ITEMP=ITEMP-2732
      SHOTSQ=NSHOT
      IF(NSHOT.GE.1) THEN
         SHOTSQ=SQRT(SHOTSQ)
      ELSE
         SHOTSQ=1
      ENDIF
      IERR=IERR*10/SHOTSQ
      IF(NSHOT.LE.1 .OR. IERR.LE.0) IERR=IERRPAS
      GOTO 444
C
C         ABNORMAL TERMINATIONS
C
C         WRITE ZERO RECORD FOR END OF SERIES
  600 CONTINUE
C         READ NAMELIST &INPUT1 FOR NEXT SERIES
C
      READ(IN,INPUT1,END=610)
      IEOF=0
      GOTO 300
  610 IEOF=1
      GOTO 300
C ERROR IN OBSIO
  950 WRITE(IPRINT,960) IC,TYPE
  960 FORMAT(' ERROR IN OBSIO, WRITING TYPE',I2,' RECORD. IORTRN=',I3)
      STOP
C UNKNOWN SITE CODE
  970 WRITE(IPRINT,980) ISTA
  980 FORMAT(' UNKNOWN SITE CODE',I6)
  999 STOP
      END
