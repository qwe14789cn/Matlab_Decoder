function [ EN, P_branch, RB, RL, sum1]= co2pfsim( eh1load, eh2load, eh3load, genP1, genP2, genP3)















 N= 6;
 K= 3;
 M= 3;



 mpc. baseMVA= 100;








 mpc. bus=[
 1, 3, 0, 0, 0, 0, 1, 1.06, 0, 0, 1, 1.06, 0.94;
 2, 1, 21, 12.7, 0, 0, 1, 1.045,- 4.98, 0, 1, 1.06, 0.94;
 3, 1, 94, 19, 0, 0, 1, 1.01,- 12.72, 0, 1, 1.06, 0.94;
 4, 2, 0, 0, 0, 0, 1, 1.019,- 10.33, 0, 1, 1.06, 0.94;
 5, 1, 70, 1.6, 0, 0, 1, 1.02,- 8.78, 0, 1, 1.06, 0.94;
 6, 2, 0, 0, 0, 0, 1, 1.07,- 14.22, 0, 1, 1.06, 0.94;
];
 mpc. bus(:, 4)= 0;

 mpc. bus( 2, 3)= eh1load/ 100;
 mpc. bus( 3, 3)= eh2load/ 100;
 mpc. bus( 5, 3)= eh3load/ 100;
 bus= mpc. bus;


 mpc. gen=[
 1, 120, 3.83, 10, 0, 1.06, 100, 1, 332.4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
 4, 10, 20.87, 50,- 40, 1.045, 100, 1, 140, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
 6, 10,- 0.66, 40, 0, 1.01, 100, 1, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;

];

 mpc. gen( 1, 2)= genP1/ 100;
 mpc. gen( 2, 2)= genP2/ 100;
 mpc. gen( 3, 2)= genP3/ 100;


 gen= mpc. gen;


 mpc. branch=[
 1, 2, 0.01938, 0.05917, 0.0528, 0, 0, 0, 0, 0, 1,- 360, 360;
 2, 3, 0.05403, 0.22304, 0.0492, 0, 0, 0, 0, 0, 1,- 360, 360;
 3, 6, 0.04699, 0.19797, 0.0438, 0, 0, 0, 0, 0, 1,- 360, 360;
 6, 5, 0.05811, 0.17632, 0.034, 0, 0, 0, 0, 0, 1,- 360, 360;
 5, 4, 0.05695, 0.17388, 0.0346, 0, 0, 0, 0, 0, 1,- 360, 360;
 4, 1, 0.06701, 0.17103, 0.0128, 0, 0, 0, 0, 0, 1,- 360, 360;
 4, 2, 0.01335, 0.04211, 0, 0, 0, 0, 0, 0, 1,- 360, 360;

];
 nbranch= size( mpc. branch, 1);
 mpc. branch(:, 3)= mpc. branch(:, 3)* 1e-3;
 mpc. branch(:, 4)= mpc. branch(:, 4)* 1e-3;

[ L,~]= size( mpc. branch);

 B= zeros( N);
for  i= 1: L
 p= mpc. branch( i, 1);
 q= mpc. branch( i, 2);
 B( p, q)=- 1/ mpc. branch( i, 4);
 B( q, p)= B( p, q);
end

for  i= 1: N
 B( i, i)=- sum( B( i,:));
end

 slackbus= find( mpc. bus(:, 2)== 3);
 B( slackbus,:)=[];
 B(:, slackbus)=[];

 Z= inv( B);

 P= zeros( N, 1);
[ x_gen,~]= size( mpc. gen);
for  i= 1: x_gen
 P( mpc. gen( i, 1))= mpc. gen( i, 2);
end

 P2= zeros( N, 1);
for  i= 1: N
 P2( i, 1)= mpc. bus( i, 3);
end
 P= P- P2;
 P( slackbus,:)=[];
 theta= B\ P;









 index=( 1: N)';
 index( slackbus)=[];
 theta1= zeros( N, 1);
[ xx,~]= size( index);
for  i= 1: xx
 theta1( index( i))= theta( i);
end

 theta1( slackbus)= 0;

 P_branch= zeros( N, N);
for  i= 1: L
 p= mpc. branch( i, 1);
 q= mpc. branch( i, 2);
 xx= theta1( p)- theta1( q);
 P_branch( p, q)= xx/ mpc. branch( i, 4);
end

for  i= 1: N
for  j= 1: N
if  P_branch( i, j)== 0
 P_branch( i, j)=- P_branch( j, i);
end
end
end

 MM= zeros( N, L);
for  i= 1: L
 p= mpc. branch( i, 1);
 q= mpc. branch( i, 2);
if  theta1( p)> theta1( q)
 MM( p, i)= 1; MM( q, i)=- 1;
if  p== slackbus
 MM( p, i)= 0;
elseif  q== slackbus
 MM( q, i)= 0;
end
else 
 MM( p, i)=- 1; MM( q, i)= 1;
if  p== slackbus
 MM( p, i)= 0;
elseif  q== slackbus
 MM( q, i)= 0;
end
end
end



 PB= P_branch;

for  k= 1: N
for  kk= 1: N
if  PB( k, kk)< 0
 PB( k, kk)= 0;
end
end
end

















 PG= zeros( K, N);

for  k= 1: length( mpc. gen(:, 1))
 PG( k, mpc. gen( k, 1))= mpc. gen( k, 2);
end

 xigama1= ones( 1, K+ N);





 PZ=[ PB; PG];

 PN= diag( xigama1* PZ);










 EG=[ 850; 800; 750;];









 EN=( PN- PB')^(- 1)* PG'* EG;















 RB= diag( EN)* PB;

 RB= RB/ 1000;


 PL= zeros( M, N);
 bus_copy= mpc. bus;
for  k= 1: M
for  kk= 1: N
if  bus_copy( kk, 3)> 0
 PL( k, kk)= bus_copy( kk, 3);
 bus_copy( kk, 3)= 0;
break
end
end
end











 RL= PL* EN;
 RL= RL/ 1000;





















for  i= 1: N


end



for  i= 1: L
 p= mpc. branch( i, 1);
 q= mpc. branch( i, 2);

end



for  i= 1: L
 p= mpc. branch( i, 1);
 q= mpc. branch( i, 2);

end




 RU_N= zeros( K, N);
 RU_N= 0.001*( diag( EG)*( PN*( PN- PB')^(- 1)* PG')');



 RU_L= zeros( K, N);
 xigama2= ones( 1, M);
 RU_L=( RU_N* diag( xigama2* PL)* PN^(- 1));



 sum1= zeros( K, 1);
for  i= 1: K
 sum1( i, 1)= sum( RU_L( i,:));
end





















 temp=( xigama1* PZ)'.* EN;
 sumco2= zeros( N, 3);




 sumco2(:, 1)= 1: N;
for  i= 1: N
if  mpc. bus( i, 2)<= 1
 sumco2( i, 2)=- temp( i);
 sumco2( i, 3)= 0;
else 
 sumco2( i, 2)= 0;
 sumco2( i, 3)= temp( i);
end
end



end