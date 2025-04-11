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

##x0 = x0(:);

span = [0,5];

[t,x] = ode45(@system2, span, x0);



##plot_frame(x0);
for i = 1:10:length(t)
  plot_frame(x(i, :)');
  pause(.05);
end


