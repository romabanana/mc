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

tiempo = [0, 50];
[t,x] = ode45(@sistema, tiempo, x0); #más rapido que la ode23s en mi compu

##
##figure(1);
##subplot(2,2,1)
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

  subplot('position', [0.05 0.55 0.9 0.4]);
  plot_frame2(x(i, :)'); # plotea el frame
  title(sprintf('Time = %.2f s', t(i)));

  subplot(2,2,3)
  plot(t(1:i), x(1:i,1:2:22));
  xlabel('t');
  ylabel('x');

  subplot(2,2,4)
  plot(t(1:i), x(1:i,2:2:22));
  xlabel('t');
  ylabel('y');
  drawnow;
  pause(0.05); # pausa para que se aprecie


  end


