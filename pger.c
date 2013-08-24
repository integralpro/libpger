/*
 * pger.c
 *
 *  Created on: Aug 15, 2013
 *      Author: pgprokof
 */

#include <stdio.h>
#include <pger.h>

void pger_comment(const char *comment) {
	printf("Comment: %s\n", comment);
}

void pger_param_fs(char zo, char cn, int x, int y) {
	printf("FS: %c %c %d %d\n", zo, cn, x, y);	
}

void pger_param_mo(char scale) {
	printf("MO: %s\n", scale == PARAM_MO_MM ? "mm" : "inch");
}

void pger_param_ip(char polarity) {
	printf("IP: %s\n", polarity == PARAM_IP_POS ? "+" : "-");
}

void pger_param_in(const char *image_name) {
	printf("IN: %s\n", image_name);
}

void pger_param_ad(int aperture_number, const char *aperture_type, int modifiers_count, double *modifiers) {
	printf("AD: D%d, Type:%s", aperture_number, aperture_type);
	if(modifiers_count != 0) {
		int i;
		printf(", ");
		for(i=0;i<modifiers_count;i++) {
			printf("%lf ", modifiers[i]);
		}
	}
	printf("\n");
}

void pger_param_lp(char polarity) {
	printf("LP: %s\n", polarity == PARAM_LP_CLEAR ? "clear" : "dark");
}

void pger_param_sr(int x, int y, double i, double j) {
	printf("SR: x=%d, y=%d, i=%lf, j=%lf\n", x, y, i, j);	
}

void pger_param_ln(const char *level_name) {
	printf("LN: %s\n", level_name);
}
