% Define data path and file list
path = 'hr pre post data\';
namelist = dir([path,'*.mat']);
len= length(namelist);

% Initialize matrices for storing heart rate data across subjects
hr_ecg_2d_e=[];
hr_ppg_2d_e=[];
hr_rppg_2d_e=[];

% Define subject category
sport=[2 4 5 8 26 9 11 23 25 10];
non=[1 6 35 36 20 12 31 13 32 33 3 14 15 16 17 18 19 7 21 22 24 27 28 29 30 34];
k=[sport non];

% Process data for all subjects
for ind=1:36
    n=k(ind);
    filename{n} = [path,namelist(n).name];
    load(filename{n});

    % Extract and concatenate ECG data
    ecg=[hr_pre_post_data{2,1}(1:560),hr_pre_post_data{2,2}(1:710),hr_pre_post_data{2,3}(1:560),hr_pre_post_data{2,4}(1:560)];
    hr_ecg_2d_e=[hr_ecg_2d_e;ecg];

    % Extract and concatenate PPG data
    ppg=[hr_pre_post_data{3,1}(1:560),hr_pre_post_data{3,2}(1:710),hr_pre_post_data{3,3}(1:560),hr_pre_post_data{3,4}(1:560)];
    hr_ppg_2d_e=[hr_ppg_2d_e;ppg];
    
    % Extract and concatenate RPPG data
    rppg=[hr_pre_post_data{6,1}(1:560),hr_pre_post_data{6,2}(1:710),hr_pre_post_data{6,3}(1:560),hr_pre_post_data{6,4}(1:560)];
    hr_rppg_2d_e=[hr_rppg_2d_e;rppg];
end


% Visualization parameters for phase separation lines
x1 = [550, 550];
x2 = [1150, 1150];
x3 = [1270, 1270];
y = [0,16];


len=36;

%% ECG Visualization
figure;
set(gcf,'Position',[100 100 530 600])
% Create heatmap with reversed hot colormap (dark=high values)
imagesc(hr_ecg_2d_e);colormap(flipud(hot));caxis([50,200]);%colorbar

% Add phase separation lines
x_position = 600;
line([x_position, x_position], ylim, 'Color', '#0072BD', 'LineStyle', '--', 'LineWidth', 2);
x_position = 1200;
line([x_position, x_position], ylim, 'Color', '#0072BD', 'LineStyle', '--', 'LineWidth', 2);
xlabel('Time(s)');
ylabel('Subject ID')


% Axis labeling and formatting
set(gca, 'yTick', [1 6 12 18 24 30 36]);
set(gca,'YTickLabel',[1 6 12 18 24 30 36])
set(gca, 'xTick', [0 500 1000 1500 2000 2500]);
set(gca,'XTickLabel', {'0', '250', '500', '750', '1000', '1250'})
set(gca,'FontSize', 12, 'FontWeight', 'bold');


% Create colorbar with proper positioning
ax=gca;
P=ax.Position;
P(1)=P(1)+P(3);
P(3)=P(3)/10;
axes('Position', P);
axis off;
k=colorbar();
caxis([0,200])
set(get(k,'Title'),'string','bpm','FontWeight','bold','FontSize',12);
set(k,'FontSize',12,'FontWeight','bold')

%% RPPG Visualization (Same structure as ECG visualization)
figure;
set(gcf,'Position',[100 100 530 600])

imagesc(hr_rppg_2d_e);colormap(flipud(hot));caxis([50,200]);

% Add phase separation lines
x_position = 600;
line([x_position, x_position], ylim, 'Color', '#0072BD', 'LineStyle', '--', 'LineWidth', 2);
x_position = 1200;
line([x_position, x_position], ylim, 'Color', '#0072BD', 'LineStyle', '--', 'LineWidth', 2);
xlabel('Time(s)');
ylabel('Subject ID')


% Axis labeling and formatting
set(gca, 'yTick', [1 6 12 18 24 30 36]);
set(gca, 'YTickLabel', [1 6 12 18 24 30 36])
set(gca, 'xTick', [0, 500, 1000, 1500, 2000, 2500]);
set(gca, 'XTickLabel', {'0', '250', '500', '750', '1000', '1250'})
set(gca, 'FontSize', 12, 'FontWeight', 'bold');

% Create colorbar with proper positioning
ax=gca;
P=ax.Position;
P(1) = P(1) + P(3);
P(3) = P(3) / 10;
axes('Position', P);
axis off;
k=colorbar();
caxis([0,200])
set(get(k,'Title'),'string','bpm','FontWeight','bold','FontSize',12);
set(k,'FontSize',12,'FontWeight','bold')

%% PPG Visualization (Same structure as ECG visualization)

figure;
set(gcf,'Position',[100 100 530 600])

% Create heatmap with reversed hot colormap (dark=high values)
imagesc(hr_ppg_2d_e);colormap(flipud(hot));caxis([50,200]);%colorbar

% Add phase separation lines
x_position = 600;
line([x_position, x_position], ylim, 'Color', '#0072BD', 'LineStyle', '--', 'LineWidth', 2);
x_position = 1200;
line([x_position, x_position], ylim, 'Color', '#0072BD', 'LineStyle', '--', 'LineWidth', 2);
xlabel('Time(s)')
ylabel('Subject ID')

% Axis labeling and formatting
set(gca, 'yTick', [1 6 12 18 24 30 36]);
set(gca, 'YTickLabel', [1 6 12 18 24 30 36])
set(gca, 'xTick', [0, 500, 1000, 1500, 2000, 2500]);
set(gca, 'XTickLabel', {'0', '250', '500', '750', '1000', '1250'})
set(gca, 'FontSize', 12, 'FontWeight', 'bold');

% Create colorbar with proper positioning
ax = gca;
P = ax.Position;
P(1) = P(1) + P(3);
P(3) = P(3) / 15;
axes('Position', P);
axis off;
k=colorbar();
caxis([0,200])
set(get(k, 'Title'), 'string', 'bpm', 'FontWeight', 'bold', 'FontSize', 12);
set(k, 'FontSize', 12, 'FontWeight', 'bold')