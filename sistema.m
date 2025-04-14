# Función del sistema
function y = sistema(t,x)

  # Constantes
  p = 3; # Densidad lineal de las barras.
  E = 200; # Módulo de elasticidad longitudinal de las barras.
  A = 0.1; # Área de sección transversal de las barras.
  P1 = [1.3 ; 0];
  P2 = [0; 1.3];

  # Vector x en t0;
  d=5;
  x0 = [ 0; 0;
         8*d; 0;
         d; d;
         2*d; d;
         6*d; d;
         7*d; d;
         2*d; 2*d;
         2*d+3.333; 2*d;
         6*d-3.333; 2*d;
         6*d; 2*d;
         4*d; 4*d;
         0; 0;  #v1(0)=0 siempre
         0; 0;  #v2(0)=0 siempre
         0; 0;
         0; 0;
         0; 0;
         0; 0;
         0; 0;
         0; 0;
         0; 0;
         0; 0;
         0; 0;
         ];

  % Posiciones en t0
  x1_0 = x0(1:2);
  x2_0 = x0(3:4);
  x3_0 = x0(5:6);
  x4_0 = x0(7:8);
  x5_0 = x0(9:10);
  x6_0 = x0(11:12);
  x7_0 = x0(13:14);
  x8_0 = x0(15:16);
  x9_0 = x0(17:18);
  x10_0 = x0(19:20);
  x11_0 = x0(21:22);


  # Longitud de las barras en t0
  # Orden de acuerdo a la tabla del tp;
 L0 = [
    norm(x1_0 - x4_0);     % L14_0
    norm(x4_0 - x5_0);     % L45_0
    norm(x2_0 - x5_0);     % L25_0
    norm(x4_0 - x8_0);     % L48_0
    norm(x9_0 - x11_0);    % L911_0
    norm(x4_0 - x7_0);     % L47_0
    norm(x1_0 - x3_0);     % L13_0
    norm(x5_0 - x10_0);    % L510_0
    norm(x2_0 - x6_0);     % L26_0
    norm(x7_0 - x11_0);    % L711_0
    norm(x10_0 - x11_0);   % L1011_0
    norm(x7_0 - x8_0);     % L78_0
    norm(x9_0 - x10_0);    % L910_0
    norm(x3_0 - x4_0);     % L34_0
    norm(x5_0 - x6_0);     % L56_0
    norm(x8_0 - x11_0);    % L811_0
    norm(x5_0 - x9_0);     % L59_0
    norm(x6_0 - x10_0);    % L610_0
    norm(x3_0 - x7_0);     % L37_0
  ];

  # Constantes de Rígidez.

  k = E*A/L0;

  # masas de las barras = p*l.

  mb = p*L0;

  # masas de cada nodo;

  m = [
    mb(1) + mb(7);
    mb(3) + mb(9);
    mb(7) + mb(14) + mb(19);
    mb(1) + mb(2) + mb(4) + mb(6) + mb(14);
    mb(2) + mb(3) + mb(8) + mb(15) + mb(17);
    mb(9) + mb(15) + mb(18);
    mb(6) + mb(10) + mb(12) + mb(19);
    mb(4) + mb(12) + mb(16);
    mb(5) + mb(13) + mb(17);
    mb(8) + mb(11) + mb(13) + mb(18);
    mb(5) + mb(10) + mb(11) + mb(16);
  ];

  m = 0.5*m; # mitad de la masa de la barra para cada nodo.

  # posiciones en t actual

  x1 = [x(1); x(2)];
  x2 = [x(3); x(4)];
  x3 = [x(5); x(6)];
  x4 = [x(7); x(8)];
  x5 = [x(9); x(10)];
  x6 = [x(11); x(12)];
  x7 = [x(13); x(14)];
  x8 = [x(15); x(16)];
  x9 = [x(17); x(18)];
  x10 = [x(19); x(20)];
  x11 = [x(21); x(22)];

  # longitud de los barras en t actual

  L = [
    norm(x1 - x4);     % L14
    norm(x4 - x5);     % L45
    norm(x2 - x5);     % L25
    norm(x4 - x8);     % L48
    norm(x9 - x11);    % L911
    norm(x4 - x7);     % L47
    norm(x1 - x3);     % L13
    norm(x5 - x10);    % L510
    norm(x2 - x6);     % L26
    norm(x7 - x11);    % L711
    norm(x10 - x11);   % L1011
    norm(x7 - x8);     % L78
    norm(x9 - x10);    % L910
    norm(x3 - x4);     % L34
    norm(x5 - x6);     % L56
    norm(x8 - x11);    % L811
    norm(x5 - x9);     % L59
    norm(x6 - x10);    % L610
    norm(x3 - x7);     % L37
  ];

  # fuerzas

  F = zeros(38,1);

  F(1:2) = k(1)*(1 - L0(1)/L(1)) * (x4 - x1); #F14
  F(3:4) = k(2)*(1 - L0(2)/L(2)) * (x5 - x4); #F45
  F(5:6) = k(3)*(1 - L0(3)/L(3)) * (x5 - x2); #F25
  F(7:8) = k(4)*(1 - L0(4)/L(4)) * (x8 - x4); #F48
  F(9:10) = k(5)*(1 - L0(5)/L(5)) * (x11 - x9); #F911
  F(11:12) = k(6)*(1 - L0(6)/L(6)) * (x7 - x4); #F47
  F(13:14) = k(7)*(1 - L0(7)/L(7)) * (x3 - x1); #F13
  F(15:16) = k(8)*(1 - L0(8)/L(8)) * (x10 - x5); #F510
  F(17:18) = k(9)*(1 - L0(9)/L(9)) * (x6 - x2); #F26
  F(19:20) = k(10)*(1 - L0(10)/L(10)) * (x11 - x7); #F711
  F(21:22) = k(11)*(1 - L0(11)/L(11)) * (x11 - x10); #F1011
  F(23:24) = k(12)*(1 - L0(12)/L(12)) * (x8 - x7); #F78
  F(25:26) = k(13)*(1 - L0(13)/L(13)) * (x10 - x9); #F910
  F(27:28) = k(14)*(1 - L0(14)/L(14)) * (x4 - x3); #F34
  F(29:30) = k(15)*(1 - L0(15)/L(15)) * (x6 - x5); #F56
  F(31:32) = k(16)*(1 - L0(16)/L(16)) * (x11 - x8); #F811
  F(33:34) = k(17)*(1 - L0(17)/L(17)) * (x9 - x5); #F59
  F(35:36) = k(18)*(1 - L0(18)/L(18)) * (x10 - x6); #F610
  F(37:38) = k(19)*(1 - L0(19)/L(19)) * (x7 - x3); #F37

  # output

  y = zeros(44,1);
  y(1:22) = x(23:44);

  %condiciones de borde...
  y(23:26) = 0;

  %a3 = (F34 + F37 - F13)/m3
  y(27:28) = (F(27:28) + F(37:38) - F(13:14))/m(3);

  %a4 = (F47 + F48 + F45 - P (???) - F34)/m4
  y(29:30) = (F(11:12) + F(7:8) + F(3:4) - P1 - F(27:28))/m(4);

  %a5 = (F510 + F59 + F56 + P (???) - F45 - F25)/m5
  y(31:32) = (F(15:16) + F(33:34) + F(29:30) + P1 - F(3:4) - F(5:6))/m(5);

  %a6 = (F610 - F56 - F26)/m6
  y(33:34) = (F(35:36) - F(29:30) - F(17:18))/m(6);

  %a7 = (F711 + F78 - F47 - F37)/m7
  y(35:36) = (F(19:20) + F(23:24) - F(11:12) - F(37:38))/m(7);

  %a8 = (F811 - F78 - F48)/m8
  y(37:38) = (F(31:32) - F(23:24) - F(7:8))/m(8);

  %a9 = (F911 + F910 - F59)/m9
  y(39:40) = (F(9:10) - F(25:26) - F(33:34))/m(9);

  #a10 = (F1011 - F910 - F610 - F510)/m10
  y(41:42) = (F(21:22) - F(25:26) - F(35:36) - F(15:16))/m(10);

  %a11 = (-P - F1011 - F911 - F811 - F711)/m11
  y(43:44) = (-P2 - F(21:22) - F(9:10) - F(31:32) - F(19:20))/m(11);

