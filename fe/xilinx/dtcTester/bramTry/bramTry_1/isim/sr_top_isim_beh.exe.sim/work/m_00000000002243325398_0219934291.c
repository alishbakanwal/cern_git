/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ef4fb42 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/cern/xilinx/dtcTester/bramTry/bramTry_1/sr.v";



static void Always_17_0(char *t0)
{
    char t11[8];
    char t12[8];
    char t24[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t13;
    char *t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;
    char *t23;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    char *t32;

LAB0:    t1 = (t0 + 1800U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(17, ng0);
    t2 = (t0 + 2140);
    *((int *)t2) = 1;
    t3 = (t0 + 1828);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(18, ng0);

LAB5:    xsi_set_current_line(19, ng0);
    t4 = (t0 + 864U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(23, ng0);
    t2 = (t0 + 1184);
    t3 = (t2 + 36U);
    t4 = *((char **)t3);
    memset(t12, 0, 8);
    t5 = (t12 + 4);
    t13 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 1);
    *((unsigned int *)t12) = t7;
    t8 = *((unsigned int *)t13);
    t9 = (t8 >> 1);
    *((unsigned int *)t5) = t9;
    t10 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t10 & 127U);
    t16 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t16 & 127U);
    t14 = (t0 + 1184);
    t15 = (t14 + 36U);
    t22 = *((char **)t15);
    memset(t24, 0, 8);
    t23 = (t24 + 4);
    t25 = (t22 + 4);
    t17 = *((unsigned int *)t22);
    t18 = (t17 >> 0);
    t19 = (t18 & 1);
    *((unsigned int *)t24) = t19;
    t20 = *((unsigned int *)t25);
    t21 = (t20 >> 0);
    t26 = (t21 & 1);
    *((unsigned int *)t23) = t26;
    xsi_vlogtype_concat(t11, 8, 8, 2U, t24, 1, t12, 7);
    t32 = (t0 + 1184);
    xsi_vlogvar_wait_assign_value(t32, t11, 0, 0, 8, 0LL);

LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(20, ng0);
    t13 = (t0 + 680U);
    t14 = *((char **)t13);
    memset(t12, 0, 8);
    t13 = (t12 + 4);
    t15 = (t14 + 4);
    t16 = *((unsigned int *)t14);
    t17 = (t16 >> 1);
    *((unsigned int *)t12) = t17;
    t18 = *((unsigned int *)t15);
    t19 = (t18 >> 1);
    *((unsigned int *)t13) = t19;
    t20 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t20 & 127U);
    t21 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t21 & 127U);
    t22 = (t0 + 680U);
    t23 = *((char **)t22);
    memset(t24, 0, 8);
    t22 = (t24 + 4);
    t25 = (t23 + 4);
    t26 = *((unsigned int *)t23);
    t27 = (t26 >> 0);
    t28 = (t27 & 1);
    *((unsigned int *)t24) = t28;
    t29 = *((unsigned int *)t25);
    t30 = (t29 >> 0);
    t31 = (t30 & 1);
    *((unsigned int *)t22) = t31;
    xsi_vlogtype_concat(t11, 8, 8, 2U, t24, 1, t12, 7);
    t32 = (t0 + 1184);
    xsi_vlogvar_wait_assign_value(t32, t11, 0, 0, 8, 0LL);
    goto LAB8;

}

static void Always_26_1(char *t0)
{
    char t7[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;

LAB0:    t1 = (t0 + 1944U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(26, ng0);
    t2 = (t0 + 2148);
    *((int *)t2) = 1;
    t3 = (t0 + 1972);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(27, ng0);

LAB5:    xsi_set_current_line(28, ng0);
    t4 = (t0 + 1184);
    t5 = (t4 + 36U);
    t6 = *((char **)t5);
    memset(t7, 0, 8);
    t8 = (t7 + 4);
    t9 = (t6 + 4);
    t10 = *((unsigned int *)t6);
    t11 = (t10 >> 7);
    t12 = (t11 & 1);
    *((unsigned int *)t7) = t12;
    t13 = *((unsigned int *)t9);
    t14 = (t13 >> 7);
    t15 = (t14 & 1);
    *((unsigned int *)t8) = t15;
    t16 = (t0 + 1092);
    xsi_vlogvar_assign_value(t16, t7, 0, 0, 1);
    goto LAB2;

}


extern void work_m_00000000002243325398_0219934291_init()
{
	static char *pe[] = {(void *)Always_17_0,(void *)Always_26_1};
	xsi_register_didat("work_m_00000000002243325398_0219934291", "isim/sr_top_isim_beh.exe.sim/work/m_00000000002243325398_0219934291.didat");
	xsi_register_executes(pe);
}
