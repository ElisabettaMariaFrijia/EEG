function lambda_optimum=define_lambda_opt(ING1,ING2,ING3,ING4,ING5,ING6)
%%%%INPUT:
% ING1: numero sorgenti NUM_SOURCES
% ING2: numero sensori NUM_SENSORS
% ING3: attivazione delle sorgenti j
% ING4: matrice di lead field lf_mat
% ING5: potenziale su scalpo pulito pot0
% ING6: potenziale su scalpo rumoroso meas_pot
%%%%OUTPUT
% 1: lambda ottimo



lambdas = logspace(-5,5,101);
num_lambdas = length(lambdas);
sens_errors = zeros(num_lambdas, 1);
sens_relerrs = zeros(num_lambdas, 1);
sourc_errors = zeros(num_lambdas, 1);
sourc_energy = zeros(num_lambdas, 1);
sourc_relerrs = zeros(num_lambdas, 1);

for ll = 1:num_lambdas
    lam = lambdas(ll);
    ilf_mat_l = ING4' * inv(ING4*ING4' + lam * eye(ING2));
    ij_l = ilf_mat_l * ING6;
    mod_pot_l = ING4 * ij_l;
    sens_errors(ll) = norm(ING5-mod_pot_l) / ING2;
    sourc_errors(ll) = norm(ING3-ij_l) / ING1;
    sourc_energy(ll) = norm(ij_l) / ING1;
    sens_relerrs(ll) = sqrt(norm(ING5-mod_pot_l) / norm(ING5)) / ING2;
    sourc_relerrs(ll) = sqrt(norm(ING3-ij_l) / norm(ING3)) / ING1;
end

%
xdata = sens_errors;
if true
    ydata = sourc_errors;
   ylabel('RMSE_{src}')
else
    ydata = sourc_energy;
   ylabel('Energy_{src}')
end
[~, ll_opt] = min(log(xdata)+log(ydata)); 
[~, ll_opt2] = min(sens_relerrs); 
[~, ll_opt3] = min(sourc_relerrs); 
lambda_optimum = lambdas(ll_opt3);

%%
figure(43)
clf
hold on
plot(xdata, ydata, '.-')
    plot(xdata(1), ydata(1), 'v')
    plot(xdata(end), ydata(end), '^')
plot(xdata(ll_opt), ydata(ll_opt), 'ro')
% text(xdata(ll_opt), ydata(ll_opt), ...
%     sprintf('  \\lambda = %.2g', 10^log_lambda_opt))
hold off
set(gca, 'XScale', 'log', 'YScale', 'log')
xlabel('RMSE_{sens}')
title(sprintf('l-curve  |  \\lambda_{opt} = %.2g', lambdas(ll_opt)))


%%
figure(44)
clf
%
subplot 221
hold on
plot(sens_relerrs, sourc_relerrs, 'k.-')
plot(sens_relerrs(ll_opt2), sourc_relerrs(ll_opt), 'bo')
plot(sens_relerrs(ll_opt3), sourc_relerrs(ll_opt), 'ro')
hold off
xlabel('RelErr_{sens}')
ylabel('RelErr_{src}')
title('Relative Errors')
set(gca, 'XScale', 'log', 'YScale', 'log')
%
subplot 222
hold on
plot(lambdas, sourc_relerrs, 'r.-')
plot(lambdas(ll_opt3), sourc_relerrs(ll_opt), 'ko')
hold off
xlabel('\lambda')
ylabel('RelErr_{src}')
title(sprintf('Relative Error on sources |  \\lambda_{opt} = %.2g', ...
    lambdas(ll_opt3)))
set(gca, 'XScale', 'log', 'YScale', 'log')

subplot 223
hold on
plot(lambdas, sens_relerrs, 'b.-')
plot(lambdas(ll_opt2), sens_relerrs(ll_opt), 'ko')
hold off
xlabel('\lambda')
ylabel('RelErr_{sens}')
title(sprintf('Relative Error on sensors |  \\lambda_{opt} = %.2g', ...
    lambdas(ll_opt2)))
set(gca, 'XScale', 'log', 'YScale', 'log')
