clear; close all; clc
tic
S = shaperead('NUTS_RG_01M_2021_4326_LEVL_3.shp\NUTS_RG_01M_2021_4326_LEVL_3.shp');
northEU = {'UK','DK','EE','FI','IS','IE','LV','LT','NO','SE','GB'};
westEU  = {'AT','BE','FR','DE','LI','LU','MC','NL','CH'};
ceEU    = {'BG','CZ','HU','PL','RO','SK','SI','HR','BA','ME','MK','RS','AL','XK'};
southEU = {'AD','CY','ES','EL','IT','MT','PT','SM','TR'};

north_idx = ismember({S.CNTR_CODE}, northEU);
west_idx  = ismember({S.CNTR_CODE}, westEU);
ce_idx    = ismember({S.CNTR_CODE}, ceEU);
south_idx = ismember({S.CNTR_CODE}, southEU);

regions = {'north','west','ce','south'};
regionTitles = {'Northern Europe','Western Europe','Central & Eastern Europe','Southern Europe'};

hind_years = 2010:2024;
proj_years = 2061:2090;
all_years  = [hind_years proj_years];

m1 = 5;  
m2 = 9; 
for r = 1:numel(regions)
    for y = all_years
        data.hind.(regions{r}){y}  = [];
        data.rcp45.(regions{r}){y} = [];
        data.rcp85.(regions{r}){y} = [];
    end
end
for i = 1:numel(S)

    % HINDCAST 
    f_hind = fullfile('hindcast',[num2str(i) '.csv.estimated_indexP.csv']);
    if isfile(f_hind)
        T = readtable(f_hind);
        for y = hind_years
            fx = year(T.date)==y & month(T.date)>=m1 & month(T.date)<=m2;
            vals = T.indexP(fx);
            if isempty(vals), continue; end

            if north_idx(i)
                data.hind.north{y} = [data.hind.north{y}; vals];
            elseif west_idx(i)
                data.hind.west{y}  = [data.hind.west{y}; vals];
            elseif ce_idx(i)
                data.hind.ce{y}    = [data.hind.ce{y}; vals];
            elseif south_idx(i)
                data.hind.south{y} = [data.hind.south{y}; vals];
            end
        end
    end

    % 4.5 
    f45_01 = ['2061-2075/proj45/proj45_' num2str(i) '.csv.estimated_indexP.csv'];
    f45_02 = ['2076-2090/proj45/proj45_' num2str(i) '.csv.estimated_indexP.csv'];

    if isfile(f45_01)
        T1 = readtable(f45_01);
        T2 = readtable(f45_02);
        T = [T1; T2];

        for y = proj_years
            fx = year(T.date)==y & month(T.date)>=m1 & month(T.date)<=m2;
            vals = T.indexP(fx);
            if isempty(vals), continue; end

            if north_idx(i)
                data.rcp45.north{y} = [data.rcp45.north{y}; vals];
            elseif west_idx(i)
                data.rcp45.west{y}  = [data.rcp45.west{y}; vals];
            elseif ce_idx(i)
                data.rcp45.ce{y}    = [data.rcp45.ce{y}; vals];
            elseif south_idx(i)
                data.rcp45.south{y} = [data.rcp45.south{y}; vals];
            end
        end
    end

    % 8.5 
    f85_01 = ['2061-2075/proj85/proj85_' num2str(i) '.csv.estimated_indexP.csv'];
    f85_02 = ['2076-2090/proj85/proj85_' num2str(i) '.csv.estimated_indexP.csv'];

    if isfile(f85_01)
        T1 = readtable(f85_01);
        T2 = readtable(f85_02);
        T = [T1; T2];

        for y = proj_years
            fx = year(T.date)==y & month(T.date)>=m1 & month(T.date)<=m2;
            vals = T.indexP(fx);
            if isempty(vals), continue; end

            if north_idx(i)
                data.rcp85.north{y} = [data.rcp85.north{y}; vals];
            elseif west_idx(i)
                data.rcp85.west{y}  = [data.rcp85.west{y}; vals];
            elseif ce_idx(i)
                data.rcp85.ce{y}    = [data.rcp85.ce{y}; vals];
            elseif south_idx(i)
                data.rcp85.south{y} = [data.rcp85.south{y}; vals];
            end
        end
    end
