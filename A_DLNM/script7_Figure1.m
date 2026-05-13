clear all
load('PlaceID_table.mat')
nuts = PlaceID_table.rows;
load S2.mat
S = shaperead('NUTS_RG_01M_2021_4326_LEVL_3.shp\NUTS_RG_01M_2021_4326_LEVL_3.shp');
%choose 45 (for 4.5) or 85 (for 8.5)
scnr=45;
OR = readtable(strcat('scripts\results\mean_RRsum_days_per_NUTS_proj',num2str(scnr),'.csv'));
%choose period to "remove", 2061–2075 or 2076–2090
tfx = find(strcmp(OR.period, '2076–2090'));
OR(tfx,:) = [];
tfx = find(OR.RR_sum_bin < 1.5);
OR(tfx,:) = [];
%for Figure title
tit1=string(unique(OR.period));
if scnr==45; tit2='4.5'; else; tit2='8.5'; end
OR = groupsummary(OR, "NUTS_ID", "sum", "mean_days_per_year");
OR_days = round(OR.sum_mean_days_per_year);
munia = 1:1514;
del = [];

for i = 1:1514
    tfx = find(PlaceID_table.rows == i);

    if (~isempty(tfx))
        tfind = find(OR.NUTS_ID == tfx);
    else
        tfind = [];
    end

    if (isempty(tfx))
        S(i).OR = NaN;
        del = [del; i];
    elseif (~isempty(tfx) && isempty(tfind))
        S(i).OR = 0;
    else
        S(i).OR = OR_days(tfind);
    end

    S(i).hind = S2.Hind(i);
    S(i).diff = S(i).OR - S(i).hind;
end

figure
mindensity = -12;%min([S.diff]);
maxdensity = 30;%max([S.diff]);
ncol = 18;

nneg = round(ncol * abs(mindensity) / (maxdensity - mindensity));
npos = ncol - nneg;

blueMap = flipud(winter(nneg));   % μπλε για αρνητικά
redMap  = autumn(npos);           % κόκκινα για θετικά

customMap = [blueMap; redMap];

colormap(customMap)
caxis([mindensity maxdensity])
densityColors = makesymbolspec('Polygon', {'diff', ...
    [mindensity maxdensity], 'FaceColor', customMap});

mapshow(S, 'DisplayType', 'polygon', ...
    'SymbolSpec', densityColors)

hold on
mapshow(S(del), 'FaceColor', [1 1 1], 'EdgeColor',[0 0 0]);
xlabel('Longitude')
ylabel('Latitude')
cb = colorbar;
hL = ylabel(cb,'\Delta days_{OR>1.5}');
set(hL,'Rotation',90);
title("\Delta days_{OR>1.5} for " + tit1 + " Scenario " + tit2)
axis([-10 36 34 54])
set(gca,'FontSize',15)