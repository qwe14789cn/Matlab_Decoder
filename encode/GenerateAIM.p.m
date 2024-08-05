function [ bvc, obs]= GenerateAIM( Nv)
global  A1 A2 A3 B1 B2 B3 C1 C2 C3 D1 D2 D3
 basic_num_vehicles=( Nv- 12)/ 12* 2;
 A1= 1+ round( rand* basic_num_vehicles);
 A2= 1+ round( rand* basic_num_vehicles);
 A3= 1+ round( rand* basic_num_vehicles);
 B1= 1+ round( rand* basic_num_vehicles);
 B2= 1+ round( rand* basic_num_vehicles);
 B3= 1+ round( rand* basic_num_vehicles);
 C1= 1+ round( rand* basic_num_vehicles);
 C2= 1+ round( rand* basic_num_vehicles);
 C3= 1+ round( rand* basic_num_vehicles);
 D1= 1+ round( rand* basic_num_vehicles);
 D2= 1+ round( rand* basic_num_vehicles);
 D3= 1+ round( rand* basic_num_vehicles);

while ( A1+ A2+ A3+ B1+ B2+ B3+ C1+ C2+ C3+ D1+ D2+ D3~= Nv)
 A1= 1+ round( rand* basic_num_vehicles);
 A2= 1+ round( rand* basic_num_vehicles);
 A3= 1+ round( rand* basic_num_vehicles);
 B1= 1+ round( rand* basic_num_vehicles);
 B2= 1+ round( rand* basic_num_vehicles);
 B3= 1+ round( rand* basic_num_vehicles);
 C1= 1+ round( rand* basic_num_vehicles);
 C2= 1+ round( rand* basic_num_vehicles);
 C3= 1+ round( rand* basic_num_vehicles);
 D1= 1+ round( rand* basic_num_vehicles);
 D2= 1+ round( rand* basic_num_vehicles);
 D3= 1+ round( rand* basic_num_vehicles);
end
global  intersection
 RW= intersection. road_width;
 num_lanes= intersection. num_lanes;
 temp= linspace( 0, RW,( num_lanes+ 1));
 lat= 0.5.*( temp( 2:eend )+ temp( 1: num_lanes));
 lon_lb= RW+ 5;
 lon_ub= lon_lb+ 50;

global  xc0 yc0 tc0
 xc0=[];
 yc0=[];
 tc0=[];
for  ii= 1:( A1+ A2+ A3)
 flag= 0;
while ( flag~= 1)
 theta= pi/ 2;
 temp_index_1= lon_lb+ lon_ub* rand;
 temp_index_2= lat( round( 1+ 2* rand));
if ( IsCurConfigFeasible( temp_index_2,- temp_index_1, theta))
 xc0=[ xc0, temp_index_2];
 yc0=[ yc0,- temp_index_1];
 tc0=[ tc0, theta];
 flag= 1;
end
end
end

for  ii= 1:( B1+ B2+ B3)
 flag= 0;
while ( flag~= 1)
 theta= pi;
 temp_index_1= lon_lb+ lon_ub* rand;
 temp_index_2= lat( round( 1+ 2* rand));
if ( IsCurConfigFeasible( temp_index_1, temp_index_2, theta))
 xc0=[ xc0, temp_index_1];
 yc0=[ yc0, temp_index_2];
 tc0=[ tc0, theta];
 flag= 1;
end
end
end

for  ii= 1:( C1+ C2+ C3)
 flag= 0;
while ( flag~= 1)
 theta=- 0.5* pi;
 temp_index_1= lon_lb+ lon_ub* rand;
 temp_index_2= lat( round( 1+ 2* rand));
if ( IsCurConfigFeasible(- temp_index_2, temp_index_1, theta))
 xc0=[ xc0,- temp_index_2];
 yc0=[ yc0, temp_index_1];
 tc0=[ tc0, theta];
 flag= 1;
end
end
end

for  ii= 1:( D1+ D2+ D3)
 flag= 0;
while ( flag~= 1)
 theta= 0;
 temp_index_1= lon_lb+ lon_ub* rand;
 temp_index_2= lat( round( 1+ 2* rand));
if ( IsCurConfigFeasible(- temp_index_1,- temp_index_2, theta))
 xc0=[ xc0,- temp_index_1];
 yc0=[ yc0,- temp_index_2];
 tc0=[ tc0, theta];
 flag= 1;
end
end
end

 BV_. x0= xc0;
 BV_. y0= yc0;
 BV_. theta0= tc0;

 thetalist=[];
 theta= ones( 1, A1).* pi;
 thetalist=[ thetalist, theta];
 theta= ones( 1, A2).* pi/ 2;
 thetalist=[ thetalist, theta];
 theta= ones( 1, A3).* 0;
 thetalist=[ thetalist, theta];

 theta= ones( 1, B1).* 1.5* pi;
 thetalist=[ thetalist, theta];
 theta= ones( 1, B2).* pi;
 thetalist=[ thetalist, theta];
 theta= ones( 1, B3).* 0.5* pi;
 thetalist=[ thetalist, theta];

 theta= ones( 1, C1).* 0;
 thetalist=[ thetalist, theta];
 theta= ones( 1, C2).*- 0.5* pi;
 thetalist=[ thetalist, theta];
 theta= ones( 1, C3).*- pi;
 thetalist=[ thetalist, theta];

 theta= ones( 1, D1).* 0.5* pi;
 thetalist=[ thetalist, theta];
 theta= ones( 1, D2).* 0;
 thetalist=[ thetalist, theta];
 theta= ones( 1, D3).*- 0.5* pi;
 thetalist=[ thetalist, theta];
 BV_. thetatf= thetalist;

 xctf=[];
 yctf=[];
