# FPGA Parser Design

## Overview

The parser is implemented as a streaming finite state machine (FSM).

Each incoming ASCII character is processed every clock cycle.

The parser never stores an entire log line. Instead, it extracts fields as characters arrive.

---

## State Machine

```
               +------+
               | IDLE |
               +--+---+
                  |
                  v
           +--------------+
           |   READ_IP    |
           +------+-------+
                  |
                  v
          +---------------+
          |  SKIP_IDENT   |
          +------+--------+
                  |
                  v
        +------------------+
        | SKIP_AUTHUSER    |
        +--------+---------+
                 |
                 v
        +------------------+
        | READ_TIMESTAMP   |
        +--------+---------+
                 |
                 v
        +------------------+
        |   READ_METHOD    |
        +--------+---------+
                 |
                 v
        +------------------+
        |    READ_URL      |
        +--------+---------+
                 |
                 v
        +------------------+
        | READ_PROTOCOL    |
        +--------+---------+
                 |
                 v
        +------------------+
        |  READ_STATUS     |
        +--------+---------+
                 |
                 v
        +------------------+
        |  READ_BYTES      |
        +--------+---------+
                 |
                 v
              +------+
              | DONE |
              +------+
```

---

## State Description

### IDLE

- Waits for first valid character
- Clears previous record
- Initializes parser

---

### READ_IP

Extracts the client IP address until the first space.

Example:

```
199.72.81.55
```

---

### SKIP_IDENT

Skips the RFC1413 identity field.

Example:

```
-
```

---

### SKIP_AUTHUSER

Skips authenticated username.

Example:

```
-
```

---

### READ_TIMESTAMP

Captures everything inside:

```
[01/Aug/1995:00:00:01 -0400]
```

without brackets.

---

### READ_METHOD

Extracts HTTP request method.

Examples:

```
GET
POST
HEAD
```

---

### READ_URL

Captures the requested resource.

Example:

```
/images/logo.gif
```

---

### READ_PROTOCOL

Extracts HTTP version.

Example:

```
HTTP/1.0
```

---

### READ_STATUS

Reads the three-digit HTTP response code.

Examples:

```
200
304
404
500
```

---

### READ_BYTES

Reads response size.

Example:

```
1839
```

---

### DONE

- Asserts `valid_record`
- Waits for CPU acknowledgement (`ready`)
- Copies parsed registers to output ports
- Returns to IDLE

---

## Synchronization

The parser uses a simple ready-valid handshake.

```
CPU                 FPGA

valid_in  --------->

ascii_in  --------->

              parse

valid_record <------

ready      -------->

next record
```

---

## Parser Characteristics

- Streaming parser
- One ASCII character per clock
- Deterministic latency
- Constant memory usage
- Fully synthesizable
