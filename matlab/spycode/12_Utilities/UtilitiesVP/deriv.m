function d = deriv(a)
% First derivative of vector using 2-point central difference.
% Example: deriv([1 1 1 2 3 4]) yields [0 0 .5 1 1 1]
%  T. C. O'Haver, 1988.
n=length(a);
% 1st point
d(1) = a(2)-a(1);
% last point
d(n) = a(n)-a(n-1);
% for intermediate points
% es. d(3) = (d(3)-d(2))./2;
for j = 2:n-1
  d(j)=(a(j+1)-a(j-1)) ./ 2;
end