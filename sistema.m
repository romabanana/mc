##⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀
##⠀⠀⠀⠀⢀⡴⣆⠀⠀⠀⠀⠀⣠⡀⠀⠀⠀⠀⠀⠀⣼⣿⡗⠀⠀⠀⠀
##⠀⠀⠀⣠⠟⠀⠘⠷⠶⠶⠶⠾⠉⢳⡄⠀⠀⠀⠀⠀⣧⣿⠀⠀⠀⠀⠀
##⠀⠀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣤⣤⣤⣤⣤⣿⢿⣄⠀⠀⠀⠀
##⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠙⣷⡴⠶⣦
##⠀⠀⢱⡀⠀⠉⠉⠀⠀⠀⠀⠛⠃⠀⢠⡟⠀⠀⠀⢀⣀⣠⣤⠿⠞⠛⠋
##⣠⠾⠋⠙⣶⣤⣤⣤⣤⣤⣀⣠⣤⣾⣿⠴⠶⠚⠋⠉⠁⠀⠀⠀⠀⠀⠀
##⠛⠒⠛⠉⠉⠀⠀⠀⣴⠟⢃⡴⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
##⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
### Función del sistema


function y = sistema(t,x)
  ################################
  ######## Configuración #########
  ################################
  grandes_diff = 1;
  fuerza_senoidal = 0;

  # Constantes
  p = 3; # Densidad lineal de las barras.
  E = 200; # Módulo de elasticidad longitudinal de las barras.
  A = 0.1; # Área de sección transversal de las barras.
  P = 1.3;
  P1 = [P ; 0];
  P2 = [0; P];

  if(fuerza_senoidal)
    seno = sin(t);
    P1 = P1.*seno;
    P2 = P2.*seno;
  endif

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


  # Vector de B (conexiones)
  # Orden de acuerdo a la tabla del tp;
  B = [
    1 4;
    4 5;
    2 5;
    4 8;
    9 11;
    4 7;
    1 3;
    5 10;
    2 6;
    7 11;
    10 11;
    7 8;
    9 10;
    3 4;
    5 6;
    8 11;
    5 9;
    6 10;
    3 7;
  ];

  # Inicialización vectores
  L0 = zeros(19,1);
  L = zeros(19,1);
  k = zeros(19,1);
  F = zeros(38,1);
  for i=1:19
    L0(i) = norm(x0(2*B(i,1)-1: 2*B(i,1)) - x0(2*B(i,2)-1:2*B(i,2)));
    L(i) = norm(x(2*B(i,1)-1: 2*B(i,1)) - x(2*B(i,2)-1:2*B(i,2)));

    k(i) = E*A/L0(i);
    i1 = 2*B(i,1)-1;
    i2 = 2*B(i,2)-1;
    if(grandes_diff)
      xi = x(i1:i1+1);
      xj = x(i2:i2+1);
      F_temp = k(i)*(1 - L0(i)/L(i)) * (xj - xi);
    else
      xi0 = x0(i1:i1+1);
      xj0 = x0(i2:i2+1);
      F_temp = k(i)*(L(i)/L0(i) - 1) * (xj0 - xi0);
    endif

    F(2*i-1:2*i) = F_temp;

  endfor


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

  ##   output

  y = zeros(44,1);
  y(1:22) = x(23:44);

  %condiciones de borde...
  y(23:26) = 0;

  %a3 = (F34 + F37 - F13)/m3
  y(27:28) = (F(27:28) + F(37:38) - F(13:14))/m(3);

  %a4 = (F47 + F48 + F45 - P (???) - F34 - F14)/m4
  y(29:30) = (F(11:12) + F(7:8) + F(3:4) - P1 - F(27:28) - F(1:2))/m(4);

  %a5 = (F510 + F59 + F56 + P (???) - F45 - F25)/m5
  y(31:32) = (F(15:16) + F(33:34) + F(29:30) + P1 - F(3:4) - F(5:6))/m(5);

  %a6 = (F610 - F56 - F26)/m6
  y(33:34) = (F(35:36) - F(29:30) - F(17:18))/m(6);

  %a7 = (F711 + F78 - F47 - F37)/m7
  y(35:36) = (F(19:20) + F(23:24) - F(11:12) - F(37:38))/m(7);

  %a8 = (F811 - F78 - F48)/m8
  y(37:38) = (F(31:32) - F(23:24) - F(7:8))/m(8);

  %a9 = (F911 + F910 - F59)/m9
  y(39:40) = (F(9:10) + F(25:26) - F(33:34))/m(9);

  #a10 = (F1011 - F910 - F610 - F510)/m10
  y(41:42) = (F(21:22) - F(25:26) - F(35:36) - F(15:16))/m(10);

  %a11 = (-P - F1011 - F911 - F811 - F711)/m11
  y(43:44) = (-P2 - F(21:22) - F(9:10) - F(31:32) - F(19:20))/m(11);

