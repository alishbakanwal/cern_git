cd D:/cern/xilinx/dtcTester/bramTry/bramTry_1/dtc_2_ublaze
if { [ catch { xload xmp dtc_2_ublaze.xmp } result ] } {
  exit 10
}
xset intstyle default
save proj
exit 0
