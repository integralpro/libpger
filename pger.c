/*
 * pger.c
 *
 *  Created on: Aug 15, 2013
 *      Author: pgprokof
 */

#include <stdio.h>
#include <pger.h>

#include "antlr/GerberLexer.h"
#include "antlr/GerberParser.h"

//#define debug_log(fmt, ...) printf(fmt, ##__VA_ARGS__)
#define debug_log(fmt, ...)

void __attribute__((weak)) pger_comment(const char *comment) {
    debug_log("Comment: %s\n", comment);
}

void __attribute__((weak)) pger_param_fs(char zo, char cn, int x, int y) {
    debug_log("FS: %c %c %d %d\n", zo, cn, x, y);  
}

void __attribute__((weak)) pger_param_mo(char scale) {
    debug_log("MO: %s\n", scale == PARAM_MO_MM ? "mm" : "inch");
}

void __attribute__((weak)) pger_param_ip(char polarity) {
    debug_log("IP: %s\n", polarity == PARAM_IP_POS ? "+" : "-");
}

void __attribute__((weak)) pger_param_in(const char *image_name) {
    debug_log("IN: %s\n", image_name);
}

void __attribute__((weak)) pger_param_ad(int aperture_number, const char *aperture_type, int modifiers_count, double *modifiers) {
    debug_log("AD: D%d, Type:%s", aperture_number, aperture_type);
    if(modifiers_count != 0) {
        int i;
        debug_log(", ");
        for(i=0;i<modifiers_count;i++) {
            debug_log("%lf ", modifiers[i]);
        }
    }
    debug_log("\n");
}

void __attribute__((weak)) pger_param_lp(char polarity) {
    debug_log("LP: %s\n", polarity == PARAM_LP_CLEAR ? "clear" : "dark");
}

void __attribute__((weak)) pger_param_sr(int x, int y, double i, double j) {
    debug_log("SR: x=%d, y=%d, i=%lf, j=%lf\n", x, y, i, j);   
}

void __attribute__((weak)) pger_param_ln(const char *level_name) {
    debug_log("LN: %s\n", level_name);
}

void __attribute__((weak)) pger_func_g(int number) {
    debug_log("G: %d\n", number);
}

void __attribute__((weak)) pger_func_d(int number) {
    debug_log("D: %d\n", number);
}

void __attribute__((weak)) pger_op_interpolation(char interpolation) {
    debug_log("G: %d\n", interpolation);   
}

void __attribute__((weak)) pger_op_x(double x) {
    debug_log("X: %lf\n", x);
}

void __attribute__((weak)) pger_op_y(double y) {
    debug_log("Y: %lf\n", y);
}

void __attribute__((weak)) pger_op_i(double i) {
    debug_log("I: %lf\n", i);
}

void __attribute__((weak)) pger_op_j(double j) {
    debug_log("J: %lf\n", j);
}

void __attribute__((weak)) pger_op_code(int number) {
    debug_log("D: %d\n", number);  
}

void pger_parse_buffer(const char *buffer, int len) {
	pANTLR3_INPUT_STREAM           input;
    pGerberLexer               	   lex;
    pANTLR3_COMMON_TOKEN_STREAM    tokens;
    pGerberParser              	   parser;
 
    input=antlr3StringStreamNew((pANTLR3_UINT8)buffer, ANTLR3_ENC_8BIT, len, "buffer");
    lex=GerberLexerNew(input);
    tokens=antlr3CommonTokenStreamSourceNew(ANTLR3_SIZE_HINT, TOKENSOURCE(lex));
    parser=GerberParserNew(tokens);
 
    parser->gerber(parser);

    parser->free(parser);
    tokens->free(tokens);
    lex->free(lex);
    input->close(input);
}
