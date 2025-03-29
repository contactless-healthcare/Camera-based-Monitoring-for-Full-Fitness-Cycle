clear;clc;close all;

% Define data path and list of .mat files
path = 'er_pr_result\';
namelist = dir([path,'*.mat']);
len= length(namelist);


% Time adjustment parameters for data alignment
gap=[2,5,6,1,4,6,4,4,4,2,5,5,0,0,10,2,5,3,5,0,0,0,4,8,5,6,5,2,5,6,0,0,0,0,5,2];
gap1=[2,1,2,0,2,1,0,-2,-1,0,-3,-1,-1,-1,-2,0,-2,-4,1,-3,0,-10,-2,-2,-3,0,-3,0,-2,1,-4,-2,1,0,3,1];
gap4=[-2,-3,-1,1,-2,2,0,0,0,2,0,2,4,2,4,4,-2,1,-2,3,9,2,4,-4,0,-1,-3,2,-1,-3,3,4,5,-6,-5,1];
gap3=[-2,-3,-1,1,-2,1,0,2,0,2,0,2,4,2,5,8,-1,0,0,8,1,0,8,-2,-2,-1,-9,5,3,-2,0,8,10,5,-2,4];


% Initialize data containers
ppg_all=[];
dis_all=[];
ecg_all=[];

