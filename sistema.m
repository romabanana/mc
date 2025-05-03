##⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀
##⠀⠀⠀⠀⢀⡴⣆⠀⠀⠀⠀⠀⣠⡀⠀⠀⠀⠀⠀⠀⣼⣿⡗⠀⠀⠀⠀
##⠀⠀⠀⣠⠟⠀⠘⠷⠶⠶⠶⠾⠉⢳⡄⠀⠀⠀⠀⠀⣧⣿⠀⠀⠀⠀⠀
##⠀⠀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣤⣤⣤⣤⣤⣿⢿⣄⠀⠀⠀⠀
##⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠙⣷⡴⠶⣦
##⠀⠀⢱⡀⠀⠉⠉⠀⠀⠀⠀⠛⠃⠀⢠⡟⠀⠀⠀⢀⣀⣠⣤⠿⠞⠛⠋
##⣠⠾⠋⠙⣶⣤⣤⣤⣤⣤⣀⣠⣤⣾⣿⠴⠶⠚⠋⠉⠁⠀⠀⠀⠀⠀⠀
##⠛⠒⠛⠉⠉⠀⠀⠀⣴⠟⢃⡴⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
##⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#############################
######## Función ############
#############################

function y = sistema(t,x)

#############################
######## Función ############
#############################
  global F45;
  global maxs;

  global GRANDES_DIFF;
  global SENO;
  global f;

  global p; # Densidad lineal de las barras.
  global E; # Módulo de elasticidad longitudinal de las barras.
  global A; # Área de sección transversal de las barras.
  global P1;
  global P;
  global P2;

  global x0;
  global B;
  global L0;
  global m;

  global CEL;
  global TCEL;
  # Inicialización vectores

  L = zeros(19,1);
  k = zeros(19,1);
  F = zeros(38,1);
  max_aux = zeros(19,1);

#############################
######## Función ############
#############################


  for i=1:19

    # Magnitudes en t
    L(i) = norm(x(2*B(i,1)-1: 2*B(i,1)) - x(2*B(i,2)-1:2*B(i,2)));

    # K en t;
    k(i) = (E*A)./L0(i);

    # Indices auxiliares.
    i1 = 2*B(i,1)-1;
    i2 = 2*B(i,2)-1;

    # Grandes o pequeñas deformaciones.
    if(GRANDES_DIFF)
      xi = x(i1:i1+1);
      xj = x(i2:i2+1);
      F_temp = k(i)*(1 - L0(i)/L(i)) * (xj - xi);
    else
      xi0 = x0(i1:i1+1);
      xj0 = x0(i2:i2+1);
      F_temp = k(i)*(1 - L0(i)/L(i)) * (xj0 - xi0);
    endif

    # Asigno al vector de fuerzas;
    F(2*i-1:2*i) = F_temp;

    ## Recupero Fuerza 45
    if(i==2)
      u = (x(7:8) - x(9:10)) ./ L(i);
      F45{end+1} = struct('F', F_temp(1), 't', t);
    endif

    # Registro máximo desplazamiento
    aux_x0 = x0(2*i-1:2*i);
    aux_xi = x(2*i-1:2*i);
    d = norm(aux_xi - aux_x0);
    max_aux(i) = d;

  endfor

  # Lo recupero.
  maxs{end+1} = struct('x', max(max_aux), 't', t);


  #########################################
  ############## Senoidal #################
  #########################################

  if(SENO)
    seno = sin(2*pi*f*t); % seno
    P1 = [P*seno; 0];
    P2 = [0; P*seno];
  endif
  #########################################
  ############## Salida ###################
  #########################################

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

  #########################################
  ######## Cálculo de la C.E.L.  ##########
  #########################################

  # Vector de Triangulos.
  T = [
    1 4 3;
    3 4 7;
    4 8 7;
    7 8 11;
    4 5 11;
  ];

  signo = zeros(5,1);
  signo_0 = zeros(5,1);

  for i = 1:4
    # Tomo vertices del Triangulo
    p0 = x(2*T(i,1)-1 : 2*T(i,1));
    p1 = x(2*T(i,2)-1 : 2*T(i,2));
    p2 = x(2*T(i,3)-1 : 2*T(i,3));

    # Vectores
    v1 = p1 - p0;
    v2 = p2 - p0;

    # Producto cruz y signo
    area = v1(1)*v2(2) - v1(2)*v2(1);
    signo(i) = sign(area);

    p0_0 = x0(2*T(i,1)-1 : 2*T(i,1));
    p1_0 = x0(2*T(i,2)-1 : 2*T(i,2));
    p2_0 = x0(2*T(i,3)-1 : 2*T(i,3));

    v1_0 = p1_0 - p0_0;
    v2_0 = p2_0 - p0_0;

    area_0 = v1_0(1)*v2_0(2) - v1_0(2)*v2_0(1);
    signo_0(i) = sign(area_0);
  endfor

  # Si existe diferencia de signos y se cumple la CEL entonces guarda TCEL y
  # setea CEL = false;
  if (any(signo != signo_0) && CEL)
    printf(" A los %.2f s  no se cumple la C.E.L\n", t);

    TCEL = t;
    CEL = 0;
  endif


