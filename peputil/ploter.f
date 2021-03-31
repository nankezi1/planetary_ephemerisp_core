      SUBROUTINE PLOTER(PLMODE,X,Y,N,K)
C         INTERFACE TO CALCOMP ROUTINES FOR THE SCALING, AXIS DRAWING,
C         AND POINT PLOTTING OF ONE GRAPH.
C             PLMODE - TYPE OF PLOTTING TO DO:
C                  -1  NON-LOOKER PLOTS
C                   0  IMMEDIATE LOOKER PLOT
C                   1  FIRST SERIES OF ONEAXE PLOT
C                   2  SUBSEQUENT SERIES FOR ONEAXE PLOT
C                   3  FINISH OFF ONEAXE PLOT
C             X - ARRAY OF VALUES IN X DIRECTION - REAL*4
C             Y - ARRAY OF VALUES IN Y DIRECTION - REAL*4
C             N - NUMBER OF POINTS TO BE PLOTTED - INT*4
C             K - REPEAT CYCLE OF X AND Y ARRAYS - INT*4
C
C         PARAMETERS
      REAL*4 X(1),Y(1)
      INTEGER*4 PLMODE,N,K
C
C         COMMON
      include 'graphs.inc'
      include 'misc.inc'
      include 'pltfrm.inc'
      include 'sortv.inc'
C
C        LOCAL
      INTEGER*4 MARK
      REAL*4 XF,YF,RLAT,PLAT,HGT2
C
C         IF NIV=-1, LAT BAND FOR PLOT IS PLOTTED
      PLAT= (TLAT(2)+TLAT(1))/2.0
      RLAT= ABS(TLAT(2)-PLAT)
      HGT2= 0.21*0.5
C
      IF(PFIRST) CALL PLNITL
      MARK=0
      IF(SYMBEL) MARK=-1
C
      IF(PLMODE-2) 10,15,25
C
C         FIND LENGTH OF X AXIS
   10 CALL FNAXE(PLMODE,N)
C
C           SCALE AXES
   15 CALL SQALE(PLMODE,X,N,K,XL,EXTRMX,SMINX,1)
      CALL SQALE(PLMODE,Y,N,K,YL,EXTRMY,SMINY,1)
C
C           CORRECT LENGTHS TO GET PROPER ASPECT, IF NECESSARY
      IF(PLMODE.LT.0.OR.PLMODE.GT.1.OR..NOT.(TWOOBS.AND.ASPECT)) GOTO 18
      IF(NDV.NE.1.OR.NIV.NE.1.OR.(JTYPE.NE.2.AND.JTYPE.NE.8)) GOTO 18
      SZALP=(SMAXX-SMINX)*COS(0.01745329252*.5*(SMINY+SMAXY))
      IF(JTYPE.EQ.2) SZALP=SZALP*15.
      SZDLT=SMAXY-SMINY
      IF(SZALP.EQ.0..OR.SZDLT.EQ.0..OR.XL.EQ.0..OR.YL.EQ.0.) GOTO 18
      RATIO=SZDLT/SZALP
      RAT2=YL/XL
      IF(RATIO.LE.RAT2) GOTO 16
C           MUST SQUEEZE X-AXIS
      RATIO=RATIO/RAT2
      XL=XL/RATIO
      SCONVX=SCONVX*RATIO
      X(N*K+K+1)=SCONVX
      DIVX=DIVX*RATIO
      GOTO 18
C           MUST SQUEEZE Y-AXIS
   16 RATIO=RAT2/RATIO
      YL=YL/RATIO
      SCONVY=SCONVY*RATIO
      Y(N*K+K+1)=SCONVY
      DIVY=DIVY*RATIO
   18 CONTINUE
C
C           PLOT Y AXIS
      IF(PLMODE.LE.1) CALL PLAXIS(0)
C
C           PLOT POINTS
   20 IF(SYMBEL) GOTO 23
C           MARK FIRST POINT, THEN DRAW LINE
      XF=(X(1)-SMINX)/SCONVX
      YF=(Y(1)-SMINY)/SCONVY
      CALL SYMBOL(XF,YF,0.07,NSYM,0.0,-1)
   23 CALL LINE(X,Y,N,K,MARK,NSYM)
C
C          IF NIV=-1, PLOT LAT RANGE
   25 IF(PLMODE.EQ.1.OR.PLMODE.EQ.2) GOTO 50
      IF(NIV.NE.-1)  GO TO 30
      CALL SYMBOL(0.25,0.25,HGT2,'LAT= ',0.0,5)
      CALL NUMBER(999.0,999.0,HGT2,PLAT,0.0,2)
      CALL SYMBOL(999.0,999.0,HGT2,23,0.0,-1)
      CALL NUMBER(999.0,999.0,HGT2,RLAT,0.0,2)
 30   CONTINUE
C           DRAW X AXIS
      CALL PLAXIS(1)
   50 CONTINUE
      RETURN
C
      END
