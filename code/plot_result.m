%% 绘制HRV errorbar图
clear all
close all
clc

% load hrv result based on t-domain, f-domain, non-linear domain
path = 'processed data\HRV result\';
namelist = dir([path,'*.mat']);
l = length(namelist);
P = cell(1,l);
for i = 1:l
    filename{i} = [path,namelist(i).name];
    P{1,i} = load(filename{i});
end

f_domain=cell(3,4);
n_domain=cell(3,3);
t_domain=cell(3,5);



for i=1:l
    for j=1:3
        for k1=1:4
            lll=[P{1,i}.f_e(j,k1),P{1,i}.f_p(j,k1),0,0,P{1,i}.f_r_dis(j,k1)];
            f_domain(j,k1)=mat2cell([cell2mat(f_domain(j,k1)); lll],i,5);
        end
    end

    for j=1:3
        for k1=1:3
            lll=[P{1,i}.n_e(j,k1),P{1,i}.n_p(j,k1),0,0,P{1,i}.n_r_dis(j,k1)];
            n_domain(j,k1)=mat2cell([cell2mat(n_domain(j,k1)); lll],i,5);
        end
    end

    for j=1:3
        for k1=1:5
            lll=[P{1,i}.t_e(j,k1),P{1,i}.t_p(j,k1),0,0,P{1,i}.t_r_dis(j,k1)];
            t_domain(j,k1)=mat2cell([cell2mat(t_domain(j,k1)); lll],i,5);
        end
    end
end

f_mean=[];
f_std=[];
t_mean=[];
t_std=[];
n_mean=[];
n_std=[];

% calculate mean value and standard variation
for i=1:3

    for k1=1:3
        n_mean=[n_mean;mean(n_domain{i,k1})];
        n_std=[n_std;std(n_domain{i,k1})];
    end
    for k1=1:4
        f_mean=[f_mean;mean(f_domain{i,k1})];
        f_std=[f_std;std(f_domain{i,k1})];
    end
    for k1=1:5
        t_mean=[t_mean;mean(t_domain{i,k1})];
        t_std=[t_std;std(t_domain{i,k1})];
    end
end

mean_all=[t_mean;f_mean;n_mean];
std_all=[t_std;f_std;n_std];

% plot the errorbar figures of HRV by errorbar function
T_t={'mean IBI(ms)';'SDNN(ms)';'RMSSD(ms)';'PNN50';'PNN20'};
T_f={'HF(ms^2)';'LF(ms^2)';'VLF(ms^2)';'HF/LF'};
T_n={'SD1(ms)';'SD2(ms)';'SD1/SD2'};
for i=1:5
    figure;
    hold on
    for k1=1:5
        if(k1~=4&&k1~=3)
            e=errorbar(1:3,t_mean([i,i+5,i+10],k1),t_std([i,i+5,i+10],k1));
            set(e,'LineWidth', 3,'CapSize', 12 );
        end
    end
    hold off
    set(gca,'XLim', [0.5 3.5],'LineWidth',1.5, 'YMinorTick', 'off','box','on');
    set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post1','Post2'});
    set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight' , 'bold')

    title(T_t(i), 'FontWeight' , 'bold');
end
for i=1:4
    figure;
    hold on

    for k1=1:5
        if(k1~=4&&k1~=3)

            e=errorbar(1:3,f_mean([i,i+4,i+8],k1),f_std([i,i+4,i+8],k1));
            set(e,'LineWidth', 3,'CapSize', 12 )
        end
    end
    hold off
    set(gca,'XLim', [0.5 3.5],'LineWidth',1.5,'XMinorTick', 'off', 'YMinorTick', 'off','box','on');
    set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post1','Post2'});
    set(gca, 'FontName', 'Arial', 'FontSize', 20, 'FontWeight' , 'bold')
    legend('ECG','PPG','DIS')
    title(T_f(i), 'FontWeight' , 'bold');

end

