grammar Gerber;

options
{
	language=C;
}

@header {
    #include <pger.h>
}
 
/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/

gerber      :   (statement)* M02 EOB
            ;
 
statement   :	data_block EOB ((data_block EOB)=> data_block EOB)*
            |   PARAM (param EOB)+ PARAM
            ;

param       :
            |   fs | mo | ip | in | ad | sr | lp | ln
            ;

fs          :   FS oz=('L'|'T') cn=('A'|'I') 'X' x=NUMBER 'Y' y=NUMBER {
                    pger_param_fs(
                        $oz.text->chars[0],
                        $cn.text->chars[0],
                        atoi($x.text->chars),
                        atoi($y.text->chars));
                }
            ;

mo          :   MO s=('IN' | 'MM') {
                    char val = $s.text->chars[0];
                    if(val == 'I') {
                        pger_param_mo(PARAM_MO_IN);
                    } else if(val == 'M') {
                        pger_param_mo(PARAM_MO_MM);
                    }
                }
            ;

ip          :   IP s=('POS' | 'NEG') {
                    char val = $s.text->chars[0];
                    if(val == 'P') {
                        pger_param_ip(PARAM_IP_POS);
                    } else if(val == 'N') {
                        pger_param_ip(PARAM_IP_NEG);
                    }
                }
            ;

in          :   IN string {
                    pger_param_in($string.text->chars);
                }
            ;

ad          
@init { int c = 0; double param[256]; }
            :   AD ap=DXX type=('C'|'R'|'O'|'P')
                (
                    ',' p1=NUMBER { param[c++] = atof($p1.text->chars); }
                    ('X' px=NUMBER { param[c++] = atof($px.text->chars); } )*
                )? {
                    pger_param_ad(
                        atoi(&$ap.text->chars[1]),
                        $type.text->chars,
                        c,
                        param
                        );
                }
            ;

sr          :   SR ('X' x=NUMBER)? ('Y' y=NUMBER)? ('I' i=NUMBER)? ('J' j=NUMBER)? {
                    double ii = 0, jj = 0;
                    int xx = 1, yy = 1;
                    if($x != 0) {
                        xx = atoi($x.text->chars);
                    }
                    if($y != 0) {
                        yy = atoi($y.text->chars);
                    }
                    if(i != 0) {
                        ii = atof($i.text->chars);
                    }
                    if(j != 0) {
                        jj = atof($j.text->chars);
                    }
                    pger_param_sr(xx, yy, ii, jj);
                }
            ;

lp          :   LP s=('C' | 'D') {
                    char val = $s.text->chars[0];
                    if(val == 'C') {
                        pger_param_lp(PARAM_LP_CLEAR);
                    } else if(val == 'D') {
                        pger_param_lp(PARAM_LP_DARK);
                    }
                }
            ;

ln          :   LN string {
                    pger_param_ln($string.text->chars);
                }
            ;

data_block  :   op | g04 | G36 | G37 | G74 | G75 | DXX
            ;

g04         :   G04 string { pger_comment($string.text->chars); }
            ;

op          :   (G01|G02|G03)? ('X' NUMBER)? ('Y' NUMBER)? ('I' NUMBER)? ('J' NUMBER)? (D01|D02|D03)?
            ;

string
            :   (~EOB)*
            ;

/*------------------------------------------------------------------
 * LEXER RULES
 *------------------------------------------------------------------*/
 
NUMBER 	:	'-'?(DIGIT)+('.'(DIGIT)+)?;

EOB     :   '*';
PARAM   :   '%';

M02     :   'M'('2'|'02');

D01     :   'D'('1'|'01');
D02     :   'D'('2'|'02');
D03     :   'D'('3'|'03');
DXX     :   'D' '1'..'9' ('0'..'9')+;

G01     :   'G'('1'|'01'); // Linear interpolation interpolation
G02     :   'G'('2'|'02'); // Clockwise circular interpolation
G03     :   'G'('3'|'03'); // Counterclockwise circular interpolation
G04     :   'G'('4'|'04'); // Comment code

G36     :   'G36'; // Set region mode on
G37     :   'G37'; // Set region mode off

G74     :   'G74'; // Set quadrant mode to ‟Single quadrant‟
G75     :   'G75'; // Set quadrant mode to ‟Multi quadrant‟

FS      :   'FS';
MO      :   'MO';
IP      :   'IP';
IN      :   'IN';
AD      :	'AD';
AM      :   'AM';
SR      :   'SR';
LP      :   'LP';
LN      :   'LN';

ID      :   ('a'..'z'|'A'..'Z'|','|'.'|':'|'!')
        ;

WHITESPACE
        : ( '\t' | ' ' | '\r' | '\n'| '\u000C' )+ { $channel = HIDDEN; }
        ;

fragment
DIGIT   :	 '0'..'9';
