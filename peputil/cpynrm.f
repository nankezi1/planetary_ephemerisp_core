      PROGRAM CPYNRM
 
      IMPLICIT NONE
 
C CPYNRM - J.F.CHANDLER - 1992 JULY
C
C COPY SAVED NORMAL EQUATIONS OR SOLUTIONS FROM UNIT 11 TO UNIT 21
C
C INPUT CONTROLS:  UNIT 5 NAMELIST 'INPUT'
C     CRDIN = T IF INPUT FILE IS IN CARD-IMAGE FORMAT (DEFAULT=F)
C     CRDOUT= T IF OUTPUT FILE IS TO BE IN CARD-IMAGE FORMAT (DEF=F)
C     OLDSIT= T IF OUTPUT FILE IS TO HAVE ONLY 3 COORDS PER SITE (DEF=F)
C     STOP  = T IF OUTPUT SHOULD STOP AFTER HEADERS (DEF=F)
C     EIGEN = T IF PROGRAM IS TO PRINT MATRIX EIGENVALUES INSTEAD OF
C               COPYING (DEF=F)
 
      INTEGER*4 NMPRM,NMBOD
      PARAMETER (NMPRM=100,NMBOD=30)
      INTEGER*2 ICREST(1000),ICT(80),IDREST(1000),
     . KSCRD(100),LCHAR(209),LDT(600),LEQN(3,400),
     . LPHS(9,200),LPL(NMBOD),LPRM(100),LPSRCN(16,10),LRBS(2,200),
     . LSCRD(6,100),LSHAPE(1000),LSHAR(209),LSKYCF(80,10),
     . LSPCRD(3,100),LZHAR(1000),NCENTR,NCPHS(200),NPLNT,
     . NPLPHS(200),NPLRBS(200),NSHAP(10),NSHP2X,NSITCR,NSKYCF(10),
     . NSPLNT(100),NTESS,NTESS1,NTYPSR(10),NUMDT,NUMDT1,NUMEQN,
     . NUMPHR,NUMPHS,NUMPH2,NUMPLN,NUMPSR,NUMRBS,NUMSIT,NUMSPT,
     . NUMSTR,NZONE,NZONE1,NSITCO,NSITCSV
 
      INTEGER*4 I,IAPRIO,IPPR,ITERAT,IVECTK,J,JDDT(600),JDDT0,
     . JDPSR0(10),JD0,LATDIM,LONDIM,MESMT,M2,N,NAUXPP,NCNMX,NCPARM,
     . NDPARM,NGD,NGD2,NMAX,NPAGE,NPARAM,NPARM,NPRMX,NSEQ,NSERPP,
     . NTAPE,NUMP4
 
      REAL*10 BUFF(2000),CHAR(209),COND(NMBOD),ERMES(3),PLSPR(10),
     . PRMTER(100),PSRCN(16,10),SCORD(6,100),SHAR(209),SKYCF(80,10),
     . SPCORD(3,100),T0SIT(100),ZHAR(500),ZNSQPP,ZNSQSN,ZSMPP,ZSMSN
 
      REAL*4 APHASE(9,200),DEQ(3,400),DT(600),
     . ERWGT(2),RBIAS(2,200),SCNTL(6),SHAPE(1000)
 
      CHARACTER*8 CTLG(10),NAME,TITLE(11)
 
      CHARACTER*4 EQNSER(400),EQNSIT(400),LNKLVL,PHSER(200),
     . PHSIT(200),RDBSER(200),RDBSIT(2,200),SITE(2,100),SPOT(100),
     . SPTPSR(10)
 
      LOGICAL*4 CRDIN,CRDOUT,EIGEN,OLDSIT,STOP
 
      EQUIVALENCE (BUFF,APHASE,DEQ,RBIAS,SCORD,SPCORD,SKYCF,ZHAR,SHAPE),
     .            (ZHAR(25),CHAR),(ZHAR(234),SHAR),
     .            (LSHAPE,LZHAR),(LZHAR(25),LCHAR),(LZHAR(234),LSHAR)
 
      REAL*8 ZERO(25)/25*0D0/
      INTEGER*4 IMATI/11/, IMATS/21/
      CHARACTER*4 EXTP,EXTPO/' EXT'/
 
      NAMELIST/INPUT/ CRDIN, CRDOUT, EIGEN, OLDSIT, STOP
C
      CRDIN = .FALSE.
      CRDOUT= .FALSE.
      EIGEN = .FALSE.
      OLDSIT= .FALSE.
      STOP  = .FALSE.
