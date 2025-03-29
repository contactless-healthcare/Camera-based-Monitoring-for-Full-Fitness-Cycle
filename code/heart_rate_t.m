function [heart_rate] = heart_rate_t(loc, ibi, time_interval,step) % loc, ibi, time_interval单位均为ms

heart_rate = zeros(1, ceil((loc(length(loc))-loc(1)-time_interval)/step));

for i = 0:length(heart_rate)-1
   ibi_tmp = ibi(loc>i * step & loc < i* step + time_interval); 
   heart_rate(i+1) = round(1000 * 60/mean(ibi_tmp));
end

end