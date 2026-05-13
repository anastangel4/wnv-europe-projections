clear all
S=shaperead('NUTS_RG_01M_2021_4326_LEVL_3.shp\NUTS_RG_01M_2021_4326_LEVL_3.shp');
% Northern Europe
northEU = {'UK','DK','EE','FI','IS','IE','LV','LT','NO','SE','GB'};
% Western Europe
westEU = {'AT','BE','FR','DE','LI','LU','MC','NL','CH'};
% Central & Eastern Europe
ceEU = {'BG','CZ','HU','PL','RO','SK','SI','HR','BA','ME','MK','RS','AL','XK'};
% Southern Europe
southEU = {'AD','CY','ES','EL','IT','MT','PT','SM','TR'};
north_idx = ismember({S.CNTR_CODE}, northEU);
west_idx  = ismember({S.CNTR_CODE}, westEU);
ce_idx    = ismember({S.CNTR_CODE}, ceEU);
south_idx = ismember({S.CNTR_CODE}, southEU);
S_north = S(north_idx);
S_west  = S(west_idx);
S_ce    = S(ce_idx);
S_south = S(south_idx);
leg=cell(1,4);
hs=[];
colors = lines(4);
h(1)=mapshow(S_north,'FaceColor',colors(1,:));
hs=[hs h(1)];
h(2)=mapshow(S_west,'FaceColor',colors(2,:));
hs=[hs h(2)];
h(3)=mapshow(S_ce,'FaceColor',colors(3,:));
hs=[hs h(3)];
h(4)=mapshow(S_south,'FaceColor',colors(4,:));
hs=[hs h(4)];
axis([-30 50 30 85])
leg{1,1}='Northern Europe';
leg{1,2}='Western Europe';
leg{1,3}='Central & Eastern Europe';
leg{1,4}='Southern Europe';

leg1=leg(~cellfun('isempty',leg));
legend(hs,leg1,'Location','northeast');
xlabel('Longitude')
ylabel('Latitude')
