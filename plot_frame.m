function plot_frame(pos)
  clf; hold on; axis equal; grid on;
  axis([-1 2.5 -0.5 2]);  % Ajustá según la escala de tu sistema

  x1 = pos(1);  y1 = pos(2);
  x2 = pos(3);  y2 = pos(4);
  x3 = pos(5);  y3 = pos(6);
  x4 = pos(7);  y4 = pos(8);
  x5 = pos(9);  y5 = pos(10);
  x6 = pos(11); y6 = pos(12);
  x7 = pos(13); y7 = pos(14);

  #lines
  line([x1 x3], [y1 y3], 'color', 'k');
  line([x2 x3], [y2 y3], 'color', 'k');
  line([x2 x4], [y2 y4], 'color', 'k');
  line([x3 x4], [y3 y4], 'color', 'k');
  line([x3 x5], [y3 y5], 'color', 'k');
  line([x4 x5], [y4 y5], 'color', 'k');
  line([x4 x6], [y4 y6], 'color', 'k');
  line([x5 x6], [y5 y6], 'color', 'k');
  line([x5 x7], [y5 y7], 'color', 'k');
  line([x6 x7], [y6 y7], 'color', 'k');

  #puntos
  plot([x1 x2 x3 x4 x5 x6 x7], [y1 y2 y3 y4 y5 y6 y7], 'ro', 'MarkerFaceColor', 'r');

  drawnow;
end

