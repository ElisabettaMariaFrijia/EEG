function v = leadfield_hom_xy(xy_0, xy_1, xy_j, sigma)
% 

SIGMA = 1;
if nargin<4 || isempty(sigma)
    sigma = SIGMA;
end
xy_r = xy_1-xy_0;
r = sqrt(sum(xy_r.^2));
j = sqrt(sum(xy_j.^2));
cos_theta = (xy_r'*xy_j) / (r*j);

v = (j * cos_theta) / (4*pi*sigma*r^2);