end

toc
for r = 1:4 

    figure; hold on
    reg = regions{r};

    for j = 1:length(all_years)
        yr = all_years(j);
        if yr <= 2024

            dataVals = data.hind.(reg){yr};
            if isempty(dataVals), continue; end

            q = quantile(dataVals,[0.25 0.75]);
            med = median(dataVals);
            iqrVal = q(2)-q(1);
            lowerAdj = max(min(dataVals), q(1)-1.5*iqrVal);
            upperAdj = min(max(dataVals), q(2)+1.5*iqrVal);

            rectangle('Position',[j-0.2 q(1) 0.4 q(2)-q(1)], ...
                      'FaceColor','k','EdgeColor','k');
            plot([j-0.2 j+0.2],[med med],'w','LineWidth',2)

            plot([j j],[q(2) upperAdj],'k','LineWidth',1.5)
            plot([j j],[q(1) lowerAdj],'k','LineWidth',1.5)
            plot([j-0.05 j+0.05],[upperAdj upperAdj],'k','LineWidth',1.5)
            plot([j-0.05 j+0.05],[lowerAdj lowerAdj],'k','LineWidth',1.5)

        else

            data45 = data.rcp45.(reg){yr};
            data85 = data.rcp85.(reg){yr};

            pos45 = j - 0.15;
            pos85 = j + 0.15;

            % --- RCP 4.5
            if ~isempty(data45)
                q = quantile(data45,[0.25 0.75]);
                med = median(data45);
                iqrVal = q(2)-q(1);
                lowerAdj = max(min(data45), q(1)-1.5*iqrVal);
                upperAdj = min(max(data45), q(2)+1.5*iqrVal);

                rectangle('Position',[pos45-0.1 q(1) 0.2 q(2)-q(1)], ...
                          'FaceColor','b','EdgeColor','k');
                plot([pos45-0.1 pos45+0.1],[med med],'w','LineWidth',2)

                plot([pos45 pos45],[q(2) upperAdj],'b','LineWidth',1.5)
                plot([pos45 pos45],[q(1) lowerAdj],'b','LineWidth',1.5)
                plot([pos45-0.05 pos45+0.05],[upperAdj upperAdj],'b','LineWidth',1.5)
                plot([pos45-0.05 pos45+0.05],[lowerAdj lowerAdj],'b','LineWidth',1.5)
            end

            % --- RCP 8.5
            if ~isempty(data85)
                q = quantile(data85,[0.25 0.75]);
                med = median(data85);
                iqrVal = q(2)-q(1);
                lowerAdj = max(min(data85), q(1)-1.5*iqrVal);
                upperAdj = min(max(data85), q(2)+1.5*iqrVal);

                rectangle('Position',[pos85-0.1 q(1) 0.2 q(2)-q(1)], ...
                          'FaceColor','r','EdgeColor','k');
                plot([pos85-0.1 pos85+0.1],[med med],'w','LineWidth',2)

                plot([pos85 pos85],[q(2) upperAdj],'r','LineWidth',1.5)
                plot([pos85 pos85],[q(1) lowerAdj],'r','LineWidth',1.5)
                plot([pos85-0.05 pos85+0.05],[upperAdj upperAdj],'r','LineWidth',1.5)
                plot([pos85-0.05 pos85+0.05],[lowerAdj lowerAdj],'r','LineWidth',1.5)
            end
        end
    end
    plot([length(hind_years)+0.5 length(hind_years)+0.5],[0 100],'--k','LineWidth',2)
    xticks(1:length(all_years))
    xticklabels(string(all_years))
    xtickangle(45)
    ylim([0 3.5])
    xlim([0.5 length(all_years)+0.5])
    ylabel('IndexP')
    title(regionTitles{r})
    set(gca,'FontSize',15)

    h1 = plot(NaN,NaN,'s','Color','b','MarkerFaceColor','b');
    h2 = plot(NaN,NaN,'s','Color','r','MarkerFaceColor','r');
    legend([h1 h2],{'Scenario 4.5','Scenario 8.5'},'Location','northwest')
end