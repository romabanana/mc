clear all;
## Variables globales
global F45;
F45 = {};
global maxs;
maxs = {};

############################
#### Configuración #########
############################

global GRANDES_DIFF;
GRANDES_DIFF = 1;

global SENO = 1;

#####################################
#### Constantes #########
#####################################


global p = 3; # Densidad lineal de las barras.
global E = 200; # Módulo de elasticidad longitudinal de las barras.
global A = 0.1; # Área de sección transversal de las barras.
global P = 5.3;
global P1 = [P ; 0];
global P2 = [0; P];
global CEL = 1;
global TCEL = -1;
## Configuración de fuerza senoidal


## Vector x en t0;
d=5;
global x0 = [ 0; 0;
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

##
## Vector de B (conexiones)
## Orden de acuerdo a la tabla del tp;
global B = [
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

global L0 = zeros(19,1);
for i=1:19
  L0(i) = norm(x0(2*B(i,1)-1: 2*B(i,1)) - x0(2*B(i,2)-1:2*B(i,2)));
endfor

mb = p.*L0;

# masas de cada nodo;

global m = [
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



tiempo = 0:0.170:200; #0.225



[t,x] = ode45(@sistema, tiempo, x0); #más rapido que la ode23s en mi compu

TCEL_POS = 1;
if(TCEL != -1)
  for i=1:length(t)
    if(t(i) >= TCEL)
      TCEL_POS = i;
      break;
    endif
  endfor
else
  TCEL = t(end);
  TCEL_POS = length(t);
endif

N = length(F45);
t_barra_2 = zeros(N, 1);
maxd = zeros(N, 2);
for i = 1:N
  t_barra_2(i) = (F45{i}.F)/A;
  maxd(i,1) = maxs{i}.x;
  maxd(i,2) = maxs{i}.t;
endfor

t_nodo_11 = zeros(N, 1);
Faux = x(1:N,44);
t_nodo_11 = (Faux.*m(11))./A;

[maximo_desp, pos] = max(maxd(N,1));

[maximo_desp, pos] = max(maxd(1:N,1)); #599
printf("maximo desplazamiento: %.2f m\n", maximo_desp);
printf("en el tiempo: %.2f s\n",maxd(pos,2));


# Plot de las tensiones.


figure(1);
clf; grid on; hold on; title('Tensiones(t)');
plot(t(1:length(t_nodo_11)), t_nodo_11);
plot(t(1:length(t_barra_2)), t_barra_2);
plot(TCEL, 0, 'ro');

legend('Tensión en nodo 11', 'Tensión en barra 2', 'Marca de tiempo final');

# Plot de la animación.
figure(2);

for i = 1:3:TCEL_POS # para i con paso 5 en la longitud de t
  clf;
  plot_frame2(x(i, :)'); # plotea el frame
  title(sprintf('Tiempo = %.2f s', t(i)));
  drawnow;
  pause(0.005); # pausa para que se aprecie
endfor


