#ifndef _GLOBAL_H_
#define _GLOBAL_H_

//LYLS01B & LYLS02B:
//	OFF_LUX 	110  //60lux
//	ON_LUX 		160  //16lux

//LYLS240B Blue Shell:
//16lux:157
//60lux:2400


#define OFF_LUX 	157 //60lux
#define ON_LUX 		2400 //16lux
#define ON				0
#define OFF				1

//MODE0 standard 0~6H 100%; 6~10H brightness%; >10H 100%
//MODE1 0~6H 100%; >6H brightness%;
//MODE2 0~9H 100%; >9H brightness%;
//MODE3 test mode: 0~10S 100%; 10~20s brightness%; >20s 100%
//MODE4 AC 1h 80%--> 3h 100%--> 1h 70%--> 7h 50%
//MODE5 Mr Xie 5h 100% --> 2h 75% --> 4h 50% --> 1h 60%
//MODE6 test1: 5s 100% --> 2s 50% --> 4s 30% --> 1s 80%
#define userMode MODE6//userMode(MODE0~MODExx),need confirm
#define BRIGHTNESS	43//lower than 50% should be add 1~5, the small the larger added.
//BRIGHTNESS smaller than 50: 50+1 / 40+2 / 30+3 / 20+4 / 10+5

extern unsigned int second;
extern unsigned int hour;
extern unsigned char brightness;
typedef enum {FALSE = 0, TRUE = !FALSE} bool;
extern bool isDimmingConfiged;
extern bool timeChanged;
extern bool relayStat;

#endif