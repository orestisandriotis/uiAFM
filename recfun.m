
%ein LS fit für die eine Funktion f(x)=a+bx+c*sin(dx+e)
%source:
%from http://www.mathworks.com/matlabcentral/answers/121579-curve-fitting-to-a-sinusoidal-function

function [s] = recfun(xdata, ydata) %[estimates,model] changed to


x=xdata; y=ydata;
yu = max(y);
yl = min(y);
yr = (yu-yl);                               % Range of ‘y’
yz = y-yu+(yr/2);
zx = x(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
per = 2*mean(diff(zx));                     % Estimate period
ym = mean(y);                               % Estimate offset

fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4) +b(5)*x;    % Function to fit
fcn = @(b) sum((fit(b,x) - y).^2);                              % Least-Squares cost function
s = fminsearch(fcn, [yr;  per;  -1;  ym; 0]);                       % Minimise Least-Squares
% 
% figure
% hold on
% plot(x(:,1),y(:,1))
% plot(x(:,1),s(1)*sin(2*pi/s(2)*x(:,1)+s*pi/s(3))+s(4)+s(5)*x(:,1))
% hold off




% model = @fun; 
% estimates = fminsearch(model, [0,0,0.3,7*pi,pi/20]); 
%     function [sse, FittedCurve] = fun(params) 
%         A = params(1); 
%         B = params(2);
%         C = params(3);
%         D = params(4);
%         E = params(5);
%         FittedCurve=A+xdata.*B+C*sin(D*xdata-E); 
%         ErrorVector = FittedCurve - ydata; 
%         sse = sum(ErrorVector .^ 2);         
%     end 
end