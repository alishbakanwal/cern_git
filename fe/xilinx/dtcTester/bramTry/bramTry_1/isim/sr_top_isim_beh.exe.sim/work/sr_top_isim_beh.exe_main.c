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
    unisims_ver_m_00000000002122201514_3954492287_init();
    unisims_ver_m_00000000003266096158_2593380106_init();
    work_m_00000000000842360246_1551413239_init();
    xilinxcorelib_ver_m_00000000001358910285_3225360562_init();
    xilinxcorelib_ver_m_00000000001687936702_3350134291_init();
    xilinxcorelib_ver_m_00000000000277421008_3774850172_init();
    xilinxcorelib_ver_m_00000000001603977570_0119708349_init();
    work_m_00000000000403262735_0115168226_init();
    work_m_00000000002113413425_3417465232_init();
    work_m_00000000003024332822_3065854867_init();
    work_m_00000000000196804623_0990381724_init();
    work_m_00000000002243325398_0219934291_init();
    xilinxcorelib_ver_m_00000000002621774987_0790771357_init();
    xilinxcorelib_ver_m_00000000001603977570_0091017234_init();
    work_m_00000000000403262735_3149211191_init();
    work_m_00000000000217044300_2852910833_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000000217044300_2852910833");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
