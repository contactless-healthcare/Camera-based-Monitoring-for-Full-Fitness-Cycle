% extract Pixflow and PBV signal
clear;
clc;
close all;

% set your path to the RGB traces
name='demo_sample';
filepath = ['demo\',name];

% obtain rPPG for HR calculation
rppg_hr_demo = get_rppg(filepath,'dis',[0.6 3]);

% obtain rPPG for RR calculation
rppg_rr_demo = get_rppg(filepath,'pbv',[0.14 1]);



