clear all; clc;
load('hind.mat')
load('sc45.mat')
load('sc85.mat')
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

threshold = 1.5;      % epidemiological threshold
weeks_in_month = 4;    % conversion weeks -> months

hind.active = hind.RR_model > threshold;
sc45.active = sc45.RR_model > threshold;
sc85.active = sc85.RR_model > threshold;

season_hind = table();
season_sc45 = table();
season_sc85 = table();

for r = 2:numel(regionNames)
    reg = string(regionNames{r});

    % -------- HINDCAST
    years = unique(hind.year(hind.Region==reg));
    for y = years'
        idx = hind.Region==reg & hind.year==y & hind.active;
        if any(idx)
            w = hind.week(idx);
            season_hind = [season_hind;
                table(reg,y,min(w),max(w), ...
                'VariableNames',{'Region','Year','StartWeek','EndWeek'})];
        end
    end

    % -------- SSP2-4.5
    years = unique(sc45.year(sc45.Region==reg));
    for y = years'
        idx = sc45.Region==reg & sc45.year==y & sc45.active;
        if any(idx)
            w = sc45.week(idx);
            season_sc45 = [season_sc45;
                table(reg,y,min(w),max(w), ...
                'VariableNames',{'Region','Year','StartWeek','EndWeek'})];
        end
    end

    % -------- SSP5-8.5
    years = unique(sc85.year(sc85.Region==reg));
    for y = years'
        idx = sc85.Region==reg & sc85.year==y & sc85.active;
        if any(idx)
            w = sc85.week(idx);
            season_sc85 = [season_sc85;
                table(reg,y,min(w),max(w), ...
                'VariableNames',{'Region','Year','StartWeek','EndWeek'})];
        end
    end
end

season_hind.Duration_months = (season_hind.EndWeek - season_hind.StartWeek +1)/weeks_in_month;
season_sc45.Duration_months = (season_sc45.EndWeek - season_sc45.StartWeek +1)/weeks_in_month;
season_sc85.Duration_months = (season_sc85.EndWeek - season_sc85.StartWeek +1)/weeks_in_month;

dur_h_all = struct();
dur_h_all.Hindcast = season_hind.Duration_months(season_hind.Year>=2010 & season_hind.Year<=2024);

dur_45 = struct();
dur_45.NF = season_sc45.Duration_months(season_sc45.Year>=2061 & season_sc45.Year<=2075);
dur_45.FF = season_sc45.Duration_months(season_sc45.Year>=2076 & season_sc45.Year<=2090);

dur_85 = struct();
dur_85.NF = season_sc85.Duration_months(season_sc85.Year>=2061 & season_sc85.Year<=2075);
dur_85.FF = season_sc85.Duration_months(season_sc85.Year>=2076 & season_sc85.Year<=2090);

for r = 2:numel(regionNames)
    reg = string(regionNames{r});

    dur_h = season_hind.Duration_months(season_hind.Region==reg & season_hind.Year>=2010 & season_hind.Year<=2024);
    dur_45_nf = season_sc45.Duration_months(season_sc45.Region==reg & season_sc45.Year>=2061 & season_sc45.Year<=2075);
    dur_45_ff = season_sc45.Duration_months(season_sc45.Region==reg & season_sc45.Year>=2076 & season_sc45.Year<=2090);
    dur_85_nf = season_sc85.Duration_months(season_sc85.Region==reg & season_sc85.Year>=2061 & season_sc85.Year<=2075);
    dur_85_ff = season_sc85.Duration_months(season_sc85.Region==reg & season_sc85.Year>=2076 & season_sc85.Year<=2090);
    figure('Color','w'); hold on

    x_h = ones(size(dur_h));
    x_45_nf = 2*ones(size(dur_45_nf));
    x_45_ff = 3*ones(size(dur_45_ff));
    x_85_nf = 4*ones(size(dur_85_nf));
    x_85_ff = 5*ones(size(dur_85_ff));

    boxchart(x_h, dur_h, 'BoxFaceColor',[0.2 0.6 0.8])
    boxchart(x_45_nf, dur_45_nf, 'BoxFaceColor',[0.8 0.6 0.2])
    boxchart(x_45_ff, dur_45_ff, 'BoxFaceColor',[0.8 0.6 0.2])
    boxchart(x_85_nf, dur_85_nf, 'BoxFaceColor',[0.8 0.2 0.2])
    boxchart(x_85_ff, dur_85_ff, 'BoxFaceColor',[0.8 0.2 0.2])

    y_min = min([dur_h; dur_45_nf; dur_45_ff; dur_85_nf; dur_85_ff]);
    y_offset1 = y_min - 0.5;
    y_offset2 = y_min - 1.0;

    % -------------------------
    set(gca,'XTick',[1 2 3 4 5], ...
        'XTickLabel',{'2010–2024', 'Scnr 4.5 (2061–2075)', 'Scnr 4.5 (2076–2091)', 'Scnr 8.5 (2061–2075)', 'Scnr 8.5 (2076–2091)'})
    ylabel('Duration of active WNV transmission (months)')
    if (r==2)
        title('Western Europe')
    elseif (r==3)
        title('Central & Eastern Europe')
    else
        title('Southern Europe')
    end
    xlim([0.5 5.5])
    ylim([0 6.5])
end
