function LIproblemFig(NUM_SENSORS, NUM_SOURCES, x_sensors, y_sensors, x_sources, y_sources, SOR, val_x, val_y, POTEN, GRID_WIDTH, LAYERS_SPACING)


X_surf = [x_sensors x_sensors]; 
deltaY_surf = .1*LAYERS_SPACING;                          
Y_surf = [y_sensors-deltaY_surf y_sensors+deltaY_surf]; 
Z_surf = -ones(NUM_SENSORS, 2); 


C_surf = [POTEN POTEN];  
clf 

hold on


surface(X_surf, Y_surf, Z_surf, C_surf);
shading interp
plot(x_sensors, y_sensors, 'wo:')  
text(x_sensors, y_sensors+deltaY_surf, num2str(POTEN,2), ...
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'middle', ...
    'Rotation', 90);


plot(x_sources, y_sources, 'r.:')   
text(x_sources, y_sources-.1, cellstr(num2str(SOR,2)), ...   
    'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'middle', ...
    'Rotation', 90);

for sou = 1:NUM_SOURCES                                    
    xsc_j = val_x(sou);
    ysc_j = val_y(sou);
    plot(x_sources(sou)+[0;xsc_j], y_sources(sou)+[0;ysc_j], 'r-')
end

hold off

axis([-1.5*GRID_WIDTH/2 +1.5*GRID_WIDTH/2 ...
    -.5*LAYERS_SPACING +1.5*LAYERS_SPACING])
axis equal
colormap cool 
colorbar 
