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

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    unisims_ver_m_00000000001946988858_2297623829_init();
    unisims_ver_m_00000000002122201514_3213271879_init();
    unisims_ver_m_00000000003266096158_2593380106_init();
    work_m_00000000003590662303_1551413239_init();
    xilinxcorelib_ver_m_00000000001358910285_0451433967_init();
    xilinxcorelib_ver_m_00000000001687936702_4285826714_init();
    xilinxcorelib_ver_m_00000000000277421008_2237369876_init();
    xilinxcorelib_ver_m_00000000001603977570_1515357432_init();
    work_m_00000000000403262735_0115168226_init();
    work_m_00000000002113413425_3417465232_init();
    work_m_00000000003024332822_3065854867_init();
    work_m_00000000000196804623_0990381724_init();
    work_m_00000000000077756147_2284804263_init();
    work_m_00000000002957162593_2852910833_init();
    work_m_00000000000549201654_0045943269_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000000549201654_0045943269");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
