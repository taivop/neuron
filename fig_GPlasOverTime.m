function [] = fig_GPlasOverTime(g_plas_history)


ymax = max(max(g_plas_history)) .* 1.05;
figure;

t = annotation('textbox',[0 0 0.1 0.1],'string','0');

for i=1:size(g_plas_history,2)
    delete(t);
    t = annotation('textbox',[0 0 0.1 0.1],'string',sprintf('%d',i),'FontSize',30,'EdgeColor','none');
    plot(g_plas_history(:,i));
    axis([-Inf,Inf,0,ymax]);
    pause(0.5);
end;