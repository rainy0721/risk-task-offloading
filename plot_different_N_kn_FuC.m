function plot_different_N_kn_FuC(kns, Ns, PoFs)
    suptitle('FuC');
    marker = {'o', 'v', 's'};
    colors = {'r', 'b', 'g'};
    lines = {'-', '-', '-'};
    labels = {'kn = 0.8','kn = 1.2', 'kn = 10.5'};
 
    for index = 1:length(kns)
        for index_N = 1 : length(Ns)
             FuC(index,index_N) = PoFs{index,index_N} / PoFs{index,1};      
        end
         plot(Ns,FuC(index,:), lines{index}, 'Marker', marker{index}, 'MarkerSize', 7, 'DisplayName', labels{index}, 'LineWidth', 2, 'Color', colors{index})
         hold on
    end
    hold off
    xlabel('Number of Users', 'FontWeight', 'normal');
    ylabel('FuC', 'FontWeight', 'normal');
    legend('Location', 'southwest', 'FontSize', 24);
end