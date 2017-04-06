function [ center corners ] = p_to_box(varargin)
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

if (length(varargin) < 1 || any(length(varargin{1}) ~= 6))
  M = [0,1,0; 0,0,1];
else
  p = varargin{1};
  if (length(varargin) > 1 && strcmp(varargin{2},'geom'))
    p = affparam2mat(p);
    varargin(1:2) = [];
  else
    varargin(1) = [];
  end
  M = [p(1) p(3) p(4); p(2) p(5) p(6)];     %%affine变换参数
end

%----------------------------------------------------------
% Draw the box.
%----------------------------------------------------------
corners = [ 1,-w/2,-h/2; 1,w/2,-h/2; 1,w/2,h/2; 1,-w/2,h/2; 1,-w/2,-h/2 ]';
corners = M * corners;                  %%顶点
center = mean(corners(:,1:4),2);        %%中心
