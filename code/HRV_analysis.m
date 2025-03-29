function [TD, FD, NL] = HRV_analysis(loc, ibi, param, plt,index)

% TD = [ibi_mean, sdnn, rmssd, pnn50, pnn20];
% FD = [HF, LF, VLF, LF_HF_ratio];
% NL = [sd1, sd2, sd1_sd2_ratio];

HF_limits  = [0.15 0.4]; % limits of high frequencies
LF_limits  = [0.04 0.15]; % limits of low frequencies
VLF_limits = [0.0033 0.04];% limits of very low frequencies

if plt
    fig = figure('Color','w','Position',[100,100,1200,400]);
    subplot('Position',[0.06,0.13,0.26,0.8]);plot(loc,ibi,'-r','LineWidth',1);hold on;scatter(loc,ibi,50,'.b');
    xlabel('time(ms)');ylabel('IBI(ms)');title(['IBI of ',param.type, num2str(index)]);axis tight;
end

dif = ones(length(ibi)-1,1);
for j = 1:length(ibi)-1
    dif(j)=abs(ibi(j+1)-ibi(j));
end

% time domain
ibi_mean = roundn(mean(ibi),-2);
sdnn=roundn(std(ibi,1),-2);
rmssd=roundn(sqrt(var(dif)),-2);

nn50_index=dif>50;
nn50=dif(nn50_index);
pnn50 = roundn(length(nn50) / length(dif),-4);

nn20_index=dif>20;
nn20=dif(nn20_index);
pnn20 = roundn(length(nn20) / length(dif),-4);

TD = [ibi_mean, sdnn, rmssd, pnn50, pnn20];

% frequency domain
loc = loc/1000;
t=linspace(loc(1),loc(length(loc)),loc(length(loc)) * param.fs);
y = spline(loc,ibi,t);

% t_max = tnn(end);
% f_min = min(VLF_limits(1));
% f_max = HF_limits(2);

L = length(y);
ibi_m = y - mean(y);
Y = fft(ibi_m);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

PSD_Freq = param.fs * (0:(L/2))/L;
PSD = abs(P1).^2;

if plt

   
    subplot('Position',[0.37,0.13,0.26,0.8]);plot(PSD_Freq,PSD,'LineWidth',1);xlim([VLF_limits(1),HF_limits(2)]);
    title(['Energy Spectrum of ',param.type, num2str(index)])
    xlabel('f (Hz)')
    ylabel('Energy')
end

HF           = roundn(sum( PSD( PSD_Freq > HF_limits(1)  & PSD_Freq < HF_limits(2))),-2); % sum squere of energy for high frequencys
LF           = roundn(sum( PSD( PSD_Freq > LF_limits(1)  & PSD_Freq < LF_limits(2))),-2) ; % sum squere of energy for low frequencys
VLF          = roundn(sum( PSD( PSD_Freq > VLF_limits(1)  & PSD_Freq < VLF_limits(2))),-2) ; % sum squere of energy for very low frequencys
LF_HF_ratio  = roundn(LF/HF, -4);

% s = HF+LF+VLF;
% HF = HF/s;
% LF = LF/s;
% VLF= VLF/s;

FD=[HF, LF, VLF, LF_HF_ratio];

% non linear
ibi = reshape(ibi, 1, length(ibi));

% Create x and y vectors (_old is data in the original coordinate system)
x_old = ibi(1:end-2);   % RR(n)
y_old = ibi(2:end-1);   % RR(n+1)
z_old = ibi(3:end);

if plt
%     figure, scatter3(x_old,y_old,z_old); title(['3 dimension Poincare plot-',param.type]);
end

% Rotate the data to the new coordinate system
alpha = -pi/4;

% _new is the square-filtered data in the new coordinate system
rri_rotated = rotation_matrix(alpha) * [x_old; y_old];
x_new = rri_rotated(1,:);
y_new = rri_rotated(2,:);

% Calculate standard deviation along the new axes
sd1 = roundn(sqrt(var(y_new)),-2); % sd1
sd2 = roundn(sqrt(var(x_new)),-2); % sd2
sd1_sd2_ratio = roundn(sd1/sd2,-4); % sd1/sd2
NL=[sd1, sd2, sd1_sd2_ratio];

r_x = 2*sd2;
r_y = 2*sd1;

% Ellipse center
c_x = mean(x_new);
c_y = mean(y_new);

% Ellipse parametric equation
t = linspace(0, 2 * pi, 200);
xt = r_x * cos(t) + c_x;
yt = r_y * sin(t) + c_y;

% Rotate the ellipse back to the old coordinate system
ellipse_old = rotation_matrix(-alpha) * [xt; yt];
if plt
    % figure, scatter(ellipse_old(1,:),ellipse_old(2,:)); title('After process Poincare plot');
    %     figure,
    subplot('Position',[0.68,0.13,0.26,0.8]);scatter(x_old,y_old);hold on; scatter(ellipse_old(1,:),ellipse_old(2,:),'r+');
    xlabel('time(ms)');ylabel('time(ms)');title(['Poincare plot-',param.type, num2str(index)]);
    xlim([300,1000]);ylim([300,1000]);
    x=300:1000;
    plot(x,x);hold off;
%     saveas(fig,[savepath,param.type,'-',num2str(index),'.jpg']);
end

    function rotation_mat = rotation_matrix(theta)
        rotation_mat = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    end

end

