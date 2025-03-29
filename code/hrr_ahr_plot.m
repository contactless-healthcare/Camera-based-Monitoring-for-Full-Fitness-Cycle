% Create figure with specific dimensions for multi-panel visualization
figure;
set(gcf,"Position",[100 100 1200 400])

%% ECG Data Visualization Subplot
subplot(1,3,1)
load("processed data\hr trace data\hr_ecg.mat")

% Plot resting HR vs AHR (Area Under Heart Rate curve) for all subjects
scatter(rest,auc_5,100,'filled')
hold on

% Highlight ES subjects with orange markers
for i=1:length(peak)
    for j=1:length(sport)
        if(i==sport(j))
            plot(rest(i),auc_5(i),'o','MarkerSize',10,'MarkerFaceColor',	'#D95319','color',	'#D95319');
        end
    end
end

% Plot peak HR vs AHR for all subjects
scatter(peak,auc_5,100,'s','filled','MarkerFaceColor','#0072BD')
hold on
% Highlight ES subjects with orange markers
for i=1:length(peak)
    for j=1:length(sport)
        if(i==sport(j))
            plot(peak(i),auc_5(i),'s','MarkerSize',10,'MarkerFaceColor',	'#D95319','color',	'#D95319');
        end
    end
end
grid on

ax=gca;
ax.GridLineStyle='--';
ax.LineWidth=1.5;
title('ECG','FontSize',15,'FontWeight','bold')
xlabel('Rest/Peak HR (bpm)','FontSize',15,'FontWeight','bold')
ylabel('AHR','FontSize',15,'FontWeight','bold')

%% PPG Data Visualization Subplot (Same structure as ECG)
subplot(1,3,2)
load("processed data\hr trace data\hr_ppg.mat")

% Plot resting HR vs AHR for all subjects
scatter(rest,auc_5,100,'filled')
hold on
% Highlight ES subjects with orange markers
for i=1:length(peak)
    for j=1:length(sport)
        if(i==sport(j))
            plot(rest(i),auc_5(i),'o','MarkerSize',10,'MarkerFaceColor',	'#D95319','color',	'#D95319');
        end

    end
end

% Plot peak HR vs AHR for all subjects
scatter(peak,auc_5,100,'s','filled','MarkerFaceColor','#0072BD')
hold on
% Highlight ES subjects with orange markers
for i=1:length(peak)
    for j=1:length(sport)
        if(i==sport(j))
            plot(peak(i),auc_5(i),'s','MarkerSize',10,'MarkerFaceColor',	'#D95319','color',	'#D95319');
        end
    end
end
grid on

ax=gca;
ax.GridLineStyle='--';
ax.LineWidth=1.5;
title('PPG','FontSize',15,'FontWeight','bold')

xlabel('Rest/Peak HR (bpm)','FontSize',15,'FontWeight','bold')
ylabel('AHR','FontSize',15,'FontWeight','bold')

%% rPPG Data Visualization Subplot (Same structure as ECG)
subplot(1,3,3)
load("processed data\hr trace data\hr_rppg.mat")

% Plot resting HR vs AHR for all subjects
scatter(rest,auc_5,100,'filled')
hold on
% Highlight ES subjects with orange markers
for i=1:length(peak)
    for j=1:length(sport)
        if(i==sport(j))
            plot(rest(i),auc_5(i),'o','MarkerSize',10,'MarkerFaceColor',	'#D95319','color',	'#D95319');
        end

    end
end

% Plot peak HR vs AHR for all subjects
scatter(peak,auc_5,100,'s','filled','MarkerFaceColor','#0072BD')
hold on
% Highlight ES subjects with orange markers
for i=1:length(peak)
    for j=1:length(sport)
        if(i==sport(j))
            plot(peak(i),auc_5(i),'s','MarkerSize',10,'MarkerFaceColor',	'#D95319','color',	'#D95319');
        end
    end
end
grid on

ax=gca;
ax.GridLineStyle='--';
ax.LineWidth=1.5;
title('rPPG','FontSize',15,'FontWeight','bold')

xlabel('Rest/Peak HR (bpm)','FontSize',15,'FontWeight','bold')
ylabel('AHR','FontSize',15,'FontWeight','bold')





