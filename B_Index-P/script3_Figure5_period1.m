clear all; close all; clc
S = shaperead('NUTS_RG_01M_2021_4326_LEVL_3.shp\NUTS_RG_01M_2021_4326_LEVL_3.shp');
hind_years  = 2010:2024;
proj_years  = 2061:2075;
months_JJA  = 5:9;
threshold   = 1.5;
for i = 1:numel(S)

    % Hindcast
    f = fullfile('hindcast',[num2str(i) '.csv.estimated_indexP.csv']);
    if isfile(f)
        T = readtable(f);
        fx = ismember(year(T.date),hind_years) & ismember(month(T.date),months_JJA);
        if any(fx)
            vals = T.indexP(fx);
            S(i).med_hind  = median(vals,'omitnan');
            yrs = unique(year(T.date(fx)));
            for k=1:numel(yrs)
                S(i).days_above_thresh_hind(k) = sum(vals(year(T.date(fx))==yrs(k)) > threshold);
            end
            S(i).mean_days_hind = mean(S(i).days_above_thresh_hind,'omitnan');
        else
            S(i).med_hind = NaN; S(i).mean_days_hind = NaN;
        end
    else
        S(i).med_hind = NaN; S(i).mean_days_hind = NaN;
    end

    %4.5
    f45 = ['2061-2075/proj45/proj45_' num2str(i) '.csv.estimated_indexP.csv'];
    if isfile(f45)
        T = readtable(f45);
        fx = ismember(year(T.date),proj_years) & ismember(month(T.date),months_JJA);
        if any(fx)
            vals = T.indexP(fx);
            S(i).med_45 = median(vals,'omitnan');
            yrs = unique(year(T.date(fx)));
            for k=1:numel(yrs)
                S(i).days_above_thresh_45(k) = sum(vals(year(T.date(fx))==yrs(k)) > threshold);
            end
            S(i).mean_days_45 = mean(S(i).days_above_thresh_45,'omitnan');
        else
            S(i).med_45 = NaN; S(i).mean_days_45 = NaN;
        end
    else
        S(i).med_45 = NaN; S(i).mean_days_45 = NaN;
    end

    %8.5
    f85 = ['2061-2075/proj85/proj85_' num2str(i) '.csv.estimated_indexP.csv'];
    if isfile(f85)
        T = readtable(f85);
        fx = ismember(year(T.date),proj_years) & ismember(month(T.date),months_JJA);
        if any(fx)
            vals = T.indexP(fx);
            S(i).med_85 = median(vals,'omitnan');
            yrs = unique(year(T.date(fx)));
            for k=1:numel(yrs)
                S(i).days_above_thresh_85(k) = sum(vals(year(T.date(fx))==yrs(k)) > threshold);
            end
            S(i).mean_days_85 = mean(S(i).days_above_thresh_85,'omitnan');
        else
            S(i).med_85 = NaN; S(i).mean_days_85 = NaN;
        end
    else
        S(i).med_85 = NaN; S(i).mean_days_85 = NaN;
    end
    S(i).dmed_45   = S(i).med_45 - S(i).med_hind;
    S(i).dmed_85   = S(i).med_85 - S(i).med_hind;
    S(i).d_days_45 = S(i).mean_days_45 - S(i).mean_days_hind;
    S(i).d_days_85 = S(i).mean_days_85 - S(i).mean_days_hind;
end
nneg = 5; npos = 5;
blueMap = flipud(winter(9));
redMap  = autumn(9);
cmap = [blueMap; redMap];

% Δ Median Index-P (4.5)
figure
mindensity = -1.8; maxdensity = 1.8;

densityColors = makesymbolspec('Polygon', {'dmed_45', ...
    [mindensity maxdensity], 'FaceColor', cmap});

mapshow(S,'DisplayType','polygon','SymbolSpec',densityColors)
colormap(cmap); caxis([mindensity maxdensity])

cb = colorbar;
cb.Ticks = mindensity:0.2:maxdensity;  % set ticks every 0.2
cb.TickLabels = ["-1.8","","","","-1","","","","","0","","","","","1","","","","1.8"];
xlabel('Longitude')
ylabel('Latitude')
hL = ylabel(cb,'\Delta I-P_{Q50}');
set(hL,'Rotation',90);
title('\Delta I-P_{Q50} for 2061-2075 Scenario 4.5')
axis([-30 50 30 85]); set(gca,'FontSize',15)

axis([-30 50 30 85]); set(gca,'FontSize',15)

% Δ Median Index-P (8.5)
figure
densityColors = makesymbolspec('Polygon', {'dmed_85', ...
    [mindensity maxdensity], 'FaceColor', cmap});

mapshow(S,'DisplayType','polygon','SymbolSpec',densityColors)
colormap(cmap); caxis([mindensity maxdensity])

cb = colorbar;
cb.Ticks = mindensity:0.2:maxdensity;  % set ticks every 0.2
cb.TickLabels = ["-1.8","","","","-1","","","","","0","","","","","1","","","","1.8"];
xlabel('Longitude')
ylabel('Latitude')
hL = ylabel(cb,'\Delta I-P_{Q50}');
set(hL,'Rotation',90);
title('\Delta I-P_{Q50} for 2061-2075 Scenario 8.5')
axis([-30 50 30 85]); set(gca,'FontSize',15)

% Δ Days > threshold (4.5)
figure
mindensity = -90; maxdensity = 90;

densityColors = makesymbolspec('Polygon', {'d_days_45', ...
    [mindensity maxdensity], 'FaceColor', cmap});

mapshow(S,'DisplayType','polygon','SymbolSpec',densityColors)
colormap(cmap); caxis([mindensity maxdensity])

cb = colorbar;
cb.Ticks = mindensity:10:maxdensity;  % set ticks every 0.2
cb.TickLabels = ["-90","","","","","","","","","0","","","","","","","","","90"];
xlabel('Longitude')
ylabel('Latitude')
hL = ylabel(cb,'\Delta days_{I-P>1.5}');
set(hL,'Rotation',90);
title('\Delta days_{I-P>1.5} for 2061-2075 Scenario 4.5')
axis([-30 50 30 85]); set(gca,'FontSize',15)

% Δ Days > threshold (8.5)
figure
densityColors = makesymbolspec('Polygon', {'d_days_85', ...
    [mindensity maxdensity], 'FaceColor', cmap});

mapshow(S,'DisplayType','polygon','SymbolSpec',densityColors)
colormap(cmap); caxis([mindensity maxdensity])

cb = colorbar;
cb.Ticks = mindensity:10:maxdensity;  % set ticks every 0.2
cb.TickLabels = ["-90","","","","","","","","","0","","","","","","","","","90"];
xlabel('Longitude')
ylabel('Latitude')
hL = ylabel(cb,'\Delta days_{I-P>1.5}');
set(hL,'Rotation',90);
title('\Delta days_{I-P>1.5} for 2061-2075 Scenario 8.5')
axis([-30 50 30 85]); set(gca,'FontSize',15)
