# ABC Bank Standing Order Batch Processing

## Overview
This repository contains a sample COBOL batch application for processing standing orders in a Core Banking System (CBS).

## Features
- COBOL batch processing
- 55 standing order feed records
- Success and failure outputs
- JCL execution sample
- Processing report

## Folder Structure

abc-bank-standing-order-batch/
├── cobol/
├── jcl/
├── input/
├── output/

## Compile

```bash
cobc -x STORDPRC.cbl
```

## Run

```bash
./STORDPRC
```

## Business Flow

1. Read standing order feed
2. Validate records
3. Process payments
4. Generate outputs
5. Create final report

## Modernization Opportunities
- Spring Batch
- Kafka
- Microservices
- Kubernetes CronJobs