C
      READ(5,INPUT,END=10)
   10 CONTINUE
 
      CALL ZFILL(LDT,2*600)
      IF(CRDIN) THEN
         READ(IMATI,100) TITLE,LNKLVL,JDDT0,PRMTER(1),EXTP,NPRMX,NCNMX
  100    FORMAT(10A8/ A8,A4,I10,1PD25.17,A4,2I4)
         IF(NPRMX.LT.100) NPRMX=100
         IF(NCNMX.LT.30) NCNMX=30
         IF(EXTP.EQ.EXTPO) THEN
            READ(IMATI,101) (PRMTER(I),I=1,NPRMX)
  101       FORMAT(1PD26.19/(3D26.19))
         ELSE
            READ(IMATI,102) (PRMTER(I),I=2,100)
  102       FORMAT(1P3D25.17)
         ENDIF
         READ(IMATI,103) (LPRM(I),I=1,NPRMX)
  103    FORMAT(20I4)
         READ(IMATI,104) ICT,
     .    NPARAM,ITERAT,NPAGE,NUMPLN,NUMPHR,NUMSIT,NUMSPT,
     .    NUMSTR,NUMPSR,NUMRBS,NUMEQN,NUMPHS,NUMDT,NUMDT1,
     .    NUMPH2,IPPR,NSITCR,(DT(I),JDDT(I),LDT(I),I=1,NUMDT1)
  104    FORMAT(5(16I5/), 15I5/ 2I5/ (2(4X,E17.9,I10,I5)))
         READ(IMATI,105) (NSHAP(I),I=1,NUMPH2)
  105    FORMAT(16I5)
      ELSE
         READ(IMATI) TITLE
C           READ(IMATI) PRMTER,LPRM,ICT,NPARAM,ITERAT,NPAGE,
C    .            NUMPLN,NUMPHR,NUMSIT,NUMSPT,NUMSTR,NUMPSR,
C    .            NUMRBS,NUMEQN,NUMPHS,NUMDT,NUMDT1,
C    .            (DT(I),JDDT(I),LDT(I),I=1,NUMDT1),IPPR,
C    .            NUMPH2,NSHP2X,(NSHAP(I),I=1,6),JDDT0,LNKLVL
         READ(IMATI) NPRMX,NCNMX,(PRMTER(I),I=1,NPRMX),
     .    (LPRM(I),I=1,NPRMX),ICT,NPARAM,ITERAT,NPAGE,
     .    NUMPLN,NUMPHR,NUMSIT,NUMSPT,NUMSTR,NUMPSR,
     .    NUMRBS,NUMEQN,NUMPHS,NUMDT,NUMDT1,
     .    (DT(I),JDDT(I),LDT(I),I=1,NUMDT1),IPPR,
     .    NUMPH2,NSHP2X,(NSHAP(I),I=1,NUMPH2),
     .    JDDT0,LNKLVL,NSITCR
      ENDIF
      NSHP2X = -1
      NUMPH2 = NUMPHR+2
      DO I=NPRMX+1,NMPRM
         PRMTER(I)=0._10
         LPRM(I)=0
      END DO
      IF(NUMDT.EQ.0) LDT(1)=0
      CALL DTCHCK(JDDT0,NUMDT,NUMDT1,DT,LDT)
      NSITCSV=NSITCR
      IF(NSITCR.LE.0) NSITCR=3
      NSITCO=NSITCR
      IF(OLDSIT) NSITCO=3
      IF(.NOT.EIGEN) THEN
         IF(CRDOUT) THEN
            WRITE(IMATS,99100) TITLE,LNKLVL,JDDT0,EXTPO,NPRMX,NCNMX
99100       FORMAT(10A8/ A8,A4,I10,25X,A4,2I4)
            WRITE(IMATS,101) (PRMTER(I),I=1,NPRMX)
            WRITE(IMATS,103) (LPRM(I),I=1,NPRMX)
            WRITE(IMATS,104) ICT,
     .         NPARAM,ITERAT,NPAGE,NUMPLN,NUMPHR,NUMSIT,NUMSPT,
     .         NUMSTR,NUMPSR,NUMRBS,NUMEQN,NUMPHS,NUMDT,NUMDT1,
     .         NUMPH2,IPPR,NSITCO,(DT(I),JDDT(I),LDT(I),I=1,NUMDT1)
            WRITE(IMATS,105) (NSHAP(I),I=1,NUMPH2)
         ELSE
            WRITE(IMATS) TITLE,LNKLVL
            WRITE(IMATS) NMPRM,NMBOD,PRMTER,LPRM,
     .       ICT,NPARAM,ITERAT,NPAGE,
     .       NUMPLN,NUMPHR,NUMSIT,NUMSPT,NUMSTR,NUMPSR,
     .       NUMRBS,NUMEQN,NUMPHS,NUMDT,NUMDT1,
     .       (DT(I),JDDT(I),LDT(I),I=1,NUMDT1),IPPR,
     .       NUMPH2,NSHP2X,(NSHAP(I),I=1,NUMPH2),JDDT0,LNKLVL,
     .       NSITCO,ZERO
         ENDIF
      ENDIF
