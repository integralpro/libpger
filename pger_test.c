//============================================================================
// Name        : pger.c
// Author      : Pavel Prokofiev
// Version     :
// Copyright   : GNU GPL3
//============================================================================

#include <stdio.h>
#include <stdlib.h>

#include <pger.h>
#include "antlr/GerberLexer.h"
#include "antlr/GerberParser.h"

int main( int argc, char **argv )
{
    pANTLR3_INPUT_STREAM           input;
    pGerberLexer               	   lex;
    pANTLR3_COMMON_TOKEN_STREAM    tokens;
    pGerberParser              	   parser;
 
    input  = antlr3FileStreamNew          ((pANTLR3_UINT8)argv[1], ANTLR3_ENC_8BIT);
    lex    = GerberLexerNew                (input);
    tokens = antlr3CommonTokenStreamSourceNew  (ANTLR3_SIZE_HINT, TOKENSOURCE(lex));
    parser = GerberParserNew               (tokens);
 
    parser  ->gerber(parser);
 
    // Must manually clean up
    //
    parser ->free(parser);
    tokens ->free(tokens);
    lex    ->free(lex);
    input  ->close(input);

    return 0;
}
