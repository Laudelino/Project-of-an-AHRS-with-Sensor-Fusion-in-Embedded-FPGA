
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7z0202default:defaultZ17-347h px
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7z0202default:defaultZ17-349h px
u
,Running DRC as a precondition to command %s
1349*	planAhead2#
write_bitstream2default:defaultZ12-1349h px
M
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px
�
Rule violation (%s) %s - %s
20*drc2
CFGBVS-12default:default2G
3Missing CFGBVS and CONFIG_VOLTAGE Design Properties2default:default2�
�Neither the CFGBVS nor CONFIG_VOLTAGE voltage property is set in the current_design.  Configuration bank voltage select (CFGBVS) must be set to VCCO or GND, and CONFIG_VOLTAGE must be set to the correct configuration voltage, in order to determine the I/O voltage support for the pins in bank 0.  It is suggested to specify these either using the 'Edit Device Properties' function in the GUI or directly in the XDC file using the following syntax:

 set_property CFGBVS value1 [current_design]
 #where value1 is either VCCO or GND

 set_property CONFIG_VOLTAGE value2 [current_design]
 #where value2 is the voltage provided to configuration bank 0

Refer to the device configuration user guide for more information.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP ACC_INS/SCALE_M/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP input A is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP GYRO_INS/SCALE_M/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP input A is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM2/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM4/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MMS/MX/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP input A is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentCorrect/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentCorrect/QM/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentCorrect/VNL/VdP/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentPredict/MM12/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentPredict/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentPredict/MMS/MX/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP input A is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP KFP/ComponentPredict/QNL/VdP/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1 input C is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPIP-12default:default2$
Input pipelining2default:default2�
�DSP MAG_INS/SCALE_M/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP input A is not pipelined. Pipelining DSP48 input will improve performance.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP ACC_INS/SCALE_M/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP GYRO_INS/SCALE_M/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM2/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM2/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM4/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MM4/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/CSKF/MMS/MX/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/QM/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/QM/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/VNL/VdP/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentCorrect/VNL/VdP/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentPredict/MM12/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentPredict/MM12/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentPredict/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentPredict/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentPredict/MMS/MX/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentPredict/QNL/VdP/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP KFP/ComponentPredict/QNL/VdP/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
DPOP-12default:default2%
Output pipelining2default:default2�
�DSP MAG_INS/SCALE_M/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP output P is not pipelined. Pipelining DSP48 output will improve performance. Both multiplier/adder output can be pipelined.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[10] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[11] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[24] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[25] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[26] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[27] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[33] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[34] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[40] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[41] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[42] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2s
_Device port PS_GPIO[43] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2r
^Device port PS_GPIO[7] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2r
^Device port PS_GPIO[8] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
RPBF-32default:default23
IO port buffering is incomplete2default:default2r
^Device port PS_GPIO[9] expects both input and output buffering but the buffers are incomplete.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�ACC_INS/SCALE_M/U0/i_synth/MULT.OP/MULT/DSP48E1_SPD_SGL_VARIANT.FIX_MULT/DSP1/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�ACC_INS/SCALE_M/U0/i_synth/MULT.OP/MULT/DSP48E1_SPD_SGL_VARIANT.FIX_MULT/DSP2/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�ACC_INS/SCALE_M/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�GYRO_INS/SCALE_M/U0/i_synth/MULT.OP/MULT/DSP48E1_SPD_SGL_VARIANT.FIX_MULT/DSP1/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�GYRO_INS/SCALE_M/U0/i_synth/MULT.OP/MULT/DSP48E1_SPD_SGL_VARIANT.FIX_MULT/DSP2/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�GYRO_INS/SCALE_M/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/ADD/U0/i_synth/ADDSUB_OP.ADDSUB/SPEED_OP.DSP.OP/DSP48E1_BODY.ALIGN_ADD/DSP2/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/ADD/U0/i_synth/ADDSUB_OP.ADDSUB/SPEED_OP.DSP.OP/DSP48E1_BODY.NORM_RND/SHIFT_RND/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MA/ADDX/U0/i_synth/ADDSUB_OP.ADDSUB/SPEED_OP.DSP.OP/DSP48E1_BODY.ALIGN_ADD/DSP2/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MA/ADDX/U0/i_synth/ADDSUB_OP.ADDSUB/SPEED_OP.DSP.OP/DSP48E1_BODY.NORM_RND/SHIFT_RND/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[0].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM2/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM2/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM2/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[0].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM2/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[0].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM3/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM4/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM4/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM4/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[0].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MM4/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MMS/MX/U0/i_synth/MULT.OP/MULT/DSP48E1_SPD_SGL_VARIANT.FIX_MULT/DSP1/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MMS/MX/U0/i_synth/MULT.OP/MULT/DSP48E1_SPD_SGL_VARIANT.FIX_MULT/DSP2/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MMS/MX/U0/i_synth/MULT.OP/R_AND_R/LAT_OPT.FULL.R_AND_R/DSP48E1_SGL_EXP_IP.OLD_ADD.ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MS1/SUBX/U0/i_synth/ADDSUB_OP.ADDSUB/SPEED_OP.DSP.OP/DSP48E1_BODY.ALIGN_ADD/DSP2/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/CSKF/MS1/SUBX/U0/i_synth/ADDSUB_OP.ADDSUB/SPEED_OP.DSP.OP/DSP48E1_BODY.NORM_RND/SHIFT_RND/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[0].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/MM1/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/MS1/SUBX/U0/i_synth/ADDSUB_OP.ADDSUB/SPEED_OP.DSP.OP/DSP48E1_BODY.ALIGN_ADD/DSP2/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/MS1/SUBX/U0/i_synth/ADDSUB_OP.ADDSUB/SPEED_OP.DSP.OP/DSP48E1_BODY.NORM_RND/SHIFT_RND/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/QM/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/QM/VMX/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/QM/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[0].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/QM/VMX/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[1].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/VNL/VdP/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/ALIGN_BLK/FRAC_ADDSUB/DSP_ADD.one_dsp.FRAC_ADDSUB/DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/VNL/VdP/MLAX/U0/i_synth/FMA_OP.OP/addsub/add/NORM/ROUND/DSP48_E1.DSP48E1_ADD.DSP48E1_ADD/DSP: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
Rule violation (%s) %s - %s
20*drc2
AVAL-42default:default2U
Aenum_USE_DPORT_FALSE_enum_DREG_ADREG_0_connects_CED_CEAD_RSTD_GND2default:default2�
�KFP/ComponentCorrect/VNL/VdP/MLAX/U0/i_synth/FMA_OP.OP/mul/MULT/gDSP.gDSP_only.iDSP/use_prim.appDSP48[0].bppDSP48[0].use_dsp.use_dsp48e1.iDSP48E1: DSP48E1 is not using the D port (USE_DPORT = FALSE). For improved power characteristics, set DREG and ADREG to '1', tie CED, CEAD, and RSTD to logic '0'.2default:defaultZ23-20h px
�
�Message '%s' appears more than %s times and has been disabled. User can change this message limit to see more message instances.
14*common2
	Drc 23-202default:default2
1002default:defaultZ17-14h px
s
DRC finished with %s
1905*	planAhead28
$0 Errors, 56 Warnings, 92 Advisories2default:defaultZ12-3199h px
f
BPlease refer to the DRC report (report_drc) for more information.
1906*	planAheadZ12-3200h px
<
Loading data files...
1271*designutilsZ12-1165h px
;
Loading site data...
1273*designutilsZ12-1167h px
<
Loading route data...
1272*designutilsZ12-1166h px
<
Processing options...
1362*designutilsZ12-1514h px
9
Creating bitmap...
1249*designutilsZ12-1141h px
4
Creating bitstream...
7*	bitstreamZ40-7h px
a
Writing bitstream %s...
11*	bitstream2'
./KalmanProject.bit2default:defaultZ40-11h px
C
Bitgen Completed Successfully.
1606*	planAheadZ12-1842h px
p
QWebTalk data collection is enabled (User setting is ON. Install Setting is ON.).
118*projectZ1-118h px
W
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2%
write_bitstream: 2default:default2
00:01:412default:default2
00:01:402default:default2
2529.3202default:default2
438.4962default:defaultZ17-268h px
_
File %s does not exist
147*	vivadotcl2%
KalmanProject.mmi2default:defaultZ4-319h px


End Record