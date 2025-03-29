function [ibi,loc,pks] = ibi_calculation(signal,param)

param.minpeakdistance = 60*param.fs/200; % 200代表最大心率

% ibi计算
[~,loc_1]=findpeaks(signal,'minpeakheight',param.minpeakheight,'MinPeakProminence',param.MinPeakProminence,'minpeakdistance',param.minpeakdistance);

loc_1= loc_1./param.fs*1000; %ms

ibi_1=ones(length(loc_1)-1,1);
for j=1:length(loc_1)-1
    ibi_1(j)=loc_1(j+1)-loc_1(j);
end

% 利用第一次寻峰的结果作为先验，再次进行寻峰
mu = mean(ibi_1);
sigma = std(ibi_1);
param.minpeakdistance = max((mu-4*sigma)/1000*param.fs,mu*0.0006*param.fs);
[pks,loc_2]=findpeaks(signal,'minpeakheight',param.minpeakheight,'MinPeakProminence',param.MinPeakProminence,'minpeakdistance',param.minpeakdistance);

loc_2= loc_2./param.fs*1000; %ms

ibi_2=ones(length(loc_2)-1,1);
for j=1:length(loc_2)-1
    ibi_2(j)=loc_2(j+1)-loc_2(j);
end

mu2 = mean(ibi_2);
sigma2 = std(ibi_2);

ibi_f = ibi_2;
threshold = min(4*sigma2,200);
for i = 4:length(ibi_2)-3
    if(abs(ibi_2(i)-mu2)>threshold)
        ibi_f(i) = median([ibi_f(i-3),ibi_f(i-2),ibi_f(i-1),ibi_f(i+2),ibi_f(i+3),ibi_f(i+1)]);
    end
end

ibi = ibi_f(4:length(ibi_2)-3);
loc = loc_2(4:length(ibi_2)-3);

% -----------------------------
win = 100;
n = length(ibi)/win;

if(n>0)
    for i = 1:n
        ibi((i-1)*100+1:i*100) = filt(ibi((i-1)*100+1:i*100),4);
    end
    ibi(n*100+1:end) = filt(ibi(n*100+1:end),4);
else
    ibi = filt(ibi,4);
end


end

function [s_f] = filt(signal,n) % n 表示滤除n*sigma之外的数据

if(isempty(signal))
    s_f = signal;
    return
end

mu = mean(signal);
sigma = std(signal);
s_f = signal;

for i = 4:length(signal)-3
    if(abs(signal(i)-mu)>n*sigma)
        s_f(i) = mean([signal(i-3),signal(i-2),signal(i-1),signal(i+2),signal(i+3),signal(i+1)]);
    end
end

for i = 1:3
    if(abs(signal(i)-mu)>n*sigma)
        s_f(i) = mean([signal(i+2),signal(i+3),signal(i+1)]);
    end
end

for i = length(signal)-2:length(signal)
    if(abs(signal(i)-mu)>n*sigma)
        s_f(i) = mean([signal(i-3),signal(i-2),signal(i-1)]);
    end
end

end
