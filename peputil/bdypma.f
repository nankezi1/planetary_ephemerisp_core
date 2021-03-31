      SUBROUTINE BDYPMA(LVEC, PREFIX, K, NAMES)
      IMPLICIT NONE
C         GENERATES NAMES FOR IC'S AND CON'S
C
C         PARAMETERS
      CHARACTER*8 PREFIX, NAMES(2, 1)
      INTEGER*2 LVEC(30)
      INTEGER*4 K
C
C         LOCALS
      CHARACTER*8 CCOND/'COND( )'/, CON(2)/'CON( )','CON(  )'/, TEMP
      INTEGER*4 I,L,N
C
C         INITIAL CONDITIONS
      DO 20 I = 1, 6
      IF (LVEC(I) .EQ. 0) GO TO 20
      K = K + 1
      NAMES(1, K) = PREFIX
      TEMP = CCOND
      CALL EBCDIX(I,TEMP,6,1)
      NAMES(2, K) = TEMP
 20   CONTINUE
C
C         OTHER BODY PARAMETERS
      DO 40 I = 7, 30
      IF (LVEC(I) .EQ. 0) GO TO 50
      K = K + 1
      L = LVEC(I)
      NAMES(1, K) = PREFIX
      N=1
      IF(L.GE.10) N=2
      TEMP=CON(N)
      CALL EBCDIX(L,TEMP,5,N)
 35   NAMES(2, K) = TEMP
 40   CONTINUE
 50   CONTINUE
      RETURN
      END
