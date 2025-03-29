% porcess IBI by data filtering 
function [ibi_f] = ibi_process(ibi)

win = 100;
n = floor(length(ibi)/win);

ibi_f = ibi;
if(n>0)
    for i = 1:n
        ibi_f((i-1)*win+1:i*win) = filt(ibi((i-1)*win+1:i*win));
    end
    ibi_f(n*win+1:end) = filt(ibi(n*win+1:end));
else
    ibi_f = filt(ibi);
end

% figure('Position',[100,100,1500,500]);
% subplot(1,3,1);plot(ibi);
% subplot(1,3,2);plot(ibi_f);
% subplot(1,3,3);plot(abs(ibi-ibi_f));

end

% filter data outside n*sigma
function [s_f] = filt(signal)

n=3;

if(length(signal)<3)
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
    %     if(abs(signal(i)-mu)>0.2*mu)
    %         s_f(i) = mean([signal(i-3),signal(i-2),signal(i-1),signal(i+2),signal(i+3),signal(i+1)]);
    %     end
end

for i = 1:3
    if(abs(signal(i)-mu)>n*sigma)
        s_f(i) = mean([signal(i+2),signal(i+3),signal(i+1)]);
    end
    %     if(abs(signal(i)-mu)>0.2*mu)
    %         s_f(i) = mean([signal(i+2),signal(i+3),signal(i+1)]);
    %     end
end

for i = length(signal)-2:length(signal)
    if(abs(signal(i)-mu)>n*sigma)
        s_f(i) = mean([signal(i-3),signal(i-2),signal(i-1)]);
    end
    %     if(abs(signal(i)-mu)>0.2*mu)
    %         s_f(i) = mean([signal(i-3),signal(i-2),signal(i-1)]);
    %     end
end

end