% extract rPPG signal based on RGB traces and motion traces
% filepath: filepath to RGB and motion traces
% core: rPPG algorithms(DIS PBV)
% band: bandwidth ([0.6 3] for HR, [0.14 1] for RR)
function [ppg]= get_rppg(filepath,core,band)
   

    C = []; M = []; Q = [];
    C(:,:,1) = csvread([filepath, '\color_trace_r.csv']);
    C(:,:,2) = csvread([filepath, '\color_trace_g.csv']);
    C(:,:,3) = csvread([filepath, '\color_trace_b.csv']);
    M(:,:,1) = csvread([filepath, '\motion_trace_x.csv']);
    M(:,:,2) = csvread([filepath, '\motion_trace_y.csv']);

    % default parameters
    param = [];
    param.fps       = 60; % 15|20|30
    param.L         = param.fps * 5; % window length: 32|64|128|256
    param.step      = 5; % window sliding step: 1|5
    param.bandwidth = band; % HR band: [40,200] bpm [0.6, 3]
    param.pbv       = [0.3, 0.8, 0.5]; % PBV vector
    param.core      = core; % core PPG: pos | pbv | dis | chrom
    param.select    = 'snr_rob'; % selection: mean | snr | snr_rob

    ppg = extract_pulse(C, M, param);
end


function H = extract_pulse(C, M, param)

    H = zeros(1, size(C,2));
    
    % per sliding window
    for i = 1 : param.step : size(C,2) - param.L + 1
             
        % per color channel filtering
        Cf = [];
        for j = 1 : size(C, 3)
            Cf(:,:,j) = preproc(C(:,i:i+param.L-1, j), param);
        end
        
        % per motion channel filtering
        Mf = [];
        for j = 1 : size(M, 3)
            Mf(:,:,j) = preproc(M(:,i:i+param.L-1, j), param);
        end

        P = extract_core(Cf, Mf, param);
        
        % global selection
        switch param.select
            case 'mean'
                Pn = P./repmat(std(P,[],2),[1,size(P,2)]);
                h = mean(Pn,1);
            case 'snr'
                F = fft(P,[],2); S = abs(F(:,1:floor(end/2)-1)); 
                SNR = max(S,[],2)./(sum(S,2)-max(S,[],2)); 
                [~, select_idx] = max(SNR,[],1);
                h = P(select_idx,:);
            case 'snr_rob'
                F = fft(P,[],2); S = abs(F(:,1:floor(end/2)-1)); 
                [~, peaks] = max(S,[],2);
                hr_idx = round(median(peaks));
                SNR = S(:,hr_idx)./(sum(S,2)-S(:,hr_idx)); 
                [sort_val, sort_idx] = sort(SNR,'descend');
                h = mean(P(sort_idx(1:5),:),1);
        end
        
        H(:,i:i+param.L-1) = H(:,i:i+param.L-1) + (h-mean(h))/std(h);

    end
    
end



function Cf = preproc(C, param)
    
%  normalization
    Cn = C./repmat(mean(C,2)+1e-6,[1,size(C,2)]) - 1;
    s = std(Cn,0,2);
    Cn = Cn/(mean(s)+1e-6);
%     display(Cn)
    % bandpass filtering
    [n, d] = butter(4, param.bandwidth/(param.fps/2), 'bandpass');
    Cf = filtfilt(n,d,Cn')';
    Cf = Cf - repmat(mean(Cf,2),[1,size(Cf,2)]);
    
    % average filtering
    Cf = filtfilt([1,1,1]/3, 1, Cf')';
end

function P = extract_core(C, M, param)

    bias = 1e-6;
    M = M + bias;
    
    P = zeros(size(C,1), size(C,2));

    for i = 1 : size(C, 1)
        
        c = [];
        for j = 1 : size(C, 3)
            c = [c; C(i,:,j)];
        end
        
        m = [];
        for j = 1 : size(M, 3)
            m = [m; M(i,:,j)];
        end
        
        switch param.core
        	case 'pos' 
                s = [0, 1, -1; -2, 1, 1] * c;
                p = [1, std(s(1,:))/std(s(2,:))] * s;
                
            case 'pbv' 
                p = param.pbv * pinv(c*c') * c;
                
            case 'dis'
                p = [param.pbv, 0, 0] * pinv([c; m]*[c; m]') * [c; m];
                
            case 'chrom'
                s = [0.77, -0.51, 0; 0.77, 0.51, -0.77] * c;
                p = [1, -std(s(1,:))/std(s(2,:))] * s;
        
        end
                        
     	P(i,:) = (p-mean(p))/std(p);
        
    end

end


