C           INPUT STREAM BUFFER
      COMMON/CRDBUF/ CARD8(10),USEIT,IEOF,LCNT,LMAX
      CHARACTER*8 CARD8
      INTEGER*4 IEOF,LCNT,LMAX
      LOGICAL*4 USEIT
      CHARACTER*80 CARD80
      EQUIVALENCE (CARD80,CARD8)