global  vehicle_kinematics_ xyt_graph_search_
 distance= vehicle_kinematics_. v_common* xyt_graph_search_. t_max+ 50;
 index= 0;
for  ii= 1: A1
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance+ yc;
 xctf=[ xctf,- extra_distance];
 yctf=[ yctf, xc];
end

for  ii= 1: A2
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance+ yc;
 xctf=[ xctf, xc];
 yctf=[ yctf, extra_distance];
end

for  ii= 1: A3
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance+ yc;
 xctf=[ xctf, extra_distance];
 yctf=[ yctf,- xc];
end

for  ii= 1: B1
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance- xc;
 xctf=[ xctf,- yc];
 yctf=[ yctf,- extra_distance];
end

for  ii= 1: B2
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance- xc;
 xctf=[ xctf,- extra_distance];
 yctf=[ yctf, yc];
end

for  ii= 1: B3
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance- xc;
 xctf=[ xctf, yc];
 yctf=[ yctf, extra_distance];
end

for  ii= 1: C1
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance- yc;
 xctf=[ xctf, extra_distance];
 yctf=[ yctf, xc];
end

for  ii= 1: C2
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance- yc;
 xctf=[ xctf, xc];
 yctf=[ yctf,- extra_distance];
end

for  ii= 1: C3
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance- yc;
 xctf=[ xctf,- extra_distance];
 yctf=[ yctf,- xc];
end

for  ii= 1: D1
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance+ xc;
 xctf=[ xctf,- yc];
 yctf=[ yctf, extra_distance];
end

for  ii= 1: D2
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance+ xc;
 xctf=[ xctf, extra_distance];
 yctf=[ yctf, yc];
end

for  ii= 1: D3
 index= index+ 1;
 xc= BV_. x0( index);
 yc= BV_. y0( index);
 extra_distance= distance+ xc;
 xctf=[ xctf, yc];
 yctf=[ yctf,- extra_distance];
end
 BV_. xtf= xctf;
 BV_. ytf= yctf;

 bvc= cell( 1, Nv);
for  ii= 1: Nv
 elem. x0= BV_. x0( ii);
 elem. y0= BV_. y0( ii);
 elem. theta0= BV_. theta0( ii);
 elem. xtf= BV_. xtf( ii);
 elem. ytf= BV_. ytf( ii);
 elem. thetatf= BV_. thetatf( ii);
 bvc{ 1, ii}= elem;
end

 obs= ProduceStaticObstacles( RW);
end

function  val= IsCurConfigFeasible( x, y, theta)
global  xc0 yc0 tc0
 val= 1;
for  ii= 1: length( xc0)
if ( IsCenter1CollidingWithCenter2( x, y, theta, xc0( ii), yc0( ii), tc0( ii)))
 val= 0;
return ;
end
end
end

function  val= IsCenter1CollidingWithCenter2( x, y, theta, x1, y1, theta1)
global  vehicle_geometrics_
 prx= x+ vehicle_geometrics_. r2p* cos( theta);
 pry= y+ vehicle_geometrics_. r2p* sin( theta);
 pfx= x+ vehicle_geometrics_. f2p* cos( theta);
 pfy= y+ vehicle_geometrics_. f2p* sin( theta);

 qrx= x1+ vehicle_geometrics_. r2p* cos( theta1);
 qry= y1+ vehicle_geometrics_. r2p* sin( theta1);
 qfx= x1+ vehicle_geometrics_. f2p* cos( theta1);
 qfy= y1+ vehicle_geometrics_. f2p* sin( theta1);

 dff=( pfx- qfx)^ 2+( pfy- qfy)^ 2;
 drr=( prx- qrx)^ 2+( pry- qry)^ 2;
 dfr=( pfx- qrx)^ 2+( pfy- qry)^ 2;
 drf=( prx- qfx)^ 2+( pry- qfy)^ 2;
 buff= 0.5;
 R_sq= 4*( vehicle_geometrics_. radius)^ 2+ buff;
if (( dff< R_sq)||( drr< R_sq)||( dfr< R_sq)||( drf< R_sq))
 val= 1;
else 
 val= 0;
end
end

function  obs= ProduceStaticObstacles( RW)
 obs= cell( 1, 12);
 obs{ 1, 1}= ProduceEachObstacle( 100, 100, 88);
 obs{ 1, 2}= ProduceEachObstacle( 56, 56, 44);
 obs{ 1, 3}= ProduceEachObstacle( 34, 34, 22);
 obs{ 1, 4}= ProduceEachObstacle(- 100, 100, 88);
 obs{ 1, 5}= ProduceEachObstacle(- 56, 56, 44);
 obs{ 1, 6}= ProduceEachObstacle(- 34, 34, 22);
 obs{ 1, 7}= ProduceEachObstacle(- 100,- 100, 88);
 obs{ 1, 8}= ProduceEachObstacle(- 56,- 56, 44);
 obs{ 1, 9}= ProduceEachObstacle(- 34,- 34, 22);
 obs{ 1, 10}= ProduceEachObstacle( 100,- 100, 88);
 obs{ 1, 11}= ProduceEachObstacle( 56,- 56, 44);
 obs{ 1, 12}= ProduceEachObstacle( 34,- 34, 22);
end

function  elem= ProduceEachObstacle( x, y, radius)
global  xyt_graph_search_
 elem= cell( 1, xyt_graph_search_. num_nodes_t);
 sub_elem. x= x;
 sub_elem. y= y;
 sub_elem. radius= radius;
for  ii= 1: xyt_graph_search_. num_nodes_t
 elem{ 1, ii}= sub_elem;
end
end