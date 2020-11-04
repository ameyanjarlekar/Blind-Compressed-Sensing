function [output] = OMPa(Y,A,tol)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
r = Y;
[p q] = size(A);
A_fill = zeros(p,q);
theta = zeros(q,1);
i = 1;
while (norm(r)^2 > tol)
    m =0;
    track = 1;
    for j = 1:q
        if abs(r'* A(:,j)/norm(A(:,j))) > m
            m = abs((r'* A(:,j))/norm(A(:,j)));
            track = j;
        end
    end
    A_fill(:,track) = A(:,track);
    theta = pinv(A_fill)*Y;
    r = Y - A_fill*theta;  
    i = i+1;

end
output = theta;

