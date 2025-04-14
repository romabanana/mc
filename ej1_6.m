# Initial Conditions

L = 0.5;

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

intervalo = [0,5]; # tiempo de simulacion

# Dos funciones: @system y @system2
# @system : grandes deformaciones
# @system2 : pequeñas deformaciones

##[t,x] = ode23s(@system, intervalo, x0);
[t,x] = ode45(@system, intervalo, x0); #más rapido que la ode23s en mi compu




for i = 1:10:length(t) # para i con paso 5 en la longitud de t
  plot_frame(x(i, :)'); # plotea el frame
  pause(.05); # pausa para que se aprecie
end


