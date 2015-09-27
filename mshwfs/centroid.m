% RET = CENTROID(IM, THR).
%   RET = CENTROID(IMG, THR) computes the centroid of IMG using THR as the
%   relative threshold. Centroid works on column major order.
%   shstruct.ord_centres and shstruct.ord_sqgrid are stored in the x,y
%   plot() coordinates, (origin is in the top left, x points right, y
%   points down). [cc(1)+dd(2)-1, cc(3)+dd(1)-1].
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft

function [ret] = centroid(im, thr)

assert(isa(im, 'double'));

% global select;

if (nargin < 2)
    thr = 0;
end

[w, h] = size(im);

[yy, xx] = meshgrid(1:h, 1:w);
im(im < thr) = 0;
sumx = sum(reshape(xx.*im, numel(xx), 1));
sumy = sum(reshape(yy.*im, numel(yy), 1));
mass = sum(im(:));

% mass1 = 0;
% sumx1 = 0;
% sumy1 = 0;
% for x=1:w
%     for y=1:h
%         val1 = im(x, y);
%         if (val1 >= thr)
%             sumx1 = sumx1 + val1*x;
%             sumy1 = sumy1 + val1*y;
%             mass1 = mass1 + val1;
%         end
%     end
% end
% assert(norm(mass1 - mass) < 1e-10);
% assert(norm(sumx1 - sumx) < 1e-10);
% assert(norm(sumy1 - sumy) < 1e-10);
% mass = mass1;
% sumx = sumx1;
% sumy = sumy1;

ret = [sumx/mass, sumy/mass];
% ret = round(ret);

% if select
% sfigure(12);
% imshow(im);
% hold on;
% plot(ret(2), ret(1), 'xr');
% pause(0.1);
% end

end
