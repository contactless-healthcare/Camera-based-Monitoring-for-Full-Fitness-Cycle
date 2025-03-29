% calibrate data
% input: 
% e: ECG data p: PPG data r: rPPG data 
% er: shift between ECG and rPPG
% pr: shift between PPG and rPPG
% return shifted data
function [ecg,ppg,rppg]=calibration(e,p,r,er,pr)
    ecg=e(1,er:end);
    ppg=p(1,pr:end);
    rppg=r;
end