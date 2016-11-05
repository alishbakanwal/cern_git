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
    xilinxcorelib_ver_m_00000000000200492576_0461066331_init();
    xilinxcorelib_ver_m_00000000004070129099_1923963788_init();
    xilinxcorelib_ver_m_00000000001159543956_0594800704_init();
    xilinxcorelib_ver_m_00000000001291582275_3736776188_init();
    work_m_00000000000854028453_2265217525_init();
    work_m_00000000000972765329_0087993522_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000000972765329_0087993522");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
