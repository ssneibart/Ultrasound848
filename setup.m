addpath(genpath('Code'))
beamformer = @beamform_tjg17_ssn6_bz45_jko11;
bf_params = struct('FocusFractions',[1,2,3,4,5]*0.18,'FNumb',30,'Gain',0.0015,'SampleFraction',0.9);