for i=1:3
    figure;
    hold on
    for k1=1:5
        if(k1~=4&&k1~=3)

            e=errorbar(1:1:3,n_mean([i,i+3,i+6],k1),n_std([i,i+3,i+6],k1));
            set(e,'LineWidth', 3,'CapSize', 12);
        end
    end
    hold off
    set(gca,'XLim', [0.5 3.5],'LineWidth',1.5,'XMinorTick', 'off', 'YMinorTick', 'off','box','on');
    set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post1','Post2'});
    set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight' , 'bold')

    title(T_n(i), 'FontWeight' , 'bold');

end
%% save images if needed

% for ind=1:12
%     print(ind,'-dpng');
%     movefile(['figure',num2str(ind),'.png'],['pics\']);
% end

%% plot errorbar of RR and HR for sport/nonsport subjects
close all;
clear all

% load file names
path = 'processed data\HRV result\';
namelist = dir([path,'*.mat']);
l = length(namelist);

% define subjects category
sport=[2 4 5 8 9 10 11 23 25 26];
non=[1 3 6 7 12 13 14 15 16 17 18 19 20 21 22 24 27 28 29 30 31 32 33 34 35 36];
mean_s=[];
mean_n=[];

% load HR RR data of sport subjects
Mean_s=[];
for i=1:length(sport)
    name=namelist(sport(i)).name;
    name=erase(name,'_hrv_result.mat');

    load (['processed data\rr pre post data\',name,'_br_pre_post_data.mat'],'pbv_pre','pbv_post1','pbv_post2','dis_pre','dis_post1','dis_post2','pxf2_pre','pxf2_post1','pxf2_post2','pxf1_pre','pxf1_post1','pxf1_post2','res_pre','res_post1','res_post2');
    load(['processed data\hr pre post data\',name,'_hr_pre_post_data.mat']);

    Mean=[mean(res_pre) mean(res_post1) mean(res_post2) mean(pbv_pre) mean(pbv_post1) mean(pbv_post2) 0 0 0 mean(dis_pre) mean(dis_post1) mean(dis_post2) mean(pxf1_pre) mean(pxf1_post1) mean(pxf1_post2) mean(pxf2_pre) mean(pxf2_post1) mean(pxf2_post2)];
    pp=hr_pre_post_data(2:6,:)';
    pp=pp(:)';

    for j=1:20
        Mean(j+18)=mean(cell2mat(pp(j)),'omitnan');
    end

    Mean_s=[Mean_s;Mean];

end
% calculate std and mean
std_s=std(Mean_s);
mean_s=mean(Mean_s);

% load data of nonsport subjects
Mean_n=[];
for i=1:length(non)
    name=namelist(non(i)).name;
    name=erase(name,'_hrv_result.mat');

    load (['processed data\rr pre post data\',name,'_br_pre_post_data.mat'],'pbv_pre','pbv_post1','pbv_post2','dis_pre','dis_post1','dis_post2','pxf2_pre','pxf2_post1','pxf2_post2','pxf1_pre','pxf1_post1','pxf1_post2','res_pre','res_post1','res_post2');
    load(['processed data\hr pre post data\',name,'_hr_pre_post_data.mat']);

    Mean=[mean(res_pre) mean(res_post1) mean(res_post2) mean(pbv_pre) mean(pbv_post1) mean(pbv_post2) 0 0 0 mean(dis_pre) mean(dis_post1) mean(dis_post2) mean(pxf1_pre) mean(pxf1_post1) mean(pxf1_post2) mean(pxf2_pre) mean(pxf2_post1) mean(pxf2_post2)];
    pp=hr_pre_post_data(2:6,:)';
    pp=pp(:)';

    for j=1:20
        Mean(j+18)=mean(cell2mat(pp(j)),'omitnan');
    end

    Mean_n=[Mean_n;Mean];

end
std_n=std(Mean_n);
mean_n=mean(Mean_n);

% plot errorbar of HR and RR (only use RES PBV PXF for RR and ECG PPG DIS for HR)
T_r={'RES';'PBV';'CHROM';'DIS';'PXF1';'PXF'};
T_h={'ECG';'PPG';'PBV';'CHROM';'DIS'};
for i=[1 2 6]
    figure;
    hold on
    e2=errorbar(1:3,mean_n(i*3-2:i*3),std_n(i*3-2:i*3));
    e1=errorbar(1:3,mean_s(i*3-2:i*3),std_s(i*3-2:i*3));


    set(e1,'LineWidth', 6,'CapSize', 12 );
    set(e2,'LineWidth', 6,'CapSize', 12 );

    hold off
    set(gca,'XLim', [0.5 3.5],'LineWidth',1.5, 'YMinorTick', 'off','box','on');
    set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post1','Post2'});
    set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight' , 'bold')
    title(T_r(i),'FontSize', 24,'FontWeight' , 'bold');
end


mean_s=mean_s(19:end);
std_s=std_s(19:end);
mean_n=mean_n(19:end);
std_n=std_n(19:end);

for i=[1 2 5]
    figure;
    hold on
    e2=errorbar(1:4,mean_n([i*4-3,i*4-2,i*4-1,i*4]),std_n([i*4-3,i*4-2,i*4-1,i*4]));
    set(e2,'LineWidth', 6,'CapSize', 12 );
    e1=errorbar(1:4,mean_s([i*4-3,i*4-2,i*4-1,i*4]),std_s([i*4-3,i*4-2,i*4-1,i*4]));
    set(e1,'LineWidth', 6,'CapSize', 12 );

    hold off
    set(gca,'XLim', [0.5 4.5],'LineWidth',1.5, 'YMinorTick', 'off','box','on');
    set(gca,'XTick',[1:4],'XTickLabel',{'Pre','Sport','Post1','Post2'});%'sport',

    title(T_h(i),'FontSize', 24, 'FontWeight' , 'bold');
    set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight' , 'bold')
    %     h1=legend('NS','ES','FontWeight','bold');
    %     set(h1,'Orientation','horizon','Box','off')
end


%% plot errorbar of HRV for sport/nonsport subjetcs (ES:blue NS:red)
close all
clear all

% define subjects category
sport=[2 4 5 8 9 10 11 23 25 26];
non=[1 3 6 7 12 13 14 15 16 17 18 19 20 21 22 24 27 28 29 30 31 32 33 34 35 36];

path = 'processed data\HRV result\';
namelist = dir([path,'*.mat']);
l = length(namelist);
P = cell(1,l);

for i = 1:l
    filename{i} = [path,namelist(i).name];
    P{1,i} = load(filename{i});
end
f_domain_s=cell(3,4);
n_domain_s=cell(3,3);
t_domain_s=cell(3,5);

% load HRV data
for n=1:length(sport)
    i=sport(n);
    for j=1:3
        for k1=1:4
            lll=[P{1,i}.f_e(j,k1),P{1,i}.f_p(j,k1),0,0,P{1,i}.f_r_dis(j,k1)];
            f_domain_s(j,k1)=mat2cell([cell2mat(f_domain_s(j,k1)); lll],n,5);
        end
    end

    for j=1:3
        for k1=1:3
            lll=[P{1,i}.n_e(j,k1),P{1,i}.n_p(j,k1),0,0,P{1,i}.n_r_dis(j,k1)];
            n_domain_s(j,k1)=mat2cell([cell2mat(n_domain_s(j,k1)); lll],n,5);
        end
    end

    for j=1:3
        for k1=1:5
            lll=[P{1,i}.t_e(j,k1),P{1,i}.t_p(j,k1),0,0,P{1,i}.t_r_dis(j,k1)];
            t_domain_s(j,k1)=mat2cell([cell2mat(t_domain_s(j,k1)); lll],n,5);
        end
    end
end

% calculate std and mean of HRV for ES
f_mean_s=[];
f_std_s=[];
t_mean_s=[];
t_std_s=[];
n_mean_s=[];
n_std_s=[];
for i=1:3

    for k1=1:3
        n_mean_s=[n_mean_s;mean(n_domain_s{i,k1})];
        n_std_s=[n_std_s;std(n_domain_s{i,k1})];
    end
    for k1=1:4
        f_mean_s=[f_mean_s;mean(f_domain_s{i,k1})];
        f_std_s=[f_std_s;std(f_domain_s{i,k1})];
    end
    for k1=1:5
        t_mean_s=[t_mean_s;mean(t_domain_s{i,k1})];
        t_std_s=[t_std_s;std(t_domain_s{i,k1})];
    end
end
mean_all=[t_mean_s;f_mean_s;n_mean_s];
std_all=[t_std_s;f_std_s;n_std_s];

f_domain_n=cell(3,4);
n_domain_n=cell(3,3);
t_domain_n=cell(3,5);

for n=1:length(non)
    i=non(n);
    for j=1:3
        for k1=1:4
            lll=[P{1,i}.f_e(j,k1),P{1,i}.f_p(j,k1),0,0,P{1,i}.f_r_dis(j,k1)];
            f_domain_n(j,k1)=mat2cell([cell2mat(f_domain_n(j,k1)); lll],n,5);
        end
    end

    for j=1:3
        for k1=1:3
            lll=[P{1,i}.n_e(j,k1),P{1,i}.n_p(j,k1),0,0,P{1,i}.n_r_dis(j,k1)];
            n_domain_n(j,k1)=mat2cell([cell2mat(n_domain_n(j,k1)); lll],n,5);
        end
    end

    for j=1:3
        for k1=1:5
            lll=[P{1,i}.t_e(j,k1),P{1,i}.t_p(j,k1),0,0,P{1,i}.t_r_dis(j,k1)];
            t_domain_n(j,k1)=mat2cell([cell2mat(t_domain_n(j,k1)); lll],n,5);
        end
    end
end


% calculate std and mean of HRV for NS
f_mean_n=[];
f_std_n=[];
t_mean_n=[];
t_std_n=[];
n_mean_n=[];
n_std_n=[];

for i=1:3

    for k1=1:3
        n_mean_n=[n_mean_n;mean(n_domain_n{i,k1})];
        n_std_n=[n_std_n;std(n_domain_n{i,k1})];
    end
    for k1=1:4
        f_mean_n=[f_mean_n;mean(f_domain_n{i,k1})];
        f_std_n=[f_std_n;std(f_domain_n{i,k1})];
    end
    for k1=1:5
        t_mean_n=[t_mean_n;mean(t_domain_n{i,k1})];
        t_std_n=[t_std_n;std(t_domain_n{i,k1})];
    end
end



T_t={'mean IBI(ms)';'SDNN(ms)';'RMSSD(ms)';'PNN50';'PNN20'};
T_f={'HF(ms^2)';'LF(ms^2)';'VLF(ms^2)';'HF/LF'};
T_n={'SD1(ms)';'SD2(ms)';'SD1/SD2'};

% plot errorbar of ES/NS HRV
for i=1:5

    for k1=1:5
        if (k1~=3&&k1~=4)
            figure;
            hold on

            e2=errorbar(1:3,t_mean_n([i,i+5,i+10],k1),t_std_n([i,i+5,i+10],k1));
            set(e2,'LineWidth', 6,'CapSize', 12 );
            e1=errorbar(1:3,t_mean_s([i,i+5,i+10],k1),t_std_s([i,i+5,i+10],k1));
            set(e1,'LineWidth', 6,'CapSize', 12 );
            hold off
            set(gca,'XLim', [0.5 3.5],'LineWidth',1.5, 'YMinorTick', 'off','box','on');
            set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post1','Post2'});
            set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight' , 'bold')
        end
        title(T_t(i), 'FontWeight' , 'bold');
    end
end
for i=1:4

    for k1=1:5
        if (k1~=3&&k1~=4)

            figure;
            hold on

            e2=errorbar(1:3,f_mean_n([i,i+4,i+8],k1),f_std_n([i,i+4,i+8],k1));
            set(e2,'LineWidth', 6,'CapSize', 12 )
            e1=errorbar(1:3,f_mean_s([i,i+4,i+8],k1),f_std_s([i,i+4,i+8],k1));
            set(e1,'LineWidth', 6,'CapSize', 12 )
            hold off
            set(gca,'XLim', [0.5 3.5],'LineWidth',1.5,'XMinorTick', 'off', 'YMinorTick', 'off','box','on');
            set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post1','Post2'});
            set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight' , 'bold')
        end
        title(T_f(i), 'FontWeight' , 'bold');
    end
end

for i=1:3

    for k1=1:5
        if (k1~=3&&k1~=4)

            figure;
            e2=errorbar(1:1:3,n_mean_n([i,i+3,i+6],k1),n_std_n([i,i+3,i+6],k1));
            set(e2,'LineWidth', 6,'CapSize', 12);
            hold on
            e1=errorbar(1:1:3,n_mean_s([i,i+3,i+6],k1),n_std_s([i,i+3,i+6],k1));
            set(e1,'LineWidth', 6,'CapSize', 12);


            hold off
            set(gca,'XLim', [0.5 3.5],'LineWidth',1.5,'XMinorTick', 'off', 'YMinorTick', 'off','box','on');
            set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post1','Post2'});
            set(gca, 'FontName', 'Arial', 'FontSize', 24, 'FontWeight' , 'bold')
        end
        title(T_n(i), 'FontWeight' , 'bold');
    end
end

%% save images
% for ind=1:11
%     print(ind,'-dpng');
%     movefile(['figure',num2str(ind),'.png'],['pics\']);
% end

%% read all subjects' HR and RR data, get mean and std
close all;
clear
path = 'processed data\HRV result\';
namelist = dir([path,'*.mat']);
l = length(namelist);

Mean_all=[];
for i=1:l
    name=namelist(i).name;
    name=erase(name,'_hrv_result.mat');
    load (['processed data\rr pre post data\',name,'_br_pre_post_data.mat'],'pbv_pre','pbv_post1','pbv_post2','dis_pre','dis_post1','dis_post2','pxf2_pre','pxf2_post1','pxf2_post2','pxf1_pre','pxf1_post1','pxf1_post2','res_pre','res_post1','res_post2');
    load(['processed data\hr pre post data\',name,'_hr_pre_post_data.mat']);

    Mean=[mean(res_pre) mean(res_post1) mean(res_post2) mean(pbv_pre) mean(pbv_post1) mean(pbv_post2) 0 0 0 mean(dis_pre) mean(dis_post1) mean(dis_post2) mean(pxf1_pre) mean(pxf1_post1) mean(pxf1_post2) mean(pxf2_pre) mean(pxf2_post1) mean(pxf2_post2)];
    pp=hr_pre_post_data(2:6,:)';
    pp=pp(:)';
    for j=1:20
        Mean(j+18)=mean(cell2mat(pp(j)),'omitnan');
    end

    Mean_all=[Mean_all;Mean];

end
std_hr_br=std(Mean_all);
mean_hr_br=mean(Mean_all);

% read all subjects' HRV data, get mean and std
path = 'processed data\HRV result\';
namelist = dir([path,'*.mat']);
l = length(namelist);
P = cell(1,l);
for i = 1:l
    filename{i} = [path,namelist(i).name];
    P{1,i} = load(filename{i});
end

f_domain=cell(3,4);
n_domain=cell(3,3);
t_domain=cell(3,5);



for i=1:l
    for j=1:3
        for k1=1:4
            lll=[P{1,i}.f_e(j,k1),P{1,i}.f_p(j,k1),0,0,P{1,i}.f_r_dis(j,k1)];
            f_domain(j,k1)=mat2cell([cell2mat(f_domain(j,k1)); lll],i,5);
        end
    end

    for j=1:3
        for k1=1:3
            lll=[P{1,i}.n_e(j,k1),P{1,i}.n_p(j,k1),0,0,P{1,i}.n_r_dis(j,k1)];
            n_domain(j,k1)=mat2cell([cell2mat(n_domain(j,k1)); lll],i,5);
        end
    end

    for j=1:3
        for k1=1:5
            lll=[P{1,i}.t_e(j,k1),P{1,i}.t_p(j,k1),0,0,P{1,i}.t_r_dis(j,k1)];
            t_domain(j,k1)=mat2cell([cell2mat(t_domain(j,k1)); lll],i,5);
        end
    end
end


all_hrv=[t_domain,f_domain,n_domain];


hrv_mean=[];
hrv_std=[];
for i=1:12
    tmp_mean=[];
    tmp_std=[];

    for j=1:3

        tmp_mean=[tmp_mean; mean(all_hrv{j,i})];
        tmp_std=[tmp_std ;std(all_hrv{j,i})];

    end
    hrv_mean=[hrv_mean tmp_mean(:,[1,2,5])];
    hrv_std=[hrv_std tmp_std(:,[1,2,5])];
end



%% plot the errorbar based on all subjects' HR RR and HRV
figure;
T={'HRV-Mean IBI(ms)';'HRV-SDNN(ms)';'HRV-RMSSD(ms)';'HRV-pNN50';'HRV-pNN20';'HRV-HF(ms^2)';'HRV-LF(ms^2)';'HRV-VLF(ms^2)';'HRV-LF/HF';'HRV-SD1(ms)';'HRV-SD2(ms)';'HRV-SD1/SD2'};
h=tight_subplot(2,7,[0.1 ,0.021],[.12 .1],[.03 .02]);
set(gcf,'Position',[200,0, 1730,550])
id=[1:6 8:13];
for i=1:12
    axes(h(id(i)));
    e1=errorbar(1:3,hrv_mean(:,i*3-2),hrv_std(:,i*3-2));
    hold on
    e2=errorbar(1:3,hrv_mean(:,i*3-1),hrv_std(:,i*3-1));
    e3=errorbar(1:3,hrv_mean(:,i*3),hrv_std(:,i*3));
    set([e1,e2,e3],'LineWidth', 3,'CapSize', 6);
    set(gca,'XLim', [0.5 3.5],'LineWidth',1,'XMinorTick', 'off', 'YMinorTick', 'off','box','on','FontWeight','bold');
    set(gca,'XTick',1:3,'XTickLabel',{'Pre','Post1','Post2'},'FontWeight','bold');
    title(T(i),'FontWeight','bold','FontSize',12)

end


axes(h(7));
e2=errorbar(1:3,mean_hr_br(6*3-2:6*3),std_hr_br(6*3-2:6*3),'Color','#77AC30');
hold on
e1=errorbar(1:3,mean_hr_br(1*3-2:1*3),std_hr_br(1*3-2:1*3),'Color','#0072BD');
e3=errorbar(1:3,mean_hr_br(2*3-2:2*3),std_hr_br(2*3-2:2*3),'Color','#EDB120');

set([e1,e2,e3],'LineWidth', 3,'CapSize', 6);
set(gca,'XLim', [0.5 3.5],'LineWidth',1,'XMinorTick', 'off', 'YMinorTick', 'off','box','on','FontWeight','bold');
set(gca,'XTick',1:3,'XTickLabel',{'Pre','Post1','Post2'},'FontWeight','bold');
title('RR(bpm)','FontWeight','bold','FontSize',12)
h2=legend('PXF','FontWeight','bold','FontSize',12,'Location','South');
set(h2,'Orientation','horizon','Box','off');


mean_hr_br_n=mean_hr_br(19:end);
std_hr_br_n=std_hr_br(19:end);

axes(h(14));
e1=errorbar(1:4,mean_hr_br_n(1*4-3:1*4),std_hr_br_n(1*4-3:1*4));
hold on
e2=errorbar(1:4,mean_hr_br_n(2*4-3:2*4),std_hr_br_n(2*4-3:2*4));
e3=errorbar(1:4,mean_hr_br_n(5*4-3:5*4),std_hr_br_n(5*4-3:5*4));
set([e1,e2,e3],'LineWidth', 3,'CapSize', 6);
set(gca,'XLim', [0.5 4.5],'LineWidth',1,'XMinorTick', 'off', 'YMinorTick', 'off','box','on','FontWeight','bold');
set(gca,'XTick',1:4,'XTickLabel',{'Pre','Sport','Post1','Post2'},'FontWeight','bold');
title('HR(bpm)','FontWeight','bold','FontSize',12)


h1=legend('ECG','PPG','rPPG','REF','PXF','FontWeight','bold','FontSize',12,'Location','South');
set(h1,'Orientation','horizon','Box','off');


%% plot RR traces of all subjects (RPPG/PXF RR vs Reference)
clear;
close all;
path = 'processed data\rr pre post data\';
namelist = dir([path,'*br_pre_post_data.mat']);
l = length(namelist);
P = cell(1,l);
for i = 1:l
    filename{i} = [path,namelist(i).name];
    P{1,i} = load(filename{i});
end
res_rppg_pxf_all=cell(7,3);
for i=1:l
    for j=2:7
        for k1=1:3
            res_rppg_pxf_all(j,k1)=mat2cell([cell2mat(res_rppg_pxf_all(j,k1)), cell2mat(P{1,i}.pre_post_data(j,k1))],1,i*300);
        end
    end
end


T={' pre';'post1';' post2'};
for i=1:3
    rate_plot_subs(res_rppg_pxf_all{2,i}, res_rppg_pxf_all{3,i},6,300,'RPPG','mode1',[0 60])
    rate_plot_subs(res_rppg_pxf_all{2,i}, res_rppg_pxf_all{7,i},6,300,'PXF','mode1',[0 60])
    [count_pxf(i)]=roundn(count_acc(res_rppg_pxf_all{2,i}, res_rppg_pxf_all{7,i} ,6)/10800,-3);
    [count_pbv(i)]=roundn(count_acc(res_rppg_pxf_all{2,i}, res_rppg_pxf_all{3,i},6)/10800,-3);

end

%% plot HR traces (DIS PPG vs ECG)
clear
close all
path = 'processed data\hr pre post data\';

namelist = dir([path,'*.mat']);
len= length(namelist);
ecg=cell(4,1);
ppg=cell(4,1);
rppg=cell(4,1);

for n=1:36

    filename{n} = [path,namelist(n).name];
    load(filename{n});
    ecg{1,1}=[ecg{1,1} hr_pre_post_data{2,1}(1:560)];
    ecg{2,1}=[ecg{2,1} hr_pre_post_data{2,2}(1:710)];
    ecg{3,1}=[ecg{3,1} hr_pre_post_data{2,3}(1:560)];
    ecg{4,1}=[ecg{4,1} hr_pre_post_data{2,4}(1:560)];

    ppg{1,1}=[ppg{1,1} hr_pre_post_data{3,1}(1:560)];
    ppg{2,1}=[ppg{2,1} hr_pre_post_data{3,2}(1:710)];
    ppg{3,1}=[ppg{3,1} hr_pre_post_data{3,3}(1:560)];
    ppg{4,1}=[ppg{4,1} hr_pre_post_data{3,4}(1:560)];

    rppg{1,1}=[rppg{1,1} hr_pre_post_data{6,1}(1:560)];
    rppg{2,1}=[rppg{2,1} hr_pre_post_data{6,2}(1:710)];
    rppg{3,1}=[rppg{3,1} hr_pre_post_data{6,3}(1:560)];
    rppg{4,1}=[rppg{4,1} hr_pre_post_data{6,4}(1:560)];

end


T={' pre';'post1';' post2'};
count_p=[];
count_r=[];
mae_r=[];
mae_p=[];
rmse_p=[];
rmse_r=[];

rmse_p1=[];
rmse_r1=[];
for i=1:4

    if(i==2)
        rate_plot_subs(ecg{i,1},rppg{i,1} ,8,710,'RPPG','mode1',[60 200])
        rate_plot_subs(ecg{i,1},ppg{i,1},8,710,'PPG','mode1',[60 200])
        %         [count_r(i)]=Rate_plot(ecg{i,1},rppg{i,1} ,8,710,'RPPG','mode2');
        %         [count_p(i)]=Rate_plot(ecg{i,1},ppg{i,1},8,710,'PPG','mode2');
        [count_r(i)]=count_acc(ecg{i,1},rppg{i,1} ,3);
        [count_p(i)]=count_acc(ecg{i,1},ppg{i,1},3);
    else
        if(i==1)
            rate_plot_subs(ecg{i,1},rppg{i,1} ,3,560,'RPPG','mode1',[60 130])
            rate_plot_subs(ecg{i,1},ppg{i,1},3,560,'PPG','mode1',[60 130])
        end
        if(i==3)
            rate_plot_subs(ecg{i,1},rppg{i,1} ,3,560,'RPPG','mode1',[75 170])
            rate_plot_subs(ecg{i,1},ppg{i,1},3,560,'PPG','mode1',[75 170])
        end
        if(i==4)
            %           rate_plot_subs(ecg{i,1},rppg{i,1} ,3,560,'RPPG','mode1',[60 150])
            rate_plot_subs(ecg{i,1},ppg{i,1},3,560,'PPG','mode1',[60 150])
        end
        %         [count_r(i)]=Rate_plot(ecg{i,1},rppg{i,1} ,3,560,'RPPG','mode2');
        %         [count_p(i)]=Rate_plot(ecg{i,1},ppg{i,1},3,560,'PPG','mode2');
        [count_r(i)]=count_acc(ecg{i,1},rppg{i,1} ,3);
        [count_p(i)]=count_acc(ecg{i,1},ppg{i,1},3);
    end

    mae_r(i)=mean(abs(ecg{i,1}-rppg{i,1}));
    mae_p(i)=mean(abs(ecg{i,1}-ppg{i,1}),'omitnan');
    rmse_r(i)=sqrt(mean((ecg{i,1}-rppg{i,1}).^2));
    rmse_p(i)=sqrt(mean((ecg{i,1}-ppg{i,1}).^2,'omitnan'));


    rmse_r1(i)=mean(abs([ecg{1,1} ecg{3,1} ecg{4,1}]-[rppg{1,1} rppg{3,1} rppg{4,1}]));
    rmse_p1(i)=mean(abs([ecg{1,1} ecg{3,1} ecg{4,1}]-[ppg{1,1} ppg{3,1} ppg{4,1}]),'omitnan');

end


acc_p=count_p./[20160 25560 20160 20160];
acc_r=count_r./[20160 25560 20160 20160];
mae_r=roundn(mae_r,-3);
mae_p=roundn(mae_p,-3);

rmse_r=roundn(rmse_r,-3);
rmse_p=roundn(rmse_p,-3);
acc_r=roundn(acc_r,-3);
acc_p=roundn(acc_p,-3);

%% functions used in visualization

% calculate accuracy
function count=count_acc(ref,comp,error)
count=0;
for i=1:length(ref)
    if(comp(i)>=ref(i)-error&&comp(i)<=ref(i)+error)
        count=count+1;

    end
end
end

% plot rate of HR/RR
function rate_plot_subs(ref,com,error,L,T,mode,range)
figure;
set(gcf,'Position',[0,0, 4200,100])
axes('Position', [0.1000 0.1362 0.7750 0.7601]);

Rate_plot(ref, com ,error,L,T,mode);
ylim([range(1) range(2)])
xlim([0 length(ref)])
hold on

for i=1:36
    if (i==36)

        plot([i*L i*L],[range(1) range(2)],'color','k','LineStyle','-');

    else
        plot([i*L i*L],[range(1) range(2)],'color','#BEBEBE','LineStyle','--');

    end
    text(i*L-60, range(2)-0.16*(range(2)-range(1)), sprintf('%d',i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right','Color','#BEBEBE');

end

n=1:36;
k1={};

for i=1:36
    k1=[k1;num2str(i*5)];
end

set(gca,'XTick',n*L,'XTickLabel',k1);
plot([0 length(ref)],[range(2) range(2)],'color','#BEBEBE','LineStyle','-');
plot([length(ref) length(ref)],[range(1) range(2)],'color','#BEBEBE','LineStyle','-');

end






