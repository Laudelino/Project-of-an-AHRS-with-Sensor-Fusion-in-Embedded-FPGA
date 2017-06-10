-- (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xillybus:xillybus:xillybus_lite:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY vivado_system_xillybus_lite_0_0 IS
  PORT (
    S_AXI_ACLK : IN STD_LOGIC;
    S_AXI_ARESETN : IN STD_LOGIC;
    S_AXI_AWVALID : IN STD_LOGIC;
    S_AXI_WVALID : IN STD_LOGIC;
    S_AXI_BREADY : IN STD_LOGIC;
    S_AXI_ARVALID : IN STD_LOGIC;
    S_AXI_RREADY : IN STD_LOGIC;
    user_irq : IN STD_LOGIC;
    S_AXI_ARREADY : OUT STD_LOGIC;
    S_AXI_RVALID : OUT STD_LOGIC;
    S_AXI_WREADY : OUT STD_LOGIC;
    S_AXI_BVALID : OUT STD_LOGIC;
    S_AXI_AWREADY : OUT STD_LOGIC;
    host_interrupt : OUT STD_LOGIC;
    user_clk : OUT STD_LOGIC;
    user_wren : OUT STD_LOGIC;
    user_rden : OUT STD_LOGIC;
    S_AXI_AWADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_ARADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    user_rd_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    user_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    user_wr_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    user_addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END vivado_system_xillybus_lite_0_0;

ARCHITECTURE vivado_system_xillybus_lite_0_0_arch OF vivado_system_xillybus_lite_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : string;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF vivado_system_xillybus_lite_0_0_arch: ARCHITECTURE IS "yes";

  COMPONENT xillybus_lite IS
    PORT (
      S_AXI_ACLK : IN STD_LOGIC;
      S_AXI_ARESETN : IN STD_LOGIC;
      S_AXI_AWVALID : IN STD_LOGIC;
      S_AXI_WVALID : IN STD_LOGIC;
      S_AXI_BREADY : IN STD_LOGIC;
      S_AXI_ARVALID : IN STD_LOGIC;
      S_AXI_RREADY : IN STD_LOGIC;
      user_irq : IN STD_LOGIC;
      S_AXI_ARREADY : OUT STD_LOGIC;
      S_AXI_RVALID : OUT STD_LOGIC;
      S_AXI_WREADY : OUT STD_LOGIC;
      S_AXI_BVALID : OUT STD_LOGIC;
      S_AXI_AWREADY : OUT STD_LOGIC;
      host_interrupt : OUT STD_LOGIC;
      user_clk : OUT STD_LOGIC;
      user_wren : OUT STD_LOGIC;
      user_rden : OUT STD_LOGIC;
      S_AXI_AWADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_AXI_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_AXI_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      S_AXI_ARADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      user_rd_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_AXI_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_AXI_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      S_AXI_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      user_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      user_wr_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      user_addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT xillybus_lite;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF vivado_system_xillybus_lite_0_0_arch: ARCHITECTURE IS "xillybus_lite,Vivado 2014.4";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF vivado_system_xillybus_lite_0_0_arch : ARCHITECTURE IS "vivado_system_xillybus_lite_0_0,xillybus_lite,{}";
  ATTRIBUTE BOX_TYPE : STRING;
  ATTRIBUTE BOX_TYPE OF xillybus_lite : COMPONENT IS "black_box";
  ATTRIBUTE BLACK_BOX : BOOLEAN;
  ATTRIBUTE BLACK_BOX OF xillybus_lite : COMPONENT IS TRUE;
  ATTRIBUTE SYN_BLACK_BOX : BOOLEAN;
  ATTRIBUTE SYN_BLACK_BOX OF xillybus_lite : COMPONENT IS TRUE;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ACLK: SIGNAL IS "xilinx.com:signal:clock:1.0 s_axi_clk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ARESETN: SIGNAL IS "xilinx.com:signal:reset:1.0 s_axi_resetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_AWVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_WVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_BREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ARVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_RREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ARREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_RVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_WREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_BVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_AWREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF host_interrupt: SIGNAL IS "xilinx.com:signal:interrupt:1.0 host_interrupt INTERRUPT";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_AWADDR: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_WDATA: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_WSTRB: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_ARADDR: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_RDATA: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_RRESP: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF S_AXI_BRESP: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI BRESP";
BEGIN
  U0 : xillybus_lite
    PORT MAP (
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      user_irq => user_irq,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
      host_interrupt => host_interrupt,
      user_clk => user_clk,
      user_wren => user_wren,
      user_rden => user_rden,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_ARADDR => S_AXI_ARADDR,
      user_rd_data => user_rd_data,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_BRESP => S_AXI_BRESP,
      user_wstrb => user_wstrb,
      user_wr_data => user_wr_data,
      user_addr => user_addr
    );
END vivado_system_xillybus_lite_0_0_arch;