C
C PLANET INITIAL CONDITIONS AND PARAMETERS
      NUMP4 = NUMPLN+4
      DO J=1,NUMP4
         IF(CRDIN) THEN
            IF(EXTP.EQ.EXTPO) THEN
               READ(IMATI,300) NPLNT,NCENTR,JD0,NAME,(COND(I),I=1,NCNMX)
  300          FORMAT(2I5,I10,1X,A8/ (1P,3D26.19))
            ELSE
               READ(IMATI,301) NPLNT,NCENTR,JD0,NAME,(COND(I),I=1,NCNMX)
  301          FORMAT(2I5,I10,1X,A8/ (1P,3D25.17))
            ENDIF
            READ(IMATI,302) (LPL(I),I=1,NCNMX)
  302       FORMAT(15I5)
         ELSE
            READ(IMATI) NPLNT,NCENTR,JD0,(COND(I),I=1,NCNMX),
     .       (LPL(I),I=1,NCNMX),NAME
         ENDIF
         DO I=NCNMX+1,NMBOD
            COND(I)=0._10
            LPL(I)=0
         END DO
         IF(.NOT.EIGEN) THEN
            IF(CRDOUT) THEN
               WRITE(IMATS,300) NPLNT,NCENTR,JD0,NAME,COND
               WRITE(IMATS,302) LPL
            ELSE
               WRITE(IMATS) NPLNT,NCENTR,JD0,COND,LPL,NAME
            ENDIF
         ENDIF
      END DO
C
C WRITE PLANET HARMONICS OR SHAPE MODELS
      DO 320 J = 1,NUMPH2
         IF(NSHAP(J).LE.0) THEN
C
C SPHERICAL HARMONICS
            IF(CRDIN) THEN
               IF(EXTP.EQ.EXTPO) THEN
                  READ(IMATI,311) NPLNT,NZONE,NZONE1,NTESS,NTESS1,
     .             (ZHAR(I),LZHAR(I),I=1,NZONE1),
     .             (CHAR(I),LCHAR(I),I=1,NTESS1),
     .             (SHAR(I),LSHAR(I),I=1,NTESS1)
  311             FORMAT(5I5/ (2(1PD26.19,I3)))
               ELSE
                  READ(IMATI,312) NPLNT,NZONE,NZONE1,NTESS,NTESS1,
     .             (ZHAR(I),LZHAR(I),I=1,NZONE1),
     .             (CHAR(I),LCHAR(I),I=1,NTESS1),
     .             (SHAR(I),LSHAR(I),I=1,NTESS1)
  312             FORMAT(5I5/ (3(1PD24.17,I2)))
               ENDIF
            ELSE
               READ(IMATI) NPLNT,NZONE,NZONE1,
     .           (ZHAR(I),I=1,NZONE1),(LZHAR(I),I=1,NZONE1),
     .           NTESS,NTESS1,(CHAR(I),I=1,NTESS1),
     .           (LCHAR(I),I=1,NTESS1),(SHAR(I),I=1,NTESS1),
     .           (LSHAR(I),I=1,NTESS1)
            ENDIF
            IF(.NOT.EIGEN) THEN
               IF(CRDOUT) THEN
                  WRITE(IMATS,311) NPLNT,NZONE,NZONE1,NTESS,NTESS1,
     .             (ZHAR(I),LZHAR(I),I=1,NZONE1),
     .             (CHAR(I),LCHAR(I),I=1,NTESS1),
     .             (SHAR(I),LSHAR(I),I=1,NTESS1)
               ELSE
                  WRITE(IMATS) NPLNT,NZONE,NZONE1,
     .             (ZHAR(I),I=1,NZONE1),(LZHAR(I),I=1,NZONE1),
     .             NTESS,NTESS1,(CHAR(I),I=1,NTESS1),
     .             (LCHAR(I),I=1,NTESS1),(SHAR(I),I=1,NTESS1),
     .             (LSHAR(I),I=1,NTESS1)
               ENDIF
            ENDIF
 
         ELSE IF(NSHAP(J).EQ.1) THEN
 