% Main processing loop for each file
for index=1:len
    % Load current data file
    filename{index} = [path,namelist(index).name];
    load(filename{index});

    % Initialize signal containers
    ECG =[];
    PPG =[];
    RPPG =[];

    % Set core analysis parameters
    param=[];
    param.time_interval    = 5000; % Heart rate calculation interval (ms)
    param.step    = 500;  % Sliding window step (ms)
    param.max_heartRate    = 200; % Maximum heart rate limit

    
    % Configure RPPG analysis parameters
    param_rppg = [];
    param_rppg.fs        = 60;
    param_rppg.L         = param_rppg.fs * 5; % window length: 32|64|128|256
    param_rppg.step      = 5; % window sliding step: 1|5
    param_rppg.bandwidth = [0.6,3]; % HR band: [40,200] bpm [0.6, 3]

    param_rppg.pbv       = [0.3, 0.8, 0.5]; % PBV vector   [0.1, 0.9, 0.6]; % PBV vector - NIR

    param_rppg.minpeakheight = -30;
    param_rppg.MinPeakProminence = 5;
    param_rppg.minpeakdistance = 60*param_rppg.fs/param.max_heartRate;

    % Configure PPG analysis parameters
    param_ppg = [];
    param_ppg.fs        = 60; % 15|20|30
    param_ppg.L         = param_ppg.fs * 5; % window length: 32|64|128|256
    param_ppg.step      = 5; % window sliding step: 1|5
    param_ppg.bandwidth = param_rppg.bandwidth; % HR band: [40,200] bpm [0.6, 3]

    param_ppg.minpeakheight = -0;
    param_ppg.MinPeakProminence = 8;
    param_ppg.minpeakdistance = 60 * param_ppg.fs/param.max_heartRate;

    % Configure ECG analysis parameters
    param_ecg=[];
    param_ecg.fs        = 500; % ECG sampling rate
    param_ecg.L         = param_ecg.fs * 5;
    param_ecg.bandwidth = [4,30]; % HR band: [40,200] bpm [0.6, 3]

    param_ecg.minpeakheight = 100;
    param_ecg.MinPeakProminence = 100;
    param_ecg.minpeakdistance = 60 * param_ecg.fs/param.max_heartRate;

    param_ecg.type = 'ECG';
    param_ppg.type = 'PPG';
    param_rppg.type = 'RPPG';


    name=erase(namelist(index).name,'_hr_hrv_result.mat');
    Path=['reference ECG data\',name,'\WaveformData\'];
    load(['processed data\rppg data\',name,'_new_rppg.mat']);
    
    % Apply time adjustments to each data
    if (index<=14)
        pr_post1=pr_post+gap(index);
        er_post1=er_post+gap(index);
        pr_post2=pr_post+300+gap(index);
        er_post2=er_post+300+gap(index);
    end
    if(index>15)
        pr_post1=pr_post1+gap(index);
        er_post1=er_post1+gap(index);
        pr_post2=pr_post2+gap(index);
        er_post2=er_post2+gap(index);
    end
    er_pre=er_pre+gap1(index);
    er_post1=er_post1+gap3(index);
    er_post2=er_post2+gap4(index);
    pr_pre=pr_pre+gap1(index);
    pr_post1=pr_post1+gap3(index);
    pr_post2=pr_post2+gap4(index);

    % Read and preprocess ECG data
    ecg = readmatrix([Path,'ECG.csv']);
    ecg = ecg(:,2:end)';
    ecg=ecg(:);

    bandwidth = [4,30];
    fs = 500;
    [n, d] = butter(4, bandwidth/(fs/2), 'bandpass');
    ecg = filtfilt(n,d,ecg);
    
    % Read and preprocess PPG data
    ppg = readmatrix([Path,'Pleth.csv']);
    ppg = ppg(:,2:end)';
    ppg=ppg(:);

    bandwidth = [0.6,3];
    fs = 60;
    [n, d] = butter(4, bandwidth/(fs/2), 'bandpass');
    ppg = filtfilt(n,d,ppg);

    % Process RPPG data
    rppg_dis=rppg_dis_hr;
    l=length(rppg_dis);

    % Define analysis intervals for different phases
    inter_rppg=[10*60,309*60;310*60,679*60;l-(609)*60,l-310*60;l-309*60,l-10*60];
    inter_ppg=[pr_pre*60,(pr_pre+299)*60;(pr_pre+300)*60,(pr_pre+669)*60;(pr_post1)*60,(pr_post1+299)*60;(pr_post2)*60,(pr_post2+299)*60];
    inter_ecg=[er_pre*500,(er_pre+299)*500;(er_pre+200)*500,(er_pre+839)*500;(er_post1-160)*500,(er_post1+299)*500;(er_post2)*500,(er_post2+299)*500];

    time_interval = 5000; % 5-second analysis window
    step = 500;% 0.5-second sliding step

    hr_ecg={};
    hr_ppg={};
    hr_rppg_dis={};
    hr_rppg_pbv={};
    hr_rppg_chrom={};
    hr_ecg_1={};

    % Calculate heart rates for different signal types
    for i=1:4
        
        % Process ECG-derived heart rate
        [ibi_ecg_n,loc_ecg_n]=ibi_calculation(ecg(round(inter_ecg(i)):round(inter_ecg(i+4)),1),param_ecg);
        ibi_ecg_n=ibi_process(ibi_ecg_n);
        hr_ecg_n=heart_rate_t(loc_ecg_n,ibi_ecg_n,time_interval,step);
        
        % Special handling for exercise phase data
        if(i==2)
            hr_ecg{1,i}=hr_ecg_n(201:910);
        else
            if (i==3)
                hr_ecg{1,i}=hr_ecg_n(320:end);
            else
                hr_ecg{1,i}=hr_ecg_n;
            end
        end


        % Process PPG-derived heart rate
        [ibi_ppg_n,loc_ppg_n]=ibi_calculation(ppg(round(inter_ppg(i)):round(inter_ppg(i+4)),1),param_ppg);
        ibi_ppg_n=ibi_process(ibi_ppg_n);
        hr_ppg_n=heart_rate_t(loc_ppg_n,ibi_ppg_n,time_interval,step);
        hr_ppg{1,i}=hr_ppg_n;


        % Process RPPG-derived heart rate
        [ibi_rppg_dis_n,loc_rppg_dis_n]=ibi_calculation(rppg_dis(round(inter_rppg(i)):round(inter_rppg(i+4)),1),param_rppg);
        ibi_rppg_dis_n=ibi_process(ibi_rppg_dis_n);
        hr_rppg_dis_n=heart_rate_t(loc_rppg_dis_n,ibi_rppg_dis_n,time_interval,step);
        hr_rppg_dis{1,i}=hr_rppg_dis_n;

    end


    T={' pre';' in sport';' post1';' post2'};
    
    % Perform calibration between measurement modalities
    for i=1:4
            calibration(hr_ecg{1,i},hr_ppg{1,i},hr_rppg_dis{1,i},1,1);
    end


    hr_pre_post_data={['per row  ecg ppg pbv chrom dis'],['per col pre in post1 post2'],[],[]};
    for i=1:4

        hr_pre_post_data{2,i}=hr_ecg{1,i};
        hr_pre_post_data{3,i}=hr_ppg{1,i};
        hr_pre_post_data{6,i}=hr_rppg_dis{1,i};

    end

    %% Heart Rate Variability (HRV) analysis section
    plt=false;
    
    % Define analysis intervals for different phases
    inter_rppg=[10*60,309*60;l-609*60,l-310*60;l-309*60,l-10*60];
    inter_ppg=[pr_pre*60,(pr_pre+299)*60;(pr_post1)*60,(pr_post1+299)*60;(pr_post2)*60,(pr_post2+299)*60];
    inter_ecg=[er_pre*500,(er_pre+299)*500;er_post1*500,(er_post1+299)*500;(er_post2)*500,(er_post2+299)*500];

    t_e=[];f_e=[];n_e=[];
    t_p=[];f_p=[];n_p=[];
    t_r_pbv=[];f_r_pbv=[];n_r_pbv=[];
    t_r_chrom=[];f_r_chrom=[];n_r_chrom=[];
    t_r_dis=[];f_r_dis=[];n_r_dis=[];


    for i=1:3

        % Calculate HRV metrics for ECG
        [ibi_ecg_n,loc_ecg_n]=ibi_calculation(ecg(round(inter_ecg(i)):round(inter_ecg(i+3)),1),param_ecg);
        ibi_ecg_n=ibi_process(ibi_ecg_n);
        [t_ecg,f_ecg,n_ecg]=HRV_analysis(loc_ecg_n,ibi_ecg_n,param_ecg,plt,i);
        t_e=[t_e;t_ecg];f_e=[f_e;f_ecg];n_e=[n_e;n_ecg];

        % Calculate HRV metrics for PPG
        [ibi_ppg_n,loc_ppg_n]=ibi_calculation(ppg(round(inter_ppg(i)):round(inter_ppg(i+3)),1),param_ppg);
        ibi_ppg_n=ibi_process(ibi_ppg_n);
        [t_ppg,f_ppg,n_ppg]=HRV_analysis(loc_ppg_n,ibi_ppg_n,param_ppg,plt,i);
        t_p=[t_p;t_ppg];f_p=[f_p;f_ppg];n_p=[n_p;n_ppg];

        % Calculate HRV metrics for RPPG
        [ibi_rppg_dis_n,loc_rppg_dis_n]=ibi_calculation(rppg_dis(round(inter_rppg(i)):round(inter_rppg(i+3)),1),param_rppg);
        ibi_rppg_dis_n=ibi_process(ibi_rppg_dis_n);
        [t_rppg,f_rppg,n_rppg]=HRV_analysis(loc_rppg_dis_n,ibi_rppg_dis_n,param_rppg,plt,i);
        t_r_dis=[t_r_dis;t_rppg];f_r_dis=[f_r_dis;f_rppg];n_r_dis=[n_r_dis;n_rppg];

    end

    %     save([name,'_hrv_result'],'t_e','f_e','n_e','t_p','f_p','n_p','t_r_pbv','f_r_pbv','n_r_pbv','t_r_chrom','f_r_chrom','n_r_chrom','t_r_dis','f_r_dis','n_r_dis');

end
