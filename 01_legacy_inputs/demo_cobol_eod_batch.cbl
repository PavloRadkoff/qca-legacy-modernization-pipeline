IDENTIFICATION DIVISION.
       PROGRAM-ID. EOD-BATCH-PROC.
       AUTHOR. COBALT-LEGACY-ENGINE.
       DATE-WRITTEN. 1988-10-24.
       
       * Ця програма обробляє денні транзакції та оновлює головний 
       * файл балансів. Класичний монолітний Batch Process.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANS-FILE ASSIGN TO 'DATA/TRANS.DAT'
               ORGANIZATION IS SEQUENTIAL.
           SELECT MASTER-FILE ASSIGN TO 'DATA/MASTER.DAT'
               ORGANIZATION IS INDEXED
               ACCESS IS RANDOM
               RECORD KEY IS M-ACCOUNT-NUM.
           SELECT REPORT-FILE ASSIGN TO 'DATA/EOD-REPORT.PRN'
               ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  TRANS-FILE.
       01  TRANS-REC.
           05  T-ACCOUNT-NUM     PIC X(10).
           05  T-TRANS-TYPE      PIC X(01).
               88 IS-DEPOSIT     VALUE 'D'.
               88 IS-WITHDRAWAL  VALUE 'W'.
               88 IS-FEE         VALUE 'F'.
           05  T-AMOUNT          PIC 9(7)V99.

       FD  MASTER-FILE.
       01  MASTER-REC.
           05  M-ACCOUNT-NUM     PIC X(10).
           05  M-BALANCE         PIC S9(9)V99.
           05  M-STATUS          PIC X(01).
               88 IS-ACTIVE      VALUE 'A'.
               88 IS-FROZEN      VALUE 'F'.

       FD  REPORT-FILE.
       01  REPORT-REC            PIC X(80).

       WORKING-STORAGE SECTION.
       01  WS-FLAGS.
           05  WS-EOF-FLAG       PIC X(01) VALUE 'N'.
               88 END-OF-FILE    VALUE 'Y'.
       01  WS-COUNTERS.
           05  WS-RECORDS-READ   PIC 9(5) VALUE 0.
           05  WS-ERRORS-FOUND   PIC 9(5) VALUE 0.
       01  WS-REPORT-LINE.
           05  FILLER            PIC X(10) VALUE 'ACCT: '.
           05  R-ACCT            PIC X(10).
           05  FILLER            PIC X(08) VALUE ' STATUS:'.
           05  R-MSG             PIC X(20).

       PROCEDURE DIVISION.
       0000-MAIN-PROCESSING.
           PERFORM 1000-INITIALIZE.
           PERFORM 2000-PROCESS-RECORDS 
               UNTIL END-OF-FILE.
           PERFORM 3000-TERMINATE.
           STOP RUN.

       1000-INITIALIZE.
           OPEN INPUT TRANS-FILE
           OPEN I-O MASTER-FILE
           OPEN OUTPUT REPORT-FILE
           READ TRANS-FILE
               AT END SET END-OF-FILE TO TRUE
           END-READ.

       2000-PROCESS-RECORDS.
           ADD 1 TO WS-RECORDS-READ
           MOVE T-ACCOUNT-NUM TO M-ACCOUNT-NUM
           
           * Читання головного файлу клієнта
           READ MASTER-FILE
               INVALID KEY 
                   PERFORM 2100-LOG-ERROR
               NOT INVALID KEY
                   PERFORM 2200-UPDATE-BALANCE
           END-READ
           
           READ TRANS-FILE
               AT END SET END-OF-FILE TO TRUE
           END-READ.

       2100-LOG-ERROR.
           ADD 1 TO WS-ERRORS-FOUND
           MOVE T-ACCOUNT-NUM TO R-ACCT
           MOVE 'ACCT NOT FOUND' TO R-MSG
           WRITE REPORT-REC FROM WS-REPORT-LINE.

       2200-UPDATE-BALANCE.
           IF IS-FROZEN
               MOVE T-ACCOUNT-NUM TO R-ACCT
               MOVE 'ACCOUNT FROZEN' TO R-MSG
               WRITE REPORT-REC FROM WS-REPORT-LINE
           ELSE
               EVALUATE TRUE
                   WHEN IS-DEPOSIT
                       COMPUTE M-BALANCE = M-BALANCE + T-AMOUNT
                   WHEN IS-WITHDRAWAL
                   WHEN IS-FEE
                       COMPUTE M-BALANCE = M-BALANCE - T-AMOUNT
               END-EVALUATE
               
               * Перевірка на овердрафт
               IF M-BALANCE < 0
                   MOVE T-ACCOUNT-NUM TO R-ACCT
                   MOVE 'OVERDRAFT ALERT' TO R-MSG
                   WRITE REPORT-REC FROM WS-REPORT-LINE
               END-IF
               
               REWRITE MASTER-REC
           END-IF.

       3000-TERMINATE.
           CLOSE TRANS-FILE
           CLOSE MASTER-FILE
           CLOSE REPORT-FILE
           DISPLAY 'EOD BATCH COMPLETE. RECORDS: ' WS-RECORDS-READ.