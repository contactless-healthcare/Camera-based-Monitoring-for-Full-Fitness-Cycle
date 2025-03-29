%% Data Processing and Breathing Rate Calculation from PixelFlow & rPPG
clear, clc,close all;
RPPG =[];
% Configure rPPG signal processing parameters
param_rppg = [];
param_rppg.fs        = 60;
param_rppg.L         = param_rppg.fs * 5; % window length: 32|64|128|256
param_rppg.step      = 5; % window sliding step: 1|5
param_rppg.bandwidth = [0.14,1]; % HR band: [40,200] bpm [0.6, 3]
param_rppg.pbv       = [0.3, 0.8, 0.5]; % PBV vector   [0.1, 0.9, 0.6]; % PBV vector - NIR
param_rppg.select    = 'snr_rob'; % selection: mean | snr | snr_rob
param_rppg.max = 60;
param_rppg.minpeakheight = -0;
param_rppg.MinPeakProminence = 10;
param_rppg.minpeakdistance = 60*param_rppg.fs/param_rppg.max;
param_rppg.window = [1000,19000; 19000,37000; 40000,58000; 58000,76000];
param.window = param_rppg.window / param_rppg.fs;
param_rppg.type = 'RPPG';

% Configure PixelFlow processing parameters
param_pf = [];
param_pf.fs        = 60; % 15|20|30
param_pf.L         = param_pf.fs * 5; % window length: 32|64|128|256
param_pf.step      = 5; % window sliding step: 1|5
param_pf.bandwidth = [0.14,1]; % HR band: [40,200] bpm [0.6, 3]
param_pf.max=60;
param_pf.minpeakheight = 0;
param_pf.MinPeakProminence = 1;
param_pf.minpeakdistance = 60 * param_pf.fs/param_pf.max;


path = 'pixelflow rppg data\';
namelist = dir([path,'*.mat']);
len= length(namelist);
for i=1:len
    % Load Data
    name=erase(namelist(i).name,'_pf_rppg_data.mat');
    load(['pixelflow rppg data\',name,'_pf_rppg_data.mat'],'move_rppg_pre','move_flow_pre','move_flow_post','move_rppg_post','Dyf1','Dyf2');
    load(['processed data\rppg data\',name,'_new_rppg.mat'],'rppg_pbv_br');
    rate_data=xlsread(['reference RR data\',name,'\ParameterData\ParameterData.csv']);

    respriation_rate=rate_data(:,7);
    respriation_rate=respriation_rate';
    move_rppg_pre=move_flow_pre;
    move_rppg_post=move_flow_post;
    rppg_pbv=rppg_pbv_br;

    % Apply bandpass filtering to PixelFlow signals
    bandwidth = [0.14,1];
    fs = 60;
    [n, d] = butter(4, bandwidth/(fs/2), 'bandpass');
    Dyf_f1=filtfilt(n,d,Dyf1);
    Dyf_f2=filtfilt(n,d,Dyf2);

    % Filter and normalize signals
    Dyf_f1=Dyf_f1/max(Dyf_f1);
    Dyf_f1=Dyf_f1*100;
    Dyf_f2=Dyf_f2/max(Dyf_f2);
    Dyf_f2=Dyf_f2*100;

    Dyf_f2=Dyf_f2*4;
    Dyf_f1=Dyf_f1*4;


    % Breathing Rate Extraction
    [ibi_dy1,loc_dy1]=ibi_calculation(Dyf_f1',param_pf);
    ibi_dy1=ibi_process(ibi_dy1);
    time_interval = 10000; % 10s
    step = 1000;
    resp_dy1=heart_rate_t(loc_dy1,ibi_dy1,time_interval,step);

    [ibi_dy2,loc_dy2]=ibi_calculation(Dyf_f2',param_pf);
    ibi_dy2=ibi_process(ibi_dy2);
    time_interval = 10000; % 10s
    step = 1000;
    resp_dy2=heart_rate_t(loc_dy2,ibi_dy2,time_interval,step);

    [ibi_rppg_pbv,loc_rppg_pbv]=ibi_calculation(rppg_pbv,param_rppg);
    ibi_rppg_pbv=ibi_process(ibi_rppg_pbv);
    time_interval = 15000; % 10s
    step = 1000;
    rate_rppg_pbv=heart_rate_t(loc_rppg_pbv,ibi_rppg_pbv,time_interval,step);

    % Reference signal segmentation
    rrr=respriation_rate(1,move_rppg_pre:end);
    res_pre=rrr(1:300);
    res_post1=rrr(move_rppg_post:move_rppg_post+299);
    res_post2=rrr(move_rppg_post+300:move_rppg_post+599);

    % rPPG signal segmentation
    pbv_pre=rate_rppg_pbv(10:309);
    pxf1_pre=resp_dy1(10:309);
    pxf2_pre=resp_dy1(10:309);


    % PixelFlow signal segmentation
    pbv_post1=rate_rppg_pbv(end-599:end-300);
    pxf1_post1=resp_dy1(end-599:end-300);
    pxf2_post1=resp_dy2(end-599:end-300);


    pbv_post2=rate_rppg_pbv(end-299:end);
    pxf1_post2=resp_dy1(end-299:end);
    pxf2_post2=resp_dy2(end-299:end);


    pre_post_data={['per row res pbv,chrom,dis,pixel1,pixel2 '],['per col pre post1 post2'],[];
        res_pre, res_post1, res_post2;pbv_pre, pbv_post1, pbv_post2;zeros(1,300), zeros(1,300), zeros(1,300);
        zeros(1,300), zeros(1,300), zeros(1,300);pxf1_pre, pxf1_post1, pxf1_post2; pxf2_pre, pxf2_post1, pxf2_post2};

    % save([name,'_br_pre_post_data'])

end