C FOURIER
            IF(CRDIN) THEN
               IF(EXTP.EQ.EXTPO) THEN
                  READ(IMATI,313) NPLNT,(ZHAR(I),LZHAR(I),I=1,122)
  313             FORMAT(I5/ (2(1PD26.19,I3)))
               ELSE
                  READ(IMATI,314) NPLNT,(ZHAR(I),LZHAR(I),I=1,122)
  314             FORMAT(I5/ (3(1PD24.17,I2)))
               ENDIF
            ELSE
               READ(IMATI) NPLNT,(ZHAR(I),I=1,122),(LZHAR(I),I=1,122)
            ENDIF
            IF(.NOT.EIGEN) THEN
               IF(CRDOUT) THEN
                  WRITE(IMATS,313) NPLNT,(ZHAR(I),LZHAR(I),I=1,122)
               ELSE
                 WRITE(IMATS) NPLNT,(ZHAR(I),I=1,122),(LZHAR(I),I=1,122)
               ENDIF
            ENDIF
         ELSE
 
C GRID
            IF(CRDIN) THEN
               READ(IMATI,315) NPLNT,NGD,LATDIM,LONDIM,SCNTL,
     .           (SHAPE(I),LSHAPE(I),I=1,NGD)
  315          FORMAT(4I5,1P,3E17.9/ 3E17.9/ (4(E17.9,I2)))
               NGD2 = (NGD + 1)/2
            ELSE
               READ(IMATI) NPLNT,NGD,NGD2,SCNTL,LATDIM,LONDIM,I,
     .             (ZHAR(I),I=1,NGD2),(LSHAPE(I),I=1,NGD)
            ENDIF
            IF(.NOT.EIGEN) THEN
               IF(CRDOUT) THEN
                  WRITE(IMATS,315) NPLNT,NGD,LATDIM,LONDIM,SCNTL,
     .             (SHAPE(I),LSHAPE(I),I=1,NGD)
               ELSE
                  WRITE(IMATS) NPLNT,NGD,NGD2,SCNTL,LATDIM,LONDIM,
     .             NGD,(ZHAR(I),I=1,NGD2),(LSHAPE(I),I=1,NGD)
               ENDIF
            ENDIF
         ENDIF
  320    CONTINUE
C
C SITES - NSITCR MUST BE 3 OR 6
      IF(NUMSIT.GT.0) THEN
         IF(CRDIN) THEN
            IF(NSITCSV.LT.3) THEN
               READ(IMATI,330) ((SITE(J,I),J=1,2),KSCRD(I),
     .          (LSCRD(J,I),J=1,3),(SCORD(J,I),J=1,3),I=1,NUMSIT)
  330          FORMAT(2A4,I5,3I2/ 1P,3D25.17)
C WOULD NEED TO INITIALIZE SITE VELOCITIES HERE, BUT THEY'RE NOT SAVED
               DO I=1,NUMSIT
                  T0SIT(I)=0D0
               END DO
            ELSE
               DO I=1,NUMSIT
                  READ(IMATI,331) (SITE(J,I),J=1,2),KSCRD(I),T0SIT(I),
     .             (LSCRD(J,I),SCORD(J,I),J=1,NSITCR)
  331             FORMAT(2A4,I5,1P,D26.19/(2(I3,D26.19)))
               END DO
            ENDIF
         ELSE
            IF(NSITCR.LT.6) THEN
               READ(IMATI) ((SITE(J,I),J=1,2), KSCRD(I),
     .          (SCORD(J,I),J=1,NSITCR), (LSCRD(J,I),J=1,NSITCR),
     .          I=1,NUMSIT)
               DO I=1,NUMSIT
                  T0SIT(I)=0D0
               END DO
            ELSE
               READ(IMATI) ((SITE(J,I),J=1,2),KSCRD(I),T0SIT(I),
     .          (SCORD(J,I),J=1,NSITCR), (LSCRD(J,I),J=1,NSITCR),
     .          I=1,NUMSIT)
            ENDIF
         ENDIF
         IF(.NOT.EIGEN) THEN
            IF(CRDOUT) THEN
               DO I=1,NUMSIT
                  WRITE(IMATS,331) (SITE(J,I),J=1,2),KSCRD(I),T0SIT(I),
     .             (LSCRD(J,I),SCORD(J,I),J=1,NSITCO)
               END DO
            ELSE
               IF(NSITCO.LT.6) THEN
                  WRITE(IMATS) ((SITE(J,I),J=1,2), KSCRD(I),
     .             (SCORD(J,I),J=1,NSITCO), (LSCRD(J,I),J=1,NSITCO),
     .             I=1,NUMSIT)
               ELSE
                  WRITE(IMATS) ((SITE(J,I),J=1,2),KSCRD(I),T0SIT(I),
     .             (SCORD(J,I),J=1,NSITCO), (LSCRD(J,I),J=1,NSITCO),
     .             I=1,NUMSIT)
               ENDIF
            ENDIF
         ENDIF
      ENDIF
