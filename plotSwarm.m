function stop = plotSwarm(optimValues,state)
global objetivo1 objetivo2

stop = false; % This function does not stop the solver

switch state
    case 'init'
        %set(gcf, 'Position', get(0, 'Screensize'));
        set(gcf, 'Position', [10 10 800 700]);
        
        subplot(4, 2, [1, 3]);
        %title('Geometria dianteira');
        xlabel('Eixo X [mm]');
        ylabel('Eixo Y [mm]');
        zlabel('Eixo Z [mm]');
        grid on;
        
        
        subplot(4, 2, [2, 4]);


        subplot(4,2,5);
        title('Convergência do objetivo 1');
        grid on;
        xlabel("Iterações");
        ylabel(['Ganho de camber [' char(176) ']']);
        semilogy(optimValues.iteration,0,'-k','Tag','objetivo1');
        
        subplot(4,2,6);
        title('Convergência do objetivo 2');
        grid on;
        xlabel('Iterações');
        ylabel(['Ganho de camber [' char(176) ']']);
        semilogy(optimValues.iteration,0,'-k','Tag','objetivo2');
        
        subplot(4,2,[7,8]);
        title('Convergência da função objetivo');
        grid on;
        xlabel('Iterações');
        ylabel(['f(x) [' char(176) ']']);
        semilogy(optimValues.iteration,0,'-k','Tag','objetivo');
        
        
        setappdata(gcf,'t0',tic); % Set up a timer to plot only when needed
    case 'iter'
        bestP_3 = [optimValues.bestx(1), optimValues.bestx(2), optimValues.bestx(3)];
        bestP_6 = [optimValues.bestx(4), optimValues.bestx(5), optimValues.bestx(6)];
        
        [pontos, angulos] = calculaRoda(bestP_3, bestP_6);
        
        subplot(4, 2, [1, 3]);
        
        plotaRoda(pontos, angulos);
        
        hold on
        swarmP_3 = [optimValues.swarm(:,1), optimValues.swarm(:,2), optimValues.swarm(:,3)];
        plot3(swarmP_3(:,1), swarmP_3(:,2), swarmP_3(:,3), 'd', 'DisplayName', 'Enxame P_3', 'Color',[0,0.5,0], 'LineWidth',1);
        
        swarmP_6 = [optimValues.swarm(:,4), optimValues.swarm(:,5), optimValues.swarm(:,6)];
        plot3(swarmP_6(:,1), swarmP_6(:,2), swarmP_6(:,3), 'db', 'DisplayName', 'Enxame P_6', 'LineWidth',1);
        hold off
        
        A_kpi = angulos(1);
        A_caster = angulos(2);
        
        subplot(4, 2, [2, 4]);
        
        plotaGanhoCamber(A_kpi, A_caster);
        
        subplot(4,2,5);
        grid on;
        xlabel("Iterações");
        ylabel(['Ganho de camber [' char(176) ']']);
        plotHandle = findobj(get(gca,'Children'),'Tag','objetivo1'); % Get the subplot
        xdata = plotHandle.XData; % Get the X data from the plot
        newX = [xdata optimValues.iteration]; % Add the new iteration
        plotHandle.XData = newX; % Put the X data into the plot
        ydata = plotHandle.YData; % Get the Y data from the plot
        newY = [ydata objetivo1]; % Add the new value
        plotHandle.YData = newY; % Put the Y data into the plot
        
        subplot(4, 2, 6);
        grid on;
        xlabel('Iterações');
        ylabel(['Ganho de camber [' char(176) ']']);
        plotHandle = findobj(get(gca,'Children'),'Tag','objetivo2'); % Get the subplot
        xdata = plotHandle.XData; % Get the X data from the plot
        newX = [xdata optimValues.iteration]; % Add the new iteration
        plotHandle.XData = newX; % Put the X data into the plot
        ydata = plotHandle.YData; % Get the Y data from the plot
        newY = [ydata objetivo2]; % Add the new value
        plotHandle.YData = newY; % Put the Y data into the plot
        
        subplot(4,2,[7,8]);
        grid on;
        xlabel("Iterações");
        ylabel(['f(x) [' char(176) ']']);
        plotHandle = findobj(get(gca,'Children'),'Tag','objetivo'); % Get the subplot
        xdata = plotHandle.XData; % Get the X data from the plot
        newX = [xdata optimValues.iteration]; % Add the new iteration
        plotHandle.XData = newX; % Put the X data into the plot
        ydata = plotHandle.YData; % Get the Y data from the plot
        newY = [ydata optimValues.bestfval]; % Add the new value
        plotHandle.YData = newY; % Put the Y data into the plot
        
        if toc(getappdata(gcf,'t0')) > 1/30 % If 1/30 s has passed
          drawnow % Show the plot
          setappdata(gcf,'t0',tic); % Reset the timer
        end
        if ismember(optimValues.iteration, [1 2 3 4 10 20 40 60 80])
           saveas(gcf, "Iteração " + optimValues.iteration + " - fval " + optimValues.bestfval +" .jpg");
        end

    case 'done'
        saveas(gcf, "Iteração " + optimValues.iteration + " - fval " + optimValues.bestfval +" .jpg");
        % No cleanup necessary        
end
end

