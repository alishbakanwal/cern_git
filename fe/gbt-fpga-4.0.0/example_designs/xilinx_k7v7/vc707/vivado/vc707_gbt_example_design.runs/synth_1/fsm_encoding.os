
 add_fsm_encoding \
       {xlx_k7v7_gtx_TX_MANUAL_PHASE_ALIGN.tx_phalign_manual_state} \
       { }  \
       {{0000 000001} {0001 000010} {0010 000100} {0011 001000} {0100 010000} {1000 100000} }

 add_fsm_encoding \
       {xlx_k7v7_gtx_TX_STARTUP_FSM.tx_state} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} {101 101} {110 110} }

 add_fsm_encoding \
       {xlx_k7v7_gtx_RX_STARTUP_FSM.rx_state} \
       { }  \
       {{0000 0000} {0001 0001} {0010 0010} {0011 0011} {0100 0100} {0101 0101} {0110 0110} {0111 0111} {1000 1000} }

 add_fsm_encoding \
       {mgt_latopt_bitslipctrl.state} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} {101 101} }