C
C SPOTS
      IF(NUMSPT.GT.0) THEN
         IF(CRDIN) THEN
            IF(EXTP.EQ.EXTPO) THEN
               READ(IMATI,340) (SPOT(I),NSPLNT(I),(LSPCRD(J,I),J=1,3),
     .          (SPCORD(J,I),J=1,3), I=1,NUMSPT)
  340          FORMAT(A4,I5,3I2/ 1P,3D26.19)
            ELSE
               READ(IMATI,341) (SPOT(I),NSPLNT(I),(LSPCRD(J,I),J=1,3),
     .          (SPCORD(J,I),J=1,3), I=1,NUMSPT)
  341          FORMAT(A4,I5,3I2/ 1P,3D25.17)
            ENDIF
         ELSE
            READ(IMATI) (SPOT(I), NSPLNT(I),
     .         (SPCORD(J,I),J=1,3),(LSPCRD(J,I),J=1,3),I=1,NUMSPT)
         ENDIF
         IF(.NOT.EIGEN) THEN
            IF(CRDOUT) THEN
               WRITE(IMATS,340) (SPOT(I),NSPLNT(I),(LSPCRD(J,I),J=1,3),
     .          (SPCORD(J,I),J=1,3), I=1,NUMSPT)
            ELSE
               WRITE(IMATS) (SPOT(I),NSPLNT(I),
     .          (SPCORD(J,I),J=1,3),(LSPCRD(J,I),J=1,3),I=1,NUMSPT)
            ENDIF
         ENDIF
      ENDIF
C
C STARS
      IF(NUMSTR.GT.0) THEN
         IF(CRDIN) THEN
            NMAX = 1
            DO 350 I=1,NUMSTR
               IF(EXTP.EQ.EXTPO) THEN
                  READ(IMATI,345) CTLG(I),N,(SKYCF(J,I),LSKYCF(J,I),
     .             J=1,N)
  345             FORMAT(A8,I5/ (2(1PD26.19,I3)))
               ELSE
                  READ(IMATI,346) CTLG(I),N,(SKYCF(J,I),LSKYCF(J,I),
     .             J=1,N)
  346             FORMAT(A8,I5/ (3(1PD24.17,I2)))
               ENDIF
               NSKYCF(I) = N
               IF(N.GT.NMAX) NMAX = N
  350          CONTINUE
            N = NMAX
         ELSE
            READ(IMATI) (CTLG(I), N, NSKYCF(I), (SKYCF(J,I),J=1,N),
     .                (LSKYCF(J,I),J=1,N), I=1,NUMSTR)
            NMAX = N
         ENDIF
         IF(.NOT.EIGEN) THEN
            IF(CRDOUT) THEN
               DO 360 I=1,NUMSTR
                  N = NSKYCF(I)
                  WRITE(IMATS,345) CTLG(I),N,(SKYCF(J,I),LSKYCF(J,I),
     .             J=1,N)
  360          CONTINUE
            ELSE
               WRITE(IMATS) (CTLG(I), N, NSKYCF(I), (SKYCF(J,I),J=1,N),
     .          (LSKYCF(J,I),J=1,N), I=1,NUMSTR)
            ENDIF
         ENDIF
      ENDIF
