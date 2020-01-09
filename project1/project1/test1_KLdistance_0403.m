% Calculate the KL-distance between stationary dist. and current dist.
% In this transitionmatrix A, the stationary dist. is (6/11, 3/11, 2/11)

% Transition matrix type
matrix_type = 3;
if matrix_type == 1
    A = [0.8 0.2 0.3;0.1 0.6 0.3; 0.1 0.2 0.4];
elseif matrix_type == 2
    A = [0 1/2 1/3 1/6 0 0; 0 0 1/2 1/3 1/6 0; 0 0 0 1/2 1/3 1/6; 1/6 0 0 0 1/2 1/3; 1/3 1/6 0 0 0 1/2; 1/2 1/3 1/6 0 0 0];
else % random
    n = 1000;
    A = rand(n,n);
    for i = 1:n
        A(:,i) = A(:,i) / sum(A(:,i));
    end;
end;
n = size(A,1); % size of state space

% start type:
%   1: uniform
%   2: random start
%   else: random
start_type = 2;
if start_type == 1
    mu = ones(n,1)/n;
elseif start_type == 2
    mu = zeros(n,1);
    mu(randi([1,n],1)) = 1;
else % random
    % random start
    mu = rand(n,1);
    mu = mu/sum(mu);
end;

% Other properties
s = null(A-eye(n)); s = s/sum(s);
Hs = entropy(s);
N  = 10; % number of iterations
d = zeros(N,1);
H = zeros(N,1);

% Start running
for i = 1:N
    d(i) = KL_distance(s, mu);
    H(i) = entropy(mu);
    fprintf('[%02d] KL: %f; Entropy: %f\n', i, d(i), H(i));
    mu = A*mu;
end

% plot
figure();
subplot(1,2,1);
plot(d);
legend('KL-distance');
subplot(1,2,2);
plot(H,'r');
legend('Entropy');