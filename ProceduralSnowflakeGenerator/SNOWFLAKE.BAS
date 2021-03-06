10 XMAX=PSIZE(0):YMAX=PSIZE(1)
20 XCEN=INT(XMAX/2)-0.5
30 YCEN=INT(YMAX/2)-0.5
40 ANG=3.14159265/3'PI/3= 60 DEGREES
50 COL1=93'FIRST COLOR
60 COL2=252'SECOND COLOR
70 FEED=2000'FEEDRATE FOR GCODE
80 COLOR 0,255
200 DO 'MAIN LOOP TO DRAW SNOWFLAKES ON THE SCREEN
210   CLS:COL=COL1'CLEAR SCREEN & SET DRAW COLOR
220   ~FLAKE=[0]'ZERO OUT THE PREVIOUS SNOWFLAKE
230   A=POPB(~FLAKE)'NO REALLY, MAKE IT EMPTY
240   TOTAL=INT(RND(0.5)*12+6)'TOTAL NUMBER OF LINES
250   CHANGE=INT(TOTAL*RND(0.5))'WHEN TO CHNG COLOR?
260   FOR COUNT=1 TO TOTAL
270     IF COUNT=CHANGE THEN COL=COL2:ENDIF 
280   R1=RND(0.5)*YCEN'LENGTH TO POINT 1
290   T1=(RND(0.5)-0)*ANG'ANGLE TO POINT 1
300   R2=RND(0.5)*YCEN'LENGTH TO POINT 2
310   T2=(RND(0.5)-0)*ANG'ANGLE TO POINT 2
313   'LOCATE 1,1:PRINT R1;" ";T1;" ";R2;" ";T2
316   'LOCATE 1,2:PRINT TOTAL,COUNT,CHANGE
320   APPEND ~FLAKE,R1'SAVE POINTS (FOR GCODE)
330   APPEND ~FLAKE,T1
340   APPEND ~FLAKE,R2
350   APPEND ~FLAKE,T2
355   'PRINT LEN(~FLAKE)
360   MT1=ANG-T1'MIRROR OF POINT 1 ANGLE
370   MT2=ANG-T2'MIRROR OF POINT 2 ANGLE
380   FOR I=0 TO 5'SIX ARMS OF SNOWFLAKE
390     CALL POLARLINE(R1,T1+(I*ANG),R2,T2+(I*ANG))
400     CALL POLARLINE(R1,MT1+(I*ANG),R2,MT2+(I*ANG))
410   NEXT I
420 NEXT COUNT
500 WINDOW 0,1,11,20
510 INPUT "SAVE GCODE? Y/N/Q ";IN1$
520 IF IN1$="Y" THEN 
530   CALL PLOT
540   PRINT "SAVED AS ";FLAKENUM;"_SNOWFLAKE.GCODE"
550   INPUT "SAVE PCX?   Y/N ";IN2$
560   IF IN2$="Y" THEN 
570     SAVE PCX FLAKENUM$+"_SNOWFLAKE.PCX"POS 118,0 SIZE 224,224
580     PRINT "SAVED AS ";FLAKENUM;"_SNOWFLAKE.PCX"
590   ENDIF 
600 ELSE IF IN1$="Q" THEN WINDOW OFF:COLOR 255,0:CLS:END 
610 WINDOW OFF:ENDIF 
620 LOOP 'DRAW A NEW SNOWFLAKE!
630 END 'FWIW, WE SHOULD NEVER GET HERE
1000 PROC PENUP
1010 PRINT #0,"G1 Z2 F";FEED
1020 RETURN 
1100 PROC PENDOWN
1110 PRINT #0,"G1 Z0 F";FEED
1120 RETURN 
1200 PROC PENCHANGE
1210 PRINT #0,"G4 P20"'PAUSE FOR 20 SECONDS
1220 RETURN 
1300 PROC POLARLINE(R1,T1,R2,T2)'DRAW TO SCREEN
1310 X1=INT(@R1*COS(@T1))'POLAR TO CARTESIAN
1320 Y1=INT(@R1*SIN(@T1))
1330 X2=INT(@R2*COS(@T2))
1340 Y2=INT(@R2*SIN(@T2))
1350 LINE X1+XCEN,Y1+YCEN,X2+XCEN,Y2+YCEN,COL
1360 RETURN 
1400 PROC PLOTLINE(R1,T1,R2,T2)'SAVE TO GCODE
1410 X1=@R1*COS(@T1):X1=X1*0.4
1420 Y1=@R1*SIN(@T1):Y1=Y1*0.4
1430 X2=@R2*COS(@T2):X2=X2*0.4
1440 Y2=@R2*SIN(@T2):Y2=Y2*0.4
1450 PRINT #0,"G0 X";X1+(XCEN*0.4);" Y-";Y1+(YCEN*0.4);" F";FEED
1460 CALL PENDOWN
1470 PRINT #0,"G1 X";X2+(XCEN*0.4);" Y-";Y2+(YCEN*0.4);" F";FEED
1480 CALL PENUP
1490 RETURN 
1500 PROC PLOT
1510 FLAKENUM=FLAKENUM+1
1520 FLAKENUM$=STR$(FLAKENUM)
1530 OPEN FLAKENUM$+"_SNOWFLAKE.GCODE" FOR OUTPUT AS #0
1540 PRINT #0,"G21"
1550 PRINT #0,"G90"
1560 PRINT #0,"G54"
1570 CALL PENUP
1571 'PRINT #0,"G1 X";XCEN*0.4;" Y-";YCEN*0.4;" F";FEED
1580 FOR COUNT=1 TO TOTAL
1590   IF COUNT=CHANGE THEN 
1591     CALL PENCHANGE
1592   ENDIF 
1600   R1=POPF(~FLAKE)'LENGTH TO POINT 1
1610   T1=POPF(~FLAKE)'ANGLE TO POINT 1
1620   R2=POPF(~FLAKE)'LENGTH TO POINT 2
1630   T2=POPF(~FLAKE)'ANGLE TO POINT 2
1640   MT1=ANG-T1'MIRROR OF POINT 1 ANGLE
1650   MT2=ANG-T2'MIRROR OF POINT 2 ANGLE
1660   FOR I=0 TO 5'SIX ARMS OF SNOWFLAKE
1670     CALL PLOTLINE(R1,T1+(I*ANG),R2,T2+(I*ANG))
1680     CALL PLOTLINE(R1,MT1+(I*ANG),R2,MT2+(I*ANG))
1690   NEXT I
1691 NEXT COUNT
1700 PRINT #0,"G0 X10 Y-10 F";FEED
1710 CLOSE #0
1720 RETURN 
