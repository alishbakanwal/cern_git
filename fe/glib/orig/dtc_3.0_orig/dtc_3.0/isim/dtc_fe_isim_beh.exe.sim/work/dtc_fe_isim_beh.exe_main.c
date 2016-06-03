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
    unisims_ver_m_00000000002122201514_3854461679_init();
    unisims_ver_m_00000000003266096158_2593380106_init();
    work_m_00000000003590662303_2450937180_init();
    xilinxcorelib_ver_m_00000000001358910285_0557399724_init();
    xilinxcorelib_ver_m_00000000001687936702_1632388587_init();
    xilinxcorelib_ver_m_00000000000277421008_0613324510_init();
    xilinxcorelib_ver_m_00000000001603977570_2026758945_init();
    work_m_00000000000403262735_0120586060_init();
    xilinxcorelib_ver_m_00000000001382328732_2704703557_init();
    xilinxcorelib_ver_m_00000000000874300281_4066983563_init();
    xilinxcorelib_ver_m_00000000001291582275_0420211089_init();
    work_m_00000000003724857035_4280547677_init();
    work_m_00000000002455962514_1649908883_init();
    work_m_00000000004164996728_3417465232_init();
    work_m_00000000000395970053_3065854867_init();
    work_m_00000000003795992950_0157450440_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000003795992950_0157450440");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