C
C PULSAR PARAMETERS
      IF(NUMPSR.GT.0) THEN
         IF(CRDIN) THEN
            IF(EXTP.EQ.EXTPO) THEN
               READ(IMATI,370) (SPTPSR(I),JDPSR0(I),PLSPR(I),NTYPSR(I),
     .          (PSRCN(J,I),J=1,16), (LPSRCN(J,I),J=1,16), I=1,NUMPSR)
  370          FORMAT((A4,I8,1PD26.19,I5,3X,D26.19/ 5(3D26.19/), 16I5))
            ELSE
               READ(IMATI,371) (SPTPSR(I),JDPSR0(I),PLSPR(I),NTYPSR(I),
     .          (PSRCN(J,I),J=1,16), (LPSRCN(J,I),J=1,16), I=1,NUMPSR)
  371          FORMAT((A4,I8,1PD25.17,I5,3X,D25.17/ 5(3D25.17/), 16I5))
            ENDIF
         ELSE
            READ(IMATI) (SPTPSR(I),JDPSR0(I),PLSPR(I),NTYPSR(I),
     .          (PSRCN(J,I),J=1,16), (LPSRCN(J,I),J=1,16), I=1,NUMPSR)
         ENDIF
         IF(.NOT.EIGEN) THEN
            IF(CRDOUT) THEN
               WRITE(IMATS,370) (SPTPSR(I),JDPSR0(I),PLSPR(I),NTYPSR(I),
     .          (PSRCN(J,I),J=1,16), (LPSRCN(J,I),J=1,16), I=1,NUMPSR)
            ELSE
               WRITE(IMATS) (SPTPSR(I),JDPSR0(I),PLSPR(I),NTYPSR(I),
     .          (PSRCN(J,I),J=1,16), (LPSRCN(J,I),J=1,16), I=1,NUMPSR)
            ENDIF
         ENDIF
      ENDIF
C
C RADAR BIASES
      IF(NUMRBS.GT.0) THEN
         IF(CRDIN) THEN
            READ(IMATI,380) ((RDBSIT(J,I),J=1,2), RDBSER(I),
     .       (RBIAS(J,I),J=1,2), (LRBS(J,I),J=1,2), NPLRBS(I),
     .       I=1,NUMRBS)
  380       FORMAT(A4,1X,A4,1X,A4,1P,2E17.9,2I2,I5)
         ELSE
            READ(IMATI) ((RDBSIT(J,I),J=1,2), RDBSER(I),
     .          (RBIAS(J,I),J=1,2), (LRBS(J,I),J=1,2), NPLRBS(I), I = 1,
     .          NUMRBS)
         ENDIF
         IF(.NOT.EIGEN) THEN
            IF(CRDOUT) THEN
               WRITE(IMATS,380) ((RDBSIT(J,I),J=1,2), RDBSER(I),
     .          (RBIAS(J,I),J=1,2), (LRBS(J,I),J=1,2), NPLRBS(I), I = 1,
     .          NUMRBS)
            ELSE
               WRITE(IMATS) ((RDBSIT(J,I),J=1,2), RDBSER(I),
     .          (RBIAS(J,I),J=1,2), (LRBS(J,I),J=1,2), NPLRBS(I), I = 1,
     .          NUMRBS)
            ENDIF
         ENDIF
      ENDIF
C
C EQUINOX EQUATOR
      IF(NUMEQN.GT.0) THEN
         IF(CRDIN) THEN
            READ(IMATI,390) (EQNSIT(I), EQNSER(I), (DEQ(J,I),J=1,3),
     .          (LEQN(J,I),J=1,3), I = 1, NUMEQN)
  390       FORMAT(A4,1X,A4,1P,3E17.9,3I2)
         ELSE
            READ(IMATI) (EQNSIT(I), EQNSER(I), (DEQ(J,I),J=1,3),
     .          (LEQN(J,I),J=1,3), I = 1, NUMEQN)
         ENDIF
         IF(.NOT.EIGEN) THEN
            IF(CRDOUT) THEN
               WRITE(IMATS,390) (EQNSIT(I), EQNSER(I), (DEQ(J,I),J=1,3),
     .          (LEQN(J,I),J=1,3), I = 1, NUMEQN)
            ELSE
               WRITE(IMATS) (EQNSIT(I), EQNSER(I), (DEQ(J,I),J=1,3),
     .          (LEQN(J,I),J=1,3), I = 1, NUMEQN)
            ENDIF
         ENDIF
      ENDIF
