       IDENTIFICATION DIVISION.
       PROGRAM-ID. STORDPRC.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT STANDING-ORDER-IN
               ASSIGN TO 'input/standing_orders_feed.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT PROCESSED-OUT
               ASSIGN TO 'output/processed_orders.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT FAILED-OUT
               ASSIGN TO 'output/failed_orders.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT REPORT-OUT
               ASSIGN TO 'output/processing_report.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD STANDING-ORDER-IN.
       01 STANDING-ORDER-REC.
           05 SO-ID                 PIC X(10).
           05 FILLER                PIC X(1).
           05 CUSTOMER-ID           PIC X(10).
           05 FILLER                PIC X(1).
           05 FROM-ACCOUNT          PIC X(15).
           05 FILLER                PIC X(1).
           05 TO-ACCOUNT            PIC X(15).
           05 FILLER                PIC X(1).
           05 PAYMENT-AMOUNT        PIC 9(7)V99.
           05 FILLER                PIC X(1).
           05 PAYMENT-STATUS        PIC X(10).

       FD PROCESSED-OUT.
       01 PROCESSED-REC             PIC X(120).

       FD FAILED-OUT.
       01 FAILED-REC                PIC X(120).

       FD REPORT-OUT.
       01 REPORT-REC                PIC X(120).

       WORKING-STORAGE SECTION.

       01 WS-EOF                    PIC X VALUE 'N'.
       01 WS-TOTAL-COUNT            PIC 9(5) VALUE ZERO.
       01 WS-SUCCESS-COUNT          PIC 9(5) VALUE ZERO.
       01 WS-FAILED-COUNT           PIC 9(5) VALUE ZERO.

       PROCEDURE DIVISION.

       MAIN-PROCESS.

           OPEN INPUT STANDING-ORDER-IN.
           OPEN OUTPUT PROCESSED-OUT.
           OPEN OUTPUT FAILED-OUT.
           OPEN OUTPUT REPORT-OUT.

           PERFORM UNTIL WS-EOF = 'Y'

               READ STANDING-ORDER-IN
                   AT END
                       MOVE 'Y' TO WS-EOF
                   NOT AT END
                       ADD 1 TO WS-TOTAL-COUNT
                       PERFORM PROCESS-STANDING-ORDER
               END-READ

           END-PERFORM.

           PERFORM WRITE-REPORT.

           CLOSE STANDING-ORDER-IN.
           CLOSE PROCESSED-OUT.
           CLOSE FAILED-OUT.
           CLOSE REPORT-OUT.

           DISPLAY 'BATCH PROCESSING COMPLETED'.

           STOP RUN.

       PROCESS-STANDING-ORDER.

           IF PAYMENT-AMOUNT > 0

               ADD 1 TO WS-SUCCESS-COUNT

               STRING
                   'SUCCESS | '
                   SO-ID
                   ' | '
                   CUSTOMER-ID
                   DELIMITED BY SIZE
                   INTO PROCESSED-REC

               WRITE PROCESSED-REC

           ELSE

               ADD 1 TO WS-FAILED-COUNT

               STRING
                   'FAILED  | '
                   SO-ID
                   ' | INVALID AMOUNT'
                   DELIMITED BY SIZE
                   INTO FAILED-REC

               WRITE FAILED-REC

           END-IF.

       WRITE-REPORT.

           WRITE REPORT-REC FROM
               '========================================'.

           WRITE REPORT-REC FROM
               'ABC BANK STANDING ORDER BATCH REPORT'.

           WRITE REPORT-REC FROM
               '========================================'.

           STOP RUN.
