clear all;
## Variables globales
global F45;
F45 = {};
global maxs;
maxs = {};

############################
#### Configuración #########
############################

global GRANDES_DIFF = 1; # bool


% Seno no funciona en pequeñas diferencias... no es requerido.
global SENO = 1; # bool
global f = 0.05; # frecuencia


#####################################
############ Constantes #############
#####################################


global p = 3; # Densidad lineal de las barras.
global E = 200; # Módulo de elasticidad longitudinal de las barras.
global A = 0.1; # Área de sección transversal de las barras.
global P = 1.3; # Magnitud fuerza externa
global P1 = [P ; 0];
global P2 = [0; P];
global CEL = 1; # (bool) 1 --> C.E.L. se cumple.
global TCEL = -1; # Tiempo en que se dja de cumplir la C.E.L.


## Vector x en t0;
d=5;
global x0 = [ 0; 0;
       8*d; 0;
       d; d;
       2*d; d;
       6*d; d;
       7*d; d;
       2*d; 2*d;
       2*d+3+(1/3); 2*d;
       6*d-3-(1/3); 2*d;
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

## Vector de longitudes en t0
global L0 = zeros(19,1);
for i=1:19
  L0(i) = norm(x0(2*B(i,1)-1: 2*B(i,1)) - x0(2*B(i,2)-1:2*B(i,2)));
endfor


# masas de cada barra;
mb = p.*L0;

% Calculo de las masas por nodo.

global m = zeros(11, 1);
for barra = 1:19
  nodo1 = B(barra, 1);
  nodo2 = B(barra, 2);

  m(nodo1) += 0.05 * mb(barra);
  m(nodo2) += 0.05 * mb(barra);
endfor


#####################################
############### ODE #################
#####################################
% ============================================================================
% Ajuste del paso de tiempo (delta) para que la longitud de t
% generado por la ode coincida con la cantidad de logs (F45/maxs).
%
% 1. Primero uso delta arbitrario para estimar cuántos pasos ejecuta ode45
%  hasta llegar al tiempo final.
%
% 2. A partir de la cantidad de logs obtenidos (N = length(F45)), se recalcula
%    un nuevo delta fijo como delta = t_end / N.
%
% 3. Se reinicia F45 y maxs, y se realiza una segunda ode con el delta corregido.
%    Esto garantiza que los vectores de tiempo y logs tengan la misma longitud,
%    permitiendo así comparaciones 1 a 1 sin desfases.
%
% 4. Luego, se busca la posición temporal (TCEL_POS) y de log (TCEL_LPOS) donde se
%    alcanza o supera el tiempo crítico de evaluación de la longitud (TCEL).
%    Si TCEL = -1, se toma como referencia el último instante de simulación.
% ============================================================================

delta = 1;
t_end = 200*(1-(GRANDES_DIFF)) + 50*(GRANDES_DIFF) + 50*(SENO);
tiempo = 0:delta:t_end;
[_,_] = ode45(@sistema, tiempo, x0);

N = length(F45);
delta = t_end/N;
tiempo = 0:delta:t_end;
F45 = {};
maxs = {};

[t,x] = ode45(@sistema, tiempo, x0); #más rapido que la ode23s en mi compu

## Busqueda del TCEL en el vector t.
flag1 = 1;
flag2 = 1;
TCEL_POS = length(t);
TCEL_LPOS = length(F45);

if(TCEL != -1)
  tf = TCEL * (TCEL>50) + 50 * (TCEL <= 50);

  for i=1:length(F45)
    if((t(i) >= tf) && flag1)
      TCEL_POS = i;
      flag1 = 0;
    endif
    if((F45{i}.t >= tf) && flag2)
      TCEL_LPOS = i;
      flag2 = 0;
    endif
  endfor
endif


#####################################
######## items ii, iii ##############
#####################################

# Tension de la barra 2;
# F45 es el arreglo que recupera la fuerza F45 desde dentro de @system.
N = length(F45);
t_barra_2 = zeros(N, 2);

# maxs recupera le maximo desplazamiento por iteración.
maxd = zeros(N, 2); # Vector de maximos desplazamientos

if(N>length(x))
  N = length(x);
endif

for i = 1:N
  t_barra_2(i,1) = ((F45{i}.F)*p)/A; #nose porque p...# Càlculo e inserto la tension.
  t_barra_2(i,2) = F45{i}.t; # Càlculo e inserto la tension.

  maxd(i,1) = maxs{i}.x; # desplazamiento.
  maxd(i,2) = maxs{i}.t; # t en el que se produce.
endfor

[maximo_desp, pos] = max(maxd(1:TCEL_LPOS,1)); #599 # maximo de maximos.
printf("maximo desplazamiento: %.2f m\n", maximo_desp);
printf("en el tiempo: %.2f s\n",maxd(pos,2));

# Tension del nodo 11;
t_nodo_11 = zeros(N+1, 1);
Faux = x(1:N+1,44);
t_nodo_11 = (Faux.*m(11))./A; # F11 = a11*m11


# Plot de las tensiones.

figure(1);
if(~SENO)
  clf; grid on; hold on; title('Tensiones(t)');
  plot(t(1:TCEL_POS), t_nodo_11(1:TCEL_POS));
  plot(t_barra_2(1:TCEL_LPOS,2), t_barra_2(1:TCEL_LPOS,1));
  line([TCEL TCEL], ylim, 'linewidth', 2, 'color', 'r');
  legend('Tensión en nodo 11', 'Tensión en barra 2', 'Marca de tiempo final');
else
##  clf; grid on; hold on; title('x(t)');
##  plot(x(:,1:TCEL_POS), t(:,1:TCEL_POS));
##  plot(t_barra_2(1:TCEL_LPOS,2), t_barra_2(1:TCEL_LPOS,1));
  clf;
  grid on;
  hold on;
  title(sprintf('x(t) bajo P a %.2f hz', f));
  xlabel('Tiempo');
  ylabel('Posición');


  plot(t(1:TCEL_POS), x(1:TCEL_POS, 1:2), 'r');
  plot(t(1:TCEL_POS), x(1:TCEL_POS, 9:10), 'g');
  plot(t(1:TCEL_POS), x(1:TCEL_POS, 21:22), 'b');
  legend('Nodo 1 x','Nodo 1 y', 'Nodo 5 x','Nodo 5 y', 'Nodo 11 x', 'Nodo 11 y');

endif
# Plot de la animación. (item iv);
figure(2);

for i = 1:ceil(100*delta):TCEL_POS # para i con paso 5 en la longitud de t
  clf;
  plot_frame2(x(i, :)'); # plotea el frame
  title(sprintf('Tiempo = %.2f s', t(i)));
  drawnow;
  pause(0.005); # pausa para que se aprecie

endfor


