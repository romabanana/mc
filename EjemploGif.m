%% Ejemplo de uso de Gif
nPo = 10;
nIter = 100;
s_NomArch = '../EjemploGif';

%%
m_x = rand(nPo,1);
m_y = rand(nPo,1);

%o_Po = plot(m_x,m_y,'o');
o_Po = scatter(m_x,m_y,[],rand(nPo,3));
o_Fig = gcf;

%%
gif([s_NomArch,'.gif'],'overwrite',true,'frame',gca,'LoopCount',1)
gif
%
for iiTer = 1:nIter
   m_x = rand(nPo,1);
   m_y = rand(nPo,1);
   %Para plot
   %set(o_Po,'XData',m_x,'YData',m_y)
   %Para scatter
   set(o_Po,'XData',m_x,'YData',m_y,'CData',rand(nPo,3))
   %En octave para mayor velocidad hay que poner la figura activa.
   %figure(o_Fig)
   %drawnow
   %
   gif
end
%Ocatve genera unos archivos muy grandes, se puede usar https://www.freeconvert.com/gif-compressor para
%comprimirlo.
%gif('clear')
fclose all;
