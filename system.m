#Sistema para grandes deformaciones
function dxdt = system(t, x)

  # Constantes
  k = 20; #rigidez
  m = 1; #masa (constante en el ej6)
  W = [0;0.5]; #vector de la fuerza externa
  L = 0.5; #vector en t0
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


  % Posiciones en t0
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

  # posiciones en t actual
   x1 = [x(1); x(2)];
   x2 = [x(3); x(4)];
   x3 = [x(5); x(6)];
   x4 = [x(7); x(8)];
   x5 = [x(9); x(10)];
   x6 = [x(11); x(12)];
   x7 = [x(13); x(14)];

  # longitud de los barras en t actual

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

  # fuerzas
   F = zeros(20,1);
   #F13
   F(1:2) = k*(1-L13_0/L13)*(x3-x1);
   #F23
   F(3:4) = k*(1-L23_0/L23)*(x3-x2);
   #F24
   F(5:6) = k*(1-L24_0/L24)*(x4-x2);
   #F34
   F(7:8) = k*(1-L34_0/L34)*(x4-x3);
   #F35
   F(9:10) = k*(1-L35_0/L35)*(x5-x3);
   #F45
   F(11:12) = k*(1-L45_0/L45)*(x5-x4);
   #F46
   F(13:14) = k*(1-L46_0/L46)*(x6-x4);
   #F56
   F(15:16) = k*(1-L56_0/L56)*(x6-x5);
   #F57
   F(17:18) = k*(1-L57_0/L57)*(x7-x5);
   #F67
   F(19:20) = k*(1-L67_0/L67)*(x7-x6);

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

