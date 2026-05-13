clear all
load('hind.mat')
load('sc45.mat')
T_45 = [hind; sc45];
load('sc85.mat')
T_85 = [hind; sc85];

northEU = {'UK','DK','EE','FI','IS','IE','LV','LT','NO','SE','GB'};
westEU  = {'AT','BE','FR','DE','LI','LU','MC','NL','CH'};
ceEU    = {'BG','CZ','HU','PL','RO','SK','SI','HR','BA','ME','MK','RS','AL','XK'};
southEU = {'AD','CY','ES','EL','IT','MT','PT','SM','TR'};

regions = struct();
regions.noEU = northEU;
regions.weEU = westEU;
regions.ceEU = ceEU;
regions.soEU = southEU;
regionNames = fieldnames(regions);

for i = 2:4 
    figure
    hold on;
    regName = regionNames{i};
    
    regIdx_45 = ismember(T_45.Region, regName);
    regIdx_85 = ismember(T_85.Region, regName);

    years01 = 2010:2024; 
    years02 = 2061:2090; 
    years = [years01 years02];

    for j = 1:length(years)
        yr = years(j);

        if yr <= 2024
            idxH = regIdx_45 & T_45.year == yr;
            data = T_45.RR_model(idxH);

            if ~isempty(data)
                q = quantile(data,[0.25 0.75]);
                med = median(data);
                iqrVal = q(2)-q(1);
                lowerAdj = max(min(data), q(1)-1.5*iqrVal);
                upperAdj = min(max(data), q(2)+1.5*iqrVal);

                
                rectangle('Position',[j-0.2 q(1) 0.4 q(2)-q(1)], 'FaceColor','k', 'EdgeColor','k');
                plot([j-0.2 j+0.2],[med med],'w','LineWidth',2)

                
                plot([j j],[q(2) upperAdj],'k','LineWidth',1.5)
                plot([j j],[q(1) lowerAdj],'k','LineWidth',1.5)

                
                plot([j-0.05 j+0.05],[upperAdj upperAdj],'k','LineWidth',1.5)
                plot([j-0.05 j+0.05],[lowerAdj lowerAdj],'k','LineWidth',1.5)
            end

        else
            idxH_45 = regIdx_45 & T_45.year == yr;
            idxH_85 = regIdx_85 & T_85.year == yr;
            data_45 = T_45.RR_model(idxH_45);
            data_85 = T_85.RR_model(idxH_85);

            pos_45 = j - 0.15;
            pos_85 = j + 0.15;

            if ~isempty(data_45)
                q = quantile(data_45,[0.25 0.75]);
                med = median(data_45);
                iqrVal = q(2)-q(1);
                lowerAdj = max(min(data_45), q(1)-1.5*iqrVal);
                upperAdj = min(max(data_45), q(2)+1.5*iqrVal);

                rectangle('Position',[pos_45-0.1 q(1) 0.2 q(2)-q(1)], 'FaceColor','b', 'EdgeColor','k');
                plot([pos_45-0.1 pos_45+0.1],[med med],'w','LineWidth',2)
                
                
                plot([pos_45 pos_45],[q(2) upperAdj],'b','LineWidth',1.5)
                plot([pos_45 pos_45],[q(1) lowerAdj],'b','LineWidth',1.5)
                plot([pos_45-0.05 pos_45+0.05],[upperAdj upperAdj],'b','LineWidth',1.5)
                plot([pos_45-0.05 pos_45+0.05],[lowerAdj lowerAdj],'b','LineWidth',1.5)
            end

            if ~isempty(data_85)
                q = quantile(data_85,[0.25 0.75]);
                med = median(data_85);
                iqrVal = q(2)-q(1);
                lowerAdj = max(min(data_85), q(1)-1.5*iqrVal);
                upperAdj = min(max(data_85), q(2)+1.5*iqrVal);

                rectangle('Position',[pos_85-0.1 q(1) 0.2 q(2)-q(1)], 'FaceColor','r', 'EdgeColor','k');
                plot([pos_85-0.1 pos_85+0.1],[med med],'w','LineWidth',2)
                
                % Whiskers
                plot([pos_85 pos_85],[q(2) upperAdj],'r','LineWidth',1.5)
                plot([pos_85 pos_85],[q(1) lowerAdj],'r','LineWidth',1.5)
                plot([pos_85-0.05 pos_85+0.05],[upperAdj upperAdj],'r','LineWidth',1.5)
                plot([pos_85-0.05 pos_85+0.05],[lowerAdj lowerAdj],'r','LineWidth',1.5)
            end
        end
    end
    hold on
    plot([15.5 15.5],[0 100],'--k','LineWidth',2)
    xticks(1:length(years))
    xticklabels(string(years))
    ylim([0 3])
    xlim([0.5 length(years)+0.5])
    xlabel('Year')
    ylabel('OR')
    xtickangle(45)
    
    h1 = plot(NaN,NaN,'s','Color','b','MarkerFaceColor','b');
    h2 = plot(NaN,NaN,'s','Color','r','MarkerFaceColor','r');
    
    if (i==2)
        title('Western Europe')
        legend([h1 h2],{'Scenario 4.5','Scenario 8.5'}, 'Location','northwest')
    elseif (i==3)
        title('Central & Eastern Europe')
    else
        title('Southern Europe')
    end
    set(gca,'Fontsize',15)
end