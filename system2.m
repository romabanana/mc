#Sistema para pequeñas deforaciones
function dxdt = system2(t, x)

  # Constantes
  k = 20; #rigidez
  m = 0.5; #masa
  W = [0;5]; #vector de la fuerza externa
  L = 0.5; #vector x en t0
  x0 = [ 0; 0;
         0; L;
         L; 0;
         L; L;
         2*L; 0;
         2*L; L;
         3*L; 0;
         0; 0;  #v1(0)=0 siempre
         0; 0;  #v2(0)=0 siempre
         0; 0;
         0; 0;
         0; 0;
         0; 0;
         0; 0];

  % posiciones de las masas en t0
  x1_0 = x0(1:2);
  x2_0 = x0(3:4);
  x3_0 = x0(5:6);
  x4_0 = x0(7:8);
  x5_0 = x0(9:10);
  x6_0 = x0(11:12);
  x7_0 = x0(13:14);


  # longitud de las barras en t0
  L13_0 = norm(x1_0 - x3_0);
  L23_0 = norm(x2_0 - x3_0);
  L24_0 = norm(x2_0 - x4_0);
  L34_0 = norm(x3_0 - x4_0);
  L35_0 = norm(x3_0 - x5_0);
  L45_0 = norm(x4_0 - x5_0);
  L46_0 = norm(x4_0 - x6_0);
  L56_0 = norm(x5_0 - x6_0);
  L57_0 = norm(x5_0 - x7_0);
  L67_0 = norm(x6_0 - x7_0);


  # posiciones de las masas en t actual
   x1 = [x(1); x(2)];
   x2 = [x(3); x(4)];
   x3 = [x(5); x(6)];
   x4 = [x(7); x(8)];
   x5 = [x(9); x(10)];
   x6 = [x(11); x(12)];
   x7 = [x(13); x(14)];

  # longitud de las barras en t actual

   L13 = norm(x1-x3);
   L23 = norm(x2-x3);
   L24 = norm(x2-x4);
   L34 = norm(x3-x4);
   L35 = norm(x3-x5);
   L45 = norm(x4-x5);
   L46 = norm(x4-x6);
   L56 = norm(x5-x6);
   L57 = norm(x5-x7);
   L67 = norm(x6-x7);

   # fuerzass
   F = zeros(20,1);
   #F13
   F(1:2) = k*((L13/L13_0)-1)*(x3_0-x1_0);
   #F23
   F(3:4) = k*((L23/L23_0)-1)*(x3_0-x2_0);
   #F24
   F(5:6) = k*((L24/L24_0)-1)*(x4_0-x2_0);
   #F34
   F(7:8) = k*((L34/L34_0)-1)*(x4_0-x3_0);
   #F35
   F(9:10) = k*((L35/L35_0)-1)*(x5_0-x3_0);
   #F45
   F(11:12) = k*((L45/L45_0)-1)*(x5_0-x4_0);
   #F46
   F(13:14) = k*((L46/L46_0)-1)*(x6_0-x4_0);
   #F56
   F(15:16) = k*((L56/L56_0)-1)*(x6_0-x5_0);
   #F57
   F(17:18) = k*((L57/L57_0)-1)*(x7_0-x5_0);
   #F67
   F(19:20) = k*((L67/L67_0)-1)*(x7_0-x6_0);

   # output

   dxdt = zeros(28,1);
   dxdt(1:14) = x(15:28);

   %condiciones de borde...
   dxdt(15) = 0; dxdt(16) = 0; %a1
   dxdt(17) = 0; dxdt(18) = 0; %a2
   %a3
   dxdt(19:20) = (F(9:10) + F(7:8) - F(1:2) - F(3:4))/m;
   %a4
   dxdt(21:22) = (F(13:14) + F(11:12) - F(5:6)- F(7:8))/m;
   %a5
   dxdt(23:24) = (F(17:18) + F(15:16) - F(9:10) - F(11:12))/m;
   %a6
   dxdt(25:26) = (F(19:20) - F(15:16) - F(13:14))/m;
   %a7
   dxdt(27:28) = (W - F(19:20) - F(17:18))/m;

