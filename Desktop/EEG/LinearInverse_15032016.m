%%
%number of sources
NUM_SOURCES = 5;
%number of electrodes
NUM_SENSORS = 15;
%superficial lenght
GRID_WIDTH = 10;
%distance source/electrode
LAYERS_SPACING = 2;
%electrical conductivity of the material
SIGMA = 1;
%signal noise ratio
SNR = 10;

%% COORDINATES OF THE ELECTRODES
%the sensors are positioned on the length of the layer, 
%with equidistant sensors,
%from -GRID_WIDTH/2 to GRID_WIDTH/2

%  
x_sensors = linspace(-GRID_WIDTH/2, GRID_WIDTH/2,NUM_SENSORS)';

%the y of the sensors is the same for all and is equal to LAYERS_SPACING
%(the sensors are on the surface)

% % %
y_sensors = LAYERS_SPACING*ones(NUM_SENSORS,1); 


%% COORDINATES OF SOURCES
%the sources are positioned on the length of the layer,
%with equidistant sources,
%from -GRID_WIDTH/2 to GRID_WIDTH/2

% % %
x_sources = linspace(-GRID_WIDTH/2, GRID_WIDTH/2,NUM_SOURCES)';

% y of the source is 0
%(sources are at the base)

% % %
y_sources = zeros(NUM_SOURCES,1);


%% DIPOLES ORIENTATION

%the dipoles are normally oriented to the surface (aka on y)

% % % versor x is 0 (use function zeros)
dx_sources = zeros(NUM_SOURCES,1);

% % % versor y is 1 (use function ones)
dy_sources = ones(NUM_SOURCES,1);
       
%% MATRIX DI LEAD FIELD

% % % calculates the Lead Field matrix
% the inputs required by the computeLeadField function are
% highlighted within the function itself
lf_mat=computeLeadField(NUM_SOURCES,NUM_SENSORS,x_sources,y_sources,x_sensors,y_sensors,dx_sources,dy_sources,SIGMA);

%% ACTIVATION OF SOURCES

% % % bell activation (use the hann function)
j = hann(NUM_SOURCES);
    
% % % x and y components of the activations 
x_j =zeros(NUM_SOURCES,1);
y_j =j.*ones(NUM_SOURCES,1);

%%SOLUTION OF THE DIRECT PROBLEM

% % % solve the direct problem (POTENZIALI ON SCALPO)
fwpot =lf_mat*j;

%% FIGURE DIRECT PROBLEM
figure(1)
LIproblemFig(NUM_SENSORS, NUM_SOURCES, x_sensors, y_sensors, x_sources, y_sources, j, x_j, y_j, fwpot, GRID_WIDTH, LAYERS_SPACING)
set(gcf, 'Name', 'Direct Problem') %nome della figura
title(sprintf('Direct Problem  |  %d sources  |  %d sensors  |  d = %d', ...
    NUM_SOURCES, NUM_SENSORS, LAYERS_SPACING));
%% MEASURES ON SENSORS

% % % generate noise (use the randn function) according to the set SNR
% Remember that:


             %  SNR = (segnale)^2 / (rumore)^2
             
noise_pot=(rand(NUM_SENSORS,1)*1/SNR);
%I add the noise to the scalp potential
%%% (fwpot)
 meas_pot =(noise_pot)+(fwpot);
% % CALCULATION OF THE REGULARIZATION PARAMETER
%% the inputs required by the define_lambda_opt function are
%% highlighted within the function itself
% %
 lambda_optimum = define_lambda_opt(NUM_SOURCES,NUM_SENSORS,j,lf_mat,fwpot,meas_pot);
 
%     
% %% REVERSE PROBLEM SOLUTION
%%%% pseudo-reverse matrix (use command \)
 ilf_mat =(lf_mat'*lf_mat+lambda_optimum+eye(NUM_SOURCES))\lf_mat';
% 
% % % % solve the inverse problem
%% SOURCES ij (5x1) = PSEUDOINVERSA (5x15) x SCALPO MEASURES (15x1)
 ij = ilf_mat*meas_pot;
% 
% % % %component of sources on x
 x_ij = zeros(NUM_SOURCES,1);
% 
% % % component of sources on y
 y_ij = ij.*ones(NUM_SOURCES,1);   
% 
% %% DEFINITION ERROR OF SOURCE
%
%%%% The error on sourc_error sources is equal to:
%% norm of (vector sources imposed - vector sources reconstructed) / number sources
%% use the norm function
 sourc_error =norm(j-ij)/NUM_SOURCES ;           
% 
% %% FIGURE DIRECT PROBLEM
 figure(2)
 LIproblemFig(NUM_SENSORS, NUM_SOURCES, x_sensors, y_sensors, x_sources, y_sources, ij, x_ij, y_ij, meas_pot, GRID_WIDTH, LAYERS_SPACING)
 set(gcf, 'Name', 'Inverse Problem')
 titfmt = [ ...
     'Inverse Problem  |  ' ...
     '\\lambda=%.2g  |  ' ...
    'SNR = %.2g  |  ' ...
     'RMSE_{src} = %.2g' ...
    ];
title(sprintf(titfmt, lambda_optimum, SNR, sourc_error));

%%FIGURE DIPOLI DIRECT / REVERSE PROBLEM
 figure(3)
 subplot()

 axis()
 text(x_sources, 1.2*ones(NUM_SOURCES, 1), cellstr(num2str(j,2)), ...  
     'HorizontalAlignment', 'center', ...
     'VerticalAlignment','baseline', ...
     'Rotation', 0);
 title('Forward Problem') 
 
 subplot()
stem();
axis()
 text();
 title('Inverse Problem') 
