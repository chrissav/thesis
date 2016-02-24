function [df, d2f, d3f] = dynamicsGradients(a1, a2, a3, a4, order)
% This is an auto-generated file.
%
% See <a href="matlab: help generateGradients">generateGradients</a>. 

% Check inputs:
typecheck(a1,'PlanePlant');
if (nargin<4) order=1; end
if (order<1) error(' order must be >= 1'); end
sizecheck(a1,[1  1]);
sizecheck(a2,[1  1]);
sizecheck(a3,[4  1]);
sizecheck(a4,[1  1]);

% Symbol table:
a3_3=a3(3);
a3_4=a3(4);
a4_1=a4(1);


% Compute Gradients:
df = sparse(4,6);
df(1,4) = -(7*10^(1/2)*cos(a3_3)*(1/cos(a3_4))^(1/2))/10;
df(1,5) = -(7*10^(1/2)*sin(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
df(2,4) = -(7*10^(1/2)*sin(a3_3)*(1/cos(a3_4))^(1/2))/10;
df(2,5) = (7*10^(1/2)*cos(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
df(3,5) = (7*10^(1/2) + (7*10^(1/2))/cos(a3_4)^2)/(10*(1/cos(a3_4))^(1/2));
df(4,5) = -10/3;
df(4,6) = 10/3;

% d2f
if (order>=2)
  d2f = sparse(4,36);
  d2f(1,22) = (7*10^(1/2)*sin(a3_3)*(1/cos(a3_4))^(1/2))/10;
  d2f(1,23) = -(7*10^(1/2)*cos(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d2f(1,28) = -(7*10^(1/2)*cos(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d2f(1,29) = -(7*10^(1/2)*sin(a3_3)*(1/cos(a3_4))^(5/2)*(sin(a3_4)^2 + 2))/40;
  d2f(2,22) = -(7*10^(1/2)*cos(a3_3)*(1/cos(a3_4))^(1/2))/10;
  d2f(2,23) = -(7*10^(1/2)*sin(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d2f(2,28) = -(7*10^(1/2)*sin(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d2f(2,29) = -(7*10^(1/2)*cos(a3_3)*(1/cos(a3_4))^(5/2)*(cos(a3_4)^2 - 3))/40;
  d2f(3,29) = (7*10^(1/2)*sin(a3_4)*(1/cos(a3_4))^(5/2)*(sin(a3_4)^2 + 2))/20;
else
  d2f=[];
end  % if (order>=2)

% d3f
if (order>=3)
  d3f = sparse(4,216);
  d3f(1,130) = (7*10^(1/2)*cos(a3_3)*(1/cos(a3_4))^(1/2))/10;
  d3f(1,131) = (7*10^(1/2)*sin(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d3f(1,136) = (7*10^(1/2)*sin(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d3f(1,137) = -(7*10^(1/2)*cos(a3_3)*(1/cos(a3_4))^(5/2)*(sin(a3_4)^2 + 2))/40;
  d3f(1,166) = (7*10^(1/2)*sin(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d3f(1,167) = (7*10^(1/2)*cos(a3_3)*(1/cos(a3_4))^(5/2)*(cos(a3_4)^2 - 3))/40;
  d3f(1,172) = (7*10^(1/2)*cos(a3_3)*(1/cos(a3_4))^(5/2)*(cos(a3_4)^2 - 3))/40;
  d3f(1,173) = -(7*10^(1/2)*sin(a3_3)*sin(a3_4)*(1/cos(a3_4))^(7/2)*(sin(a3_4)^2 + 14))/80;
  d3f(2,130) = (7*10^(1/2)*sin(a3_3)*(1/cos(a3_4))^(1/2))/10;
  d3f(2,131) = -(7*10^(1/2)*cos(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d3f(2,136) = -(7*10^(1/2)*cos(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d3f(2,137) = (7*10^(1/2)*sin(a3_3)*(1/cos(a3_4))^(5/2)*(cos(a3_4)^2 - 3))/40;
  d3f(2,166) = -(7*10^(1/2)*cos(a3_3)*sin(a3_4)*(1/cos(a3_4))^(3/2))/20;
  d3f(2,167) = -(7*10^(1/2)*sin(a3_3)*(1/cos(a3_4))^(5/2)*(sin(a3_4)^2 + 2))/40;
  d3f(2,172) = -(7*10^(1/2)*sin(a3_3)*(1/cos(a3_4))^(5/2)*(sin(a3_4)^2 + 2))/40;
  d3f(2,173) = -(7*10^(1/2)*cos(a3_3)*sin(a3_4)*(1/cos(a3_4))^(7/2)*(cos(a3_4)^2 - 15))/80;
  d3f(3,173) = -(10^(1/2)*(7*cos(a3_4)^4 + 70*cos(a3_4)^2 - 105))/(40*cos(a3_4)^4*(1/cos(a3_4))^(1/2));
else
  d3f=[];
end  % if (order>=3)


 % NOTEST
