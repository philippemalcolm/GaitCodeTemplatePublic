%%  Constant Metabolic Cost Estimation
% This function is a least-squares system identification of a constant
% input to a first-order dynamic system .
% This script finds a constant actual metabolic rate 'estimated_dot_E' that result in
% the least squared error between the predicted system response y_bar and
% the series of measurements y_meas.

%INPUTS
%t: a vector of times (in seconds) associated with each measurement of the system output
%y_meas: the measurements of the system output at each time in t
%tau: the time constant of the system (in seconds)

%OUTPUTS
% estimated_dot_E: the estimated metabolic rate of the period.
% y_bar: the best fit system outputs predicted by the polynomial
% relationship

% The system is modeled as a first order discrete dynamical system such that
% y(i) = (1-dt/tau)*y(i-1) + (dt/tau)*u(c,p)
% dt = t(i) - t(i-1)

%The system is equivalent to the forward Euler integration of a first-order
%continuos system of the form
% y_dot = (1/tau)*(u-y)

%The function in this script identifies the vector x_star that results in
%the least squared-error between y_bar and y_meas.

%x_star is the optimal solution to a specially formulated matrix equation
% A*x = y_meas, where x = [y_bar(1) u]'

% x_star can be found using the pseudo-inverse of A
% x_star = pinv(A)*y_meas .

% y_bar can be found by using x_star
% A*x_star = y_bar

% Adapted from the function of Wyatt Felt and C. David Remy at
% https://cn.mathworks.com/matlabcentral/fileexchange/51328-instantaneuos-cost-mapping
% Copyright@Juanjuan Zhang, Steven H Collins 11/30/2016


function [estimated_dot_E, y_bar, mean_squared_error] = metabolic_rate_estimation(t,y_meas,tau)

%Reshape the measurement vector if needed
if isrow(y_meas)
    y_meas = y_meas';
elseif ~isrow(y_meas) & ~iscolumn(y_meas)
    error('Measurements are not in a single column vector')
end

%Generate the matrix A
n_samp = length(t);
A = zeros(n_samp,2);
A(1,:) = [1,0];
for i = 2:length(t);
    for j = 1:2
        dt = t(i)-t(i-1);
        if j == 1
            A(i ,j) = A(i-1,j)*(1-dt/tau);
        else
            A(i ,j) = A(i-1,j)*(1-dt/tau) + (dt/tau);
        end
    end
end

%solve for the optimal parameters
x_star = pinv(A)*y_meas;
%solve for the best-fit predicted response
y_bar = A*x_star;
%find the error between the best-fit predicted response and the
%measurement vector
mean_squared_error = ((y_bar-y_meas)'*(y_bar-y_meas))/n_samp;
%solve for the optimal parameters
estimated_dot_E = x_star(2);

end