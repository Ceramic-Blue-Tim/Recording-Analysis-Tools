classdef GlobalsParams
   properties (Constant)
      % Parameters MCS system
      MCS_ELECTRODES_LAYOUT        = [(12:17)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(82:87)'];
      MCS_ELECTRODES_LABEL         = [11:28 31:48 51:68 71:88]';
      MCS_LUT_SEL                  = 1;
      MCS_NB_CH                    = 60;

      % Parameters MED64 system
      MED64_ELECTRODES_LAYOUT      = [(1:8:57)'; (2:8:58)'; (3:8:59)'; (4:8:60)'; (5:8:61)'; (6:8:62)'; (7:8:63)'; (8:8:64)';]; % Custom layout Ikeuchi Lab
      MED64_ELECTRODES_LABEL       = [1:64]';
      MED64_LUT_SEL                = 2;
      MED64_NB_CH                  = 64;
     
      % <EDIT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      DEFAULT_FS                   = 20e3; % [Hz]
      DEFAULT_ELECTRODES_LAYOUT    = GlobalsParams.MED64_ELECTRODES_LAYOUT;
      DEFAULT_ELECTRODES_LABEL     = GlobalsParams.MED64_ELECTRODES_LABEL;
      DEFAULT_LUT_SEL              = GlobalsParams.MED64_LUT_SEL;
      DEFAULT_NB_CH                = GlobalsParams.MED64_NB_CH;
      % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
      % Handling defines 
      DEFAULT_FS_CHAR              = char(string(GlobalsParams.DEFAULT_FS));
   end
end