C
C PHASE CORRECTIONS
      IF(NUMPHS.GT.0) THEN
         IF(CRDIN) THEN
            READ(IMATI,395) (PHSIT(I),PHSER(I),(APHASE(J,I),J=1,9),
     .          NCPHS(I), NPLPHS(I), (LPHS(J,I),J=1,9), I = 1, NUMPHS)
  395       FORMAT((A4,1X,A4,1P,2(4E17.9/), E17.9,2I5,9I2))
         ELSE
            READ(IMATI) (PHSIT(I),PHSER(I),(APHASE(J,I),J=1,9),
     .          NCPHS(I), NPLPHS(I), (LPHS(J,I),J=1,9), I = 1, NUMPHS)
         ENDIF
         IF(.NOT.EIGEN) THEN
            IF(CRDOUT) THEN
               WRITE(IMATS,395) (PHSIT(I),PHSER(I),(APHASE(J,I),J=1,9),
     .          NCPHS(I), NPLPHS(I), (LPHS(J,I),J=1,9), I = 1, NUMPHS)
            ELSE
               WRITE(IMATS) (PHSIT(I),PHSER(I),(APHASE(J,I),J=1,9),
     .          NCPHS(I), NPLPHS(I), (LPHS(J,I),J=1,9), I = 1, NUMPHS)
            ENDIF
         ENDIF
      ENDIF
      IF(STOP) GOTO 900
 
  400 IF(CRDIN) THEN
         IF(EXTP.EQ.EXTPO) THEN
            READ(IMATI,410,END=900) MESMT,NTAPE,NSEQ,(ERWGT(I),I=1,2),
     .       (ERMES(I),I=1,3),ZNSQSN,ZSMSN,IAPRIO,IVECTK
  410       FORMAT(3I10,1P,2E17.9/ 3D26.19/ 2D26.19,2I5)
         ELSE
            READ(IMATI,411,END=900) MESMT,NTAPE,NSEQ,(ERWGT(I),I=1,2),
     .       (ERMES(I),I=1,3),ZNSQSN,ZSMSN,IAPRIO,IVECTK
  411       FORMAT(3I10,1P,2E17.9/ 3D25.17/ 2D25.17,2I5)
         ENDIF
      ELSE
         READ(IMATI,END=900) MESMT,NTAPE,NSEQ,(ERWGT(I),I=1,2),
     .       (ERMES(I),I=1,3),ZNSQSN,ZSMSN,IAPRIO,IVECTK
      ENDIF
      IF(NTAPE.EQ.0 .AND. MESMT.LE.0) GOTO 900
      IF(.NOT.EIGEN) THEN
         IF(CRDOUT) THEN
            WRITE(IMATS,410) MESMT,NTAPE,NSEQ,(ERWGT(I),I=1,2),
     .       (ERMES(I),I=1,3),ZNSQSN,ZSMSN,IAPRIO,IVECTK
         ELSE
            WRITE(IMATS) MESMT,NTAPE,NSEQ,(ERWGT(I),I=1,2),
     .    (ERMES(I),I=1,3),ZNSQSN,ZSMSN,IAPRIO,IVECTK,(ZERO(I),I=1,10)
         ENDIF
      ELSE
         WRITE(6,415) TITLE,NPARAM
  415    FORMAT(' EIGENVALUES FOR COEFFICIENT MATRIX, ''',A8,''''/
     .    1X,9A8/1X,A8,' NPARAM=',I4)
      ENDIF
      NPARM = NPARAM
C
C           READ POINTER GROUP FOR PRE-REDUCED SNE
      M2=NPARAM*2
      IF(IPPR.NE.0) THEN
         ZSMPP = 0D0
         IF(CRDIN) THEN
            IF(EXTP.EQ.EXTPO) THEN
               READ(IMATI,420) N,NCPARM,NDPARM,ZNSQPP,NSERPP,
     .          NAUXPP,(ICREST(I),I=1,NCPARM),(IDREST(I),I=1,NDPARM)
  420          FORMAT(3I8,1PD26.19,2I8/ (16I5))
               READ(IMATI,425) (BUFF(I),I=1,M2),ZSMPP
  425          FORMAT(1P,3D26.19)
            ELSE
               READ(IMATI,421) N,NCPARM,NDPARM,ZNSQPP,NSERPP,
     .          NAUXPP,(ICREST(I),I=1,NCPARM),(IDREST(I),I=1,NDPARM)
  421          FORMAT(3I8,1PD25.17,2I8/ (16I5))
               READ(IMATI,426) (BUFF(I),I=1,M2),ZSMPP
  426          FORMAT(1P,3D25.17)
            ENDIF
         ELSE
            READ(IMATI,ERR=435) N,NCPARM,NDPARM,ZNSQPP,NSERPP,
     .         NAUXPP,(ICREST(I),I=1,NCPARM),(IDREST(I),I=1,NDPARM),
     .         (BUFF(I),I=1,M2),ZSMPP
  435       CONTINUE
         ENDIF
         NPARM = NCPARM
         IF(.NOT.EIGEN) THEN
            IF(CRDOUT) THEN
               WRITE(IMATS,420) N,NCPARM,NDPARM,ZNSQPP,NSERPP,
     .          NAUXPP,(ICREST(I),I=1,NCPARM),(IDREST(I),I=1,NDPARM)
               WRITE(IMATS,425) (BUFF(I),I=1,M2),ZSMPP
            ELSE
               WRITE(IMATS) N,NCPARM,NDPARM,ZNSQPP,NSERPP,
     .          NAUXPP,(ICREST(I),I=1,NCPARM),(IDREST(I),I=1,NDPARM),
     .          (BUFF(I),I=1,M2),ZSMPP
            ENDIF
         ELSE
            WRITE(6,437) NCPARM
  437       FORMAT(' PREREDUCED TO NCPARM=',I4)
         ENDIF
      ENDIF
C
      IF(IVECTK.GT.0) CALL
     .  BUFCPY(IMATI,IMATS,CRDIN,CRDOUT,NPARM,BUFF,N,EIGEN,EXTP)
 
C COPY RIGHT-HAND SIDES OR SOLUTION PLUS SCALE FACTORS
      M2=NPARM
      IF(TITLE(1).EQ.'SOLUTCOV') M2=NPARM*2
      CALL BUFCPY(IMATI,IMATS,CRDIN,CRDOUT,M2,BUFF,N,EIGEN,EXTP)

      IF(EIGEN) THEN
         CALL PREIGEN(IMATI,CRDIN,NPARM,BUFF,EXTP)
         REWIND IMATI
         STOP
      ENDIF

C COPY MATRIX (POSSIBLY SPARSE)
  500 CALL BUFCPY(IMATI,IMATS,CRDIN,CRDOUT,NPARM,BUFF,N,EIGEN,EXTP)
      IF(N.LT.NPARM) GOTO 500
 
C COPY COMBINED A PRIORI INFO
      IF(IAPRIO.NE.0) THEN
         CALL BUFCPY(IMATI,IMATS,CRDIN,CRDOUT,NPARM,BUFF,N,EIGEN,EXTP)
  600    CALL BUFCPY(IMATI,IMATS,CRDIN,CRDOUT,NPARM,BUFF,N,EIGEN,EXTP)
         IF(N.LT.NPARM) GOTO 600
      ENDIF
      IF(IPPR.EQ.0) GOTO 400
C COPY D VARIANCES AND ZBAR
      CALL BUFCPY(IMATI,IMATS,CRDIN,CRDOUT,NDPARM,BUFF,N,EIGEN,EXTP)
      IF(N.EQ.-1) CALL BUFCPY(IMATI,IMATS,CRDIN,CRDOUT,NDPARM,BUFF,N,
     . EIGEN,EXTP)
C COPY RECTANGULAR PIECE
      DO 650 I=1,NDPARM
         CALL BUFCPY(IMATI,IMATS,CRDIN,CRDOUT,NCPARM,BUFF,N,EIGEN,EXTP)
  650    CONTINUE
C
  900 REWIND IMATI
      REWIND IMATS
      STOP
      END
      SUBROUTINE BUFCPY(IMATI,IMATS,CRDIN,CRDOUT,NPARAM,BUFF,N,NOCOPY,
     . EXTP)
      IMPLICIT NONE
 
C READ AND WRITE A ROW OF NORMAL EQUATION STUFF
 
      INTEGER*4 IMATI,IMATS,NPARAM,N
      LOGICAL*4 CRDIN,CRDOUT,NOCOPY
      REAL*10    BUFF(NPARAM)
      CHARACTER*4 EXTP,EXTPO/' EXT'/

      IF(CRDIN) THEN
         IF(EXTP.EQ.EXTPO) THEN
            READ(IMATI,430) N,BUFF
  430       FORMAT(I10/ (1P,3D26.19))
         ELSE
            READ(IMATI,431) N,BUFF
  431       FORMAT(I10/ (1P,3D25.17))
         ENDIF
      ELSE
         READ(IMATI) N,BUFF
      ENDIF
      IF(.NOT.NOCOPY) THEN
         IF(CRDOUT) THEN
            WRITE(IMATS,430) N,BUFF
         ELSE
            WRITE(IMATS) N,BUFF
         ENDIF
      ENDIF
      RETURN
      END
