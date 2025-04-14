function plot_frame2(pos)
##  clf; # borra la figura anterior
  hold on; # permite dibujar multiples cosas
  axis equal; # una unidad de x es igual a una unidad de y
  grid on; # activa la grilla
  axis([-5 50 -10 30]);  % limites del graph(xmin xmax ymin ymax)

  # posiciones de las masas
  x1 = pos(1);  y1 = pos(2);
  x2 = pos(3);  y2 = pos(4);
  x3 = pos(5);  y3 = pos(6);
  x4 = pos(7);  y4 = pos(8);
  x5 = pos(9);  y5 = pos(10);
  x6 = pos(11); y6 = pos(12);
  x7 = pos(13); y7 = pos(14);
  x8 = pos(15); y8 = pos(16);
  x9 = pos(17); y9 = pos(18);
  x10 = pos(19); y10 = pos(20);
  x11 = pos(21); y11 = pos(22);


  # dibuja las barras en negro
  line([x1 x4], [y1 y4],'linewidth', 4, 'color', 'k');
  line([x4 x5], [y4 y5],'linewidth', 4, 'color', 'k');
  line([x5 x2], [y5 y2],'linewidth', 4, 'color', 'k');
  line([x4 x8], [y4 y8],'linewidth', 4, 'color', 'k');
  line([x11 x9], [y11 y9],'linewidth', 4, 'color', 'k');
  line([x4 x7], [y4 y7],'linewidth', 4, 'color', 'k');
  line([x1 x3], [y1 y3],'linewidth', 4, 'color', 'k');
  line([x5 x10], [y5 y10],'linewidth', 4, 'color', 'k');
  line([x2 x6], [y2 y6],'linewidth', 4, 'color', 'k');
  line([x7 x11], [y7 y11],'linewidth', 4, 'color', 'k');
  line([x11 x10], [y11 y10],'linewidth', 4, 'color', 'k');
  line([x7 x8], [y7 y8],'linewidth', 4, 'color', 'k');
  line([x9 x10], [y9 y10],'linewidth', 4, 'color', 'k');
  line([x4 x3], [y4 y3],'linewidth', 4, 'color', 'k');
  line([x5 x6], [y5 y6],'linewidth', 4, 'color', 'k');
  line([x8 x11], [y8 y11],'linewidth', 4, 'color', 'k');
  line([x5 x9], [y5 y9],'linewidth', 4, 'color', 'k');
  line([x6 x10], [y6 y10],'linewidth', 4, 'color', 'k');
  line([x3 x7], [y3 y7],'linewidth', 4, 'color', 'k');

  # dibuja y rellena los puntos con rojo
  plot([x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11], [y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11], 'ro', 'MarkerFaceColor', 'r');

##  drawnow; # fuerza a octave a dibujar
end

