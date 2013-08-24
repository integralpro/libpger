/*
 * pger.h
 *
 *  Created on: Aug 15, 2013
 *      Author: pgprokof
 */

#ifndef PGER_H_
#define PGER_H_

#define PARAM_FS_L 'L'
#define PARAM_FS_T 'T'
#define PARAM_FS_A 'A'
#define PARAM_FS_I 'I'

#define PARAM_MO_IN 0x10
#define PARAM_MO_MM 0x11

#define PARAM_IP_POS 0x20
#define PARAM_IP_NEG 0x21

#define PARAM_LP_CLEAR 0x30
#define PARAM_LP_DARK 0x31

void pger_comment(const char *);

void pger_param_fs(char zo, char cn, int x, int y);
void pger_param_mo(char scale);
void pger_param_ip(char polarity);
void pger_param_in(const char *image_name);
void pger_param_ad(int aperture_number, const char *aperture_type, int modifiers_count, double *modifiers);
void pger_param_sr(int x, int y, double i, double j);
void pger_param_lp(char polarity);
void pger_param_ln(const char *level_name);

#endif /* PGER_H_ */
