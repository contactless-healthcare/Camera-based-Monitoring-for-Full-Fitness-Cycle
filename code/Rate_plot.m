function [count] = Rate_plot(ref, comp, error,L,T,mode)

len = min(length(ref),length(comp));
ref = ref(1:len);
comp = comp(1:len);
count=0;
x = 1:length(comp);
uplimit = ref(1:end)+error;
downlimit = ref(1:end)-error;
hold on
switch mode
    case 'mode1'
        for i=1:36
            ref_t=ref((i-1)*L+1:i*L);
            comp_t=comp((i-1)*L+1:i*L);
            mae=mean(abs(ref_t-comp_t));
            if(mae<error)
                plot(x((i-1)*L+1:i*L),comp_t,'Color',[0 0.4470 0.7410],'LineWidth',1.5);
            else
                plot(x((i-1)*L+1:i*L),comp_t,'Color',[0.6350 0.0780 0.1840],'LineWidth',1.5);
            end
        end
    case'mode2'
        for i = 1:length(comp)-1
            x1 = [x(i) x(i+1)];
            y1 = [comp(i) comp(i+1)];
            if comp(i+1)<=uplimit(i+1) && comp(i+1) > downlimit(i+1) && comp(i)<=uplimit(i) && comp(i) > downlimit(i)
                plot(x1,y1,'Color',[0 0.4470 0.7410],'LineWidth',1.5); % 蓝色
                count=count+1;
                hold on
            else
                plot(x1,y1,'Color',[0.6350 0.0780 0.1840],'LineWidth',1.5);
                hold on
            end
        end
end

xlabel('Time(s)');
p=patch([x,fliplr(x)],[downlimit,fliplr(uplimit)],'k','edgecolor','k');
alpha(p,0.05);
ylabel(T,'FontSize',10,'Fontname', 'Times New Roman','FontWeight','bold');

end