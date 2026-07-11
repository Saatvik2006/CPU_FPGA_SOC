#ifndef LOG_RECORD_H
#define LOG_RECORD_H

struct LogRecord {

    char ip[256];

    char timestamp[32];

    char method[8];

    char url[256];

    char protocol[16];

    char status[8];

    char bytes[16];

};

#endif
