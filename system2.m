function dxdt = system(t, x)

  # Constantes
   k = 20;
   m = 0.5;
   W = 5;
   L0 = 0.5;

  # Posiciones
   x1 = x(1); y1 = x(2);
   x2 = x(3); y2 = x(4);
   x3 = x(5); y3 = x(6);
   x4 = x(7); y4 = x(8);
   x5 = x(9); y5 = x(10);
   x6 = x(11); y6 = x(12);
   x7 = x(13); y7 = x(14);

  # Velocidades
   vx1 = x(15); vy1 = x(16);
   vx2 = x(17); vy2 = x(18);
   vx3 = x(19); vy3 = x(20);
   vx4 = x(21); vy4 = x(22);
   vx5 = x(23); vy5 = x(24);
   vx6 = x(25); vy6 = x(26);
   vx7 = x(27); vy7 = x(28);

  # Longitud de los Resortes

   L13 = sqrt((x1-x3)^2 + (y1-y3)^2);
   L23 = sqrt((x2-x3)^2 + (y2-y3)^2);
   L24 = sqrt((x2-x4)^2 + (y2-y4)^2);
   L34 = sqrt((x3-x4)^2 + (y3-y4)^2);
   L35 = sqrt((x3-x5)^2 + (y3-y5)^2);
   L45 = sqrt((x4-x5)^2 + (y4-y5)^2);
   L46 = sqrt((x4-x6)^2 + (y4-y6)^2);
   L56 = sqrt((x5-x6)^2 + (y5-y6)^2);
   L57 = sqrt((x5-x7)^2 + (y5-y7)^2);
   L67 = sqrt((x6-x7)^2 + (y6-y7)^2);


  # dij's

##   dij13_x = (x1-x3) / L13;  dij13_y = (y1-y3) / L13;
##   dij23_x = (x2-x3) / L23;  dij23_y = (y2-y3) / L23;
##   dij24_x = (x2-x4) / L24;  dij24_y = (y2-y4) / L24;
##   dij34_x = (x3-x4) / L34;  dij34_y = (y3-y4) / L34;
##   dij35_x = (x3-x5) / L35;  dij35_y = (y3-y5) / L35;
##   dij45_x = (x4-x5) / L45;  dij45_y = (y4-y5) / L45;
##   dij46_x = (x4-x6) / L46;  dij46_y = (y4-y6) / L46;
##   dij56_x = (x5-x6) / L56;  dij56_y = (y5-y6) / L56;
##   dij57_x = (x5-x7) / L57;  dij57_y = (y5-y7) / L57;

  # F's

   F13_x = k*(L13-L0);
   F13_y = k*(L13-L0);


   F23_x = k*(L23-L0);
   F23_y = k*(L23-L0);

   F24_x = k*(L24-L0);
   F24_y = k*(L24-L0);

   F34_x = k*(L34-L0);
   F34_y = k*(L34-L0);

   F35_x = k*(L35-L0);
   F35_y = k*(L35-L0);

   F45_x = k*(L45-L0);
   F45_y = k*(L45-L0);

   F46_x = k*(L46-L0);
   F46_y = k*(L46-L0);

   F56_x = k*(L56-L0);
   F56_y = k*(L56-L0);

   F57_x = k*(L57-L0);
   F57_y = k*(L57-L0);

   F67_x = k*(L67-L0);
   F67_y = k*(L67-L0);

   # output

   dxdt = zeros(28,1);
   dxdt(1:14) = x(15:28);

   %condiciones de borde...
   dxdt(15) = 0; dxdt(16) = 0; %a1
   dxdt(17) = 0; dxdt(18) = 0; %a2
   %a3
   dxdt(19) = (F35_x + F34_x - F13_x - F23_x)/m;
   dxdt(20) = (F35_y + F34_y - F13_y - F23_y)/m;
   %a4
   dxdt(21) = (F46_x + F45_x - F24_x - F34_x)/m;
   dxdt(22) = (F46_y + F45_y - F24_y - F34_y)/m;
   %a5
   dxdt(23) = (F57_x + F56_x - F35_x - F45_x)/m;
   dxdt(24) = (F57_y + F56_y - F35_y - F45_y)/m;
   %a6
   dxdt(25) = (F67_x - F56_x - F46_x)/m;
   dxdt(26) = (F67_y - F56_y - F56_y)/m;
   %a7
   dxdt(27) = (W - F67_x - F57_x)/m;
   dxdt(28) = (W - F67_y - F57_y)/m;

