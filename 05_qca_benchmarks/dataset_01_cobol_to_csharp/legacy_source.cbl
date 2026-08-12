IDENTIFICATION DIVISION.
       PROGRAM-ID. ACC-INT-CALC.
       AUTHOR. QCA-LEGACY-SYSTEMS.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-ACCOUNT-RECORD.
           05  WS-ACC-NUM          PIC X(10).
           05  WS-BALANCE          PIC S9(7)V99.
           05  WS-ACC-TYPE         PIC X(1).
       01  WS-INTEREST-RATE        PIC V9999.
       01  WS-CALC-INTEREST        PIC S9(7)V99.
       
       PROCEDURE DIVISION.
       CALCULATE-INTEREST-RTN.
           IF WS-BALANCE > 0
               EVALUATE WS-ACC-TYPE
                   WHEN 'S'
                       MOVE 0.0350 TO WS-INTEREST-RATE
                   WHEN 'C'
                       MOVE 0.0125 TO WS-INTEREST-RATE
                   WHEN OTHER
                       MOVE 0.0000 TO WS-INTEREST-RATE
               END-EVALUATE
               
               COMPUTE WS-CALC-INTEREST ROUNDED = 
                       WS-BALANCE * WS-INTEREST-RATE
               
               ADD WS-CALC-INTEREST TO WS-BALANCE
           ELSE
               MOVE 0 TO WS-CALC-INTEREST
           END-IF.
           
           DISPLAY 'NEW BALANCE: ' WS-BALANCE.
           STOP RUN.