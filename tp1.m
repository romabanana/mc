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

tiempo = 0:0.2:200;
[t,x] = ode45(@sistema, tiempo, x0); #más rapido que la ode23s en mi compu

##
##figure(2);
##plot(t, x(:,1:2:22));
##xlabel('t');
##ylabel('x');
##legend(arrayfun(@(i) sprintf('x_%d', i), 1:11, 'UniformOutput', false));
##
####figure(2);
##plot(t, x(:,2:2:22));
##xlabel('t');
##ylabel('y');
##legend(arrayfun(@(i) sprintf('y_%d', i), 1:11, 'UniformOutput', false));

for i = 1:3:length(t) # para i con paso 5 en la longitud de t
  clf;

  plot_frame2(x(i, :)'); # plotea el frame
  title(sprintf('Tiempo = %.2f s', t(i)));
  drawnow;
  pause(0.005); # pausa para que se aprecie
  end


