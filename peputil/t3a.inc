C           TYPE 3 OBSLIB RECORD INFORMATION                            =
C           FROM LSCRDA TO THE END IS CLEARED WHEN REMOVING PARTIALS
      COMMON/T3A/ RITA,SITA,ERWGTA(2),FREQA,PNAMA,PLCNA(NMBOD),
     1 SBCNA(NMBOD),OBSCNA(24),SCORDA(6,2),SPCDA(3),SCNAMA(2),JDSC0A(2),
     2 SCCNA(NMBOD,2),SPCD2A(3),FREQ2A,EXNMSA(2,200),CTLGA,T0SITA(2),
     3 NSEQA,SERA,SPOTA,ACCTMA,FDEVA,NPG3A,JDPL0A,JDSB0A,RBSA(2),
     4 EQNA(3),APHSA(9),KSITEA(2),SPOT2A,NEXTA,NCODFA,NPLNTA,NPLN2A,
     5 ITIMA,NREWNA,NCENTA,NRBSA,NEQNA,NCPHA,NOBCNA,N5A,N6A,NAA,NBA,
     6 NMPEXA,NPLEXA(10),LSCRDA(6,2),
     7 LPLA(NMBOD),LSBA(NMBOD),LSCA(NMBOD,2),LRBSA(2),LEQNA(3),
     8 LPHSA(9),LSPCDA(3),NCZNEA,NCTSSA,LCZHRA(24),LCCHRA(209),
     9 LCSHRA(209),NUMTRA,NTRGA(11),LTBODA(NMBOD,11),NTZNEA(11),
     A LTZHRA(4,11),NTTSSA(11),LTCHRA(5,11),LTSHRA(5,11),NSZNEA,NSTSSA,
     B LSZHRA(24),LSCHRA(209),LSSHRA(209),LSFLLA(558),LSPC2A(3),
     C LEMMNA(6),LNGDA,LNFORA,NSKYCA,LSKYA(80),LPSRCA(16),
     D LPEXA(NMBOD,10),N2A,N3A,N4A,N7A,N8A,N9A
      CHARACTER*8 RITA,SITA,PNAMA,SCNAMA,EXNMSA,CTLGA
      CHARACTER*4 SERA,SPOTA,SPOT2A
      REAL*10 FREQA,PLCNA,SBCNA,OBSCNA,SCORDA,SPCDA,SCCNA,SPCD2A,FREQ2A,
     1 T0SITA
      REAL*4 ERWGTA,ACCTMA,FDEVA,RBSA,EQNA,APHSA
      INTEGER*4 NSEQA,NPG3A,JDPL0A,JDSB0A,JDSC0A,NEXTA
      INTEGER*2 NCODFA,NPLNTA,ITIMA,NREWNA,NCENTA,LPLA,LSBA,LSCRDA,
     1 NRBSA,LRBSA,NEQNA,LEQNA,NCPHA,LPHSA,NOBCNA,KSITEA,LSPCDA,
     2 NCZNEA,NCTSSA,N2A,N3A,LCZHRA,LCCHRA,LCSHRA,NUMTRA,N4A,NTRGA,
     3 LTBODA,NTZNEA,LTZHRA,NTTSSA,LTCHRA,
     4 LTSHRA,N5A,N6A,LSCA,NSZNEA,NSTSSA,N7A,N8A,LSZHRA,
     5 LSCHRA,LSSHRA,LSFLLA,NPLN2A,LSPC2A,LEMMNA,LNGDA,LNFORA,
     6 NSKYCA,LSKYA,N9A,LPSRCA,NMPEXA,NAA,NBA,NPLEXA,LPEXA