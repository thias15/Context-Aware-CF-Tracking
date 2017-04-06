function [ p ] = box_to_p( varargin )
%BOX_TO_P Summary of this function goes here
%   Detailed explanation goes here
% function p_to_box(width,height, param, properties)
%                 ([width,height], param, properties)
%
%

%----------------------------------------------------------
% Process the input.
%----------------------------------------------------------
if (length(varargin{1}) == 2)
  w = varargin{1}(1);
  h = varargin{1}(2);
  varargin(1) = [];
else
  [w,h] = deal(varargin{1:2});
  varargin(1:2) = [];
end
%%***********获得宽，高***********%%

if (length(varargin) < 1 )%|| any(length(varargin{1}) ~= 2))
  M = [0,1,0; 0,0,1];
else
  corners = cell2mat(varargin{1});
  varargin(1) = [];
%  M = [p(1) p(3) p(4); p(2) p(5) p(6)];     %%affine变换参数
end

%----------------------------------------------------------
% Draw the box.
%----------------------------------------------------------
W = [ 1,-w/2,-h/2; 1,w/2,-h/2; 1,w/2,h/2; 1,-w/2,h/2; 1,-w/2,-h/2 ]';
M = corners/W;

p = [M(1,1), M(2,1),M(1,2),M(1,3),M(2,2),M(2,3) ];        %%中心

end

