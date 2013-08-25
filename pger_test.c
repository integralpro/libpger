//============================================================================
// Name        : pger.c
// Author      : Pavel Prokofiev
// Version     :
// Copyright   : GNU GPL3
//============================================================================

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <pger.h>

void pger_comment(const char *comment) {
    printf("asdasd: %s\n", comment);
}

int main( int argc, char **argv )
{
    if(argc > 1) {
        FILE *f;
        size_t len;
        char *buffer;

        f = fopen(argv[1], "r");
        if(f != NULL) {
            fseek(f, 0, SEEK_END);
            len = (unsigned long)ftell(f);
            fseek(f, 0, SEEK_SET);
            buffer = malloc(len);
            if(fread(buffer, len, 1, f) > 0) {
                pger_parse_buffer(buffer, len);
            }
        }
    }
    return 0;
}
