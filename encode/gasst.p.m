

 GasFlow2= sdpvar( n_GasBranch, n_T);
 GasFlowSymbol= binvar( n_GasBranch, n_T, 2);
 n_L_w2= 3;

 state_GasFlow2_nl= binvar( n_GasBranch, n_T, n_L_w2);
 GasFlow2_nl= sdpvar( n_GasBranch, n_T, n_L_w2);
 GasFlow2Max= zeros( n_GasBranch, 1);
 Cij= GasBranch(:, 4);
for  i= 1: n_GasBranch
 f_bus= GasBranch( i, 2);
 t_bus= GasBranch( i, 3);
 GasFlow2Max( i)= max( Cij( i)^ 2* abs( GasBus( f_bus, 2)^ 2- GasBus( t_bus, 3)^ 2), Cij( i)^ 2* abs( GasBus( f_bus, 3)^ 2- GasBus( t_bus, 2)^ 2));
 GasFlow2Max( i)= min( GasFlow2Max( i), 4);
end

 GasFlow2_interval= zeros( n_GasBranch, n_L_w2+ 1);
 GasFlow2_low= zeros( n_GasBranch, n_L_w2);
for  i= 1: n_GasBranch
 GasFlow2_interval( i,:)= 0: GasFlow2Max( i)/ n_L_w2: GasFlow2Max( i);
for  l= 1: n_L_w2
 GasFlow2_low( i, l)= sqrt( GasFlow2_interval( i, l));
end
end

 Fij_GasFlow2= zeros( n_GasBranch, n_L_w2);
for  i= 1: n_GasBranch
for  l= 1: n_L_w2
 Fij_GasFlow2( i, l)=( sqrt( GasFlow2_interval( i, l+ 1))- sqrt( GasFlow2_interval( i, l)))/( GasFlow2_interval( i, l+ 1)- GasFlow2_interval( i, l));
end
end



for  i= 1: n_GasBranch
for  t= 1: n_T
 st=[ st,
 sum( GasFlow2_nl( i, t,:))== GasFlow2( i, t),
 sum( state_GasFlow2_nl( i, t,:))== 1,
- sqrt( GasFlow2Max( i))<= GasFlow( i, t)<= sqrt( GasFlow2Max( i)),
];
for  l= 1: n_L_w2
 st=[ st,
 state_GasFlow2_nl( i, t, l)* GasFlow2_interval( i, l)<= GasFlow2_nl( i, t, l)<= state_GasFlow2_nl( i, t, l)* GasFlow2_interval( i, l+ 1),
 0<= GasFlow2_nl( i, t, l)<= GasFlow2_interval( i, l+ 1)
];
end
end
end

for  t= 1: n_T
for  i= 1: n_GasBranch
 GasFlow_temp= 0;
for  l= 1: n_L_w2
 GasFlow_temp= GasFlow_temp+
 state_GasFlow2_nl( i, t, l)* GasFlow2_low( i, l)+( GasFlow2_nl( i, t, l)- state_GasFlow2_nl( i, t, l)* GasFlow2_interval( i, l))* Fij_GasFlow2( i, l);
end




 f_bus= GasBranch( i, 2);
 t_bus= GasBranch( i, 3);
 st=[ st,
 GasFlowSymbol( i, t, 1)+ GasFlowSymbol( i, t, 2)== 1,
 implies( GasFlowSymbol( i, t, 1),[ GasPressure2( f_bus, t)>= GasPressure2( t_bus, t), GasFlow( i, t)== GasFlow_temp]),
 implies( GasFlowSymbol( i, t, 2),[ GasPressure2( f_bus, t)<= GasPressure2( t_bus, t), GasFlow( i, t)==- GasFlow_temp]),
];
end
end



for  i= 1: n_GasBranch
 f_bus= GasBranch( i, 2);
 t_bus= GasBranch( i, 3);
for  t= 1: n_T
 st=[ st,
 GasFlow2( i, t)== Cij( i)^ 2* abs( GasPressure2( f_bus, t)- GasPressure2( t_bus, t)),
];
end
end



for  i= 1: n_GasBus
for  t= 1: n_T
 st=[ st,
 GasBus( i, 3)^ 2<= GasPressure2( i, t)<= GasBus( i, 2)^ 2
];
end
end

for  t= 1: n_T
 st=[ st,
 GasPressure2( 1, t)== GasBus( 1, 2)^ 2
];
end