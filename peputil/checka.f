      LOGICAL FUNCTION CHECKA(NDV)
      IMPLICIT NONE
C         CHECK FOR GOOD TYPE 3 RECORD, TRUE IF ACCEPTABLE SERIES
C         FOR NUMBER OF SERIES TO BE USED, GO THRU ALL VALUES OF VARIOUS
C         TYPE 3 QUANTITIES TO SEE IF CURRENT VALUES ARE AMONG THEM
C         IF CHECKING FOR NAMES, NDV RETURNS INDEX TO GIVEN NAME
C
C         PARAMETER
      INTEGER*4  NDV

      include 'pepglob.inc'
C
C         COMMON
      include 'checks.inc'
      include 'namen.inc'
      include 't2a.inc'
      include 't3a.inc'
C
C         LOCAL
      CHARACTER*8 BLANK/'        '/
      CHARACTER*4 BLNK4
      EQUIVALENCE (BLANK,BLNK4)
      INTEGER*4 I
C
C         MAKE CHECKS
      CHECKA= .FALSE.
      IF(NCHKS.LE.0) GOTO 90
C
      IF(NSEQ(1) .EQ. -999) GOTO 20
      DO I = 1,NCHKS
         IF(NSEQ(I).EQ.NSEQA) GOTO 20
      END DO
      RETURN
C
   20 IF(NCODF(1) .EQ. -999) GOTO 30
      DO I = 1,NCHKS
         IF(NCODF(I).EQ.NCODFA) GOTO 30
      END DO
      RETURN
C
   30 IF(NPLNT(1).EQ. -999) GOTO 40
      DO I = 1,NCHKS
         IF(NPLNT(I).EQ.NPLNTA) GOTO 40
      END DO
      RETURN
C
   40 IF(RSITE(1).EQ.BLANK) GOTO 50
      DO I = 1,NCHKS
         IF(RSITE(I).EQ.RITA) GOTO 50
      END DO
      RETURN
C
   50 IF(SSITE(1).EQ.BLANK) GOTO 60
      DO I = 1,NCHKS
         IF(SSITE(I).EQ.SITA) GOTO 60
      END DO
      RETURN
C
   60 IF(SERIES(1).EQ.BLNK4) GOTO 70
      DO I = 1,NCHKS
         IF(SERIES(I).EQ.SERA) GOTO 70
      END DO
      RETURN
C
   70 IF(NCENTB(1).EQ.-999) GOTO 76
      DO I = 1,NCHKS
         IF(NCENTB(I).EQ.NCENTA) GOTO 76
      END DO
      RETURN
C
   76 IF(SPOT(1).EQ.BLNK4) GOTO 78
      DO I=1,NCHKS
         IF(SPOT(I).EQ.SPOTA) GOTO 78
      END DO
      RETURN
C
   78 IF(SPOT2(1).EQ.BLNK4) GOTO 80
      DO I=1,NCHKS
         IF(SPOT2(I).EQ.SPOT2A) GOTO 80
      END DO
      RETURN
C
   80 IF(FREQ(1).EQ.-999._10) GOTO 90
      DO I=1,NCHKS
         IF(FREQ(I).EQ.FREQA) GOTO 90
         IF(FREQA.GT.0._10) THEN
            IF(ABS((FREQA-FREQ(I))/FREQA).LT.1E-6_10) GOTO 90
         ENDIF
      END DO
      RETURN
C
C         DO NAME CHECK FOR PARTIALS
   90 IF(NAMES) GOTO 95
      KTOTDT=0
      KLDT=9999
      NUMPAR=-1
      IF(NDV.LE.2.OR.(FNAME.EQ.BLANK.AND.NUMDTA.LE.0)) GOTO 110
   95 NDV0=NDV
      CALL NAMPMA(NUMPAR,NOMBRE,KLDT,KTOTDT)
      IF(NDV.LE.2.OR.FNAME.EQ.BLANK) GOTO 105
C           SPECIAL CHECK WOULD BE NEEDED FOR UT, WOBBLE PARTIALS
      DO I = 1, NUMPAR
         IF(FNAME.EQ.NOMBRE(1,I) .AND. LNAME.EQ.NOMBRE(2,I)) GOTO 100
      END DO
      RETURN
C
  100 NDV = I + 2
  105 NDV0=NDV
      IF(NDV.GE.KLDT) NDV0=NDV-KTOTDT
  110 CHECKA= .TRUE.
      RETURN
      END