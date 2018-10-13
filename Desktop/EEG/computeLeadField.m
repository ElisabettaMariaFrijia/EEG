function lf_mat=computeLeadField(ING1,ING2, ING3, ING4, ING5, ING6, ING7, ING8, ING9)
%%%%INPUT:
% ING1: numero sorgenti 
% ING2: numero sensori 
% ING3: coordinata x delle sorgenti 
% ING4: coordinata y delle sorgenti 
% ING5: coordinata x dei sensori 
% ING6: coordinata y dei sensori 
% ING7: versore x delle sorgenti
% ING8: versore y delle sorgenti
% ING9: conduttività elettrica materiale 

%%%%OUTPUT
% 1: matrice di Lead Field


lf_mat = zeros(ING2, ING1);
%normalize so that potential from a radial dipole right below equals 1:
lf_normalization = 1/leadfield_hom_xy([0;0], [0;2], [0;1], ING9);

for sou = 1:ING1
    for sens = 1:ING2
        v = leadfield_hom_xy(...
            [ING3(sou); ING4(sou)], ...
            [ING5(sens); ING6(sens)], ...
            [ING7(sou); ING8(sou)], ...
            ING9 ...
            );
        %MATRICE DI LEAD FIELD
        lf_mat(sens, sou) = v * lf_normalization;
    end
end