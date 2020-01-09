% urn problem

%% Init
clc;
clear;

n = 20; % number og balls

% transition matrix
A = zeros(n+1,n+1);
A(1,2) = 1;
A(n+1,n) = 1;
for i = 2:n
    A(i,i-1) = ((i-1)*(i-1))/(n*n);
    A(i,i+1) = ((n-i+1)*(n-i+1))/(n*n);
    A(i,i) = 1 - A(i,i-1) - A(i,i+1);
end
stationary = null(A'-eye(n+1));
stationary = stationary/sum(stationary);

%% Real Simulation
% In this section, we simulate a single trail in the urn problem. That is,
% we start from an initial state and then using the transition matrix to
% decide the next state of the system.

% Initial state
%   Using the number of balls to record which is the current state
a = n; % urn A
niter = 1000; % number of iterations

% image setting

imgA = zeros(n,1);
subplot(1,3,1); imshow(kron(imgA,ones(20)));
imgB = ones(n,1);
title(sprintf('Black: %d, White: %d', a, n-a));
subplot(1,3,2); imshow(kron(imgB,ones(20)));
title(sprintf('Black: %d, White: %d', n-a, a));
% state record
s = zeros(n+1,1);
s(1) = 0;
subplot(1,3,3);
stem(s);
axis([1,n+1,0,niter/3]);

for i = 1:niter
    if rand < a/n % urn A choose black
        if rand <= (n-a)/n % urn B choose black
        else % urn B choose white
            imgA(a) = 1;
            imgB(n-a+1) = 0;
            a = a-1;
        end
    else % urn A choose white
        if rand <= (n-a)/n % urn B choose black
            imgA(a+1) = 0;
            imgB(n-a) = 1;
            a = a+1;
        else % urn B choose white
        end
    end
    
    % update s
    s(n-a+1) = s(n-a+1)+1;
    
    % show result
    if mod(i,5) == 0
        subplot(1,3,1);
        imshow(kron(imgA,ones(20)));
        title(sprintf('Black: %d, White: %d', a, n-a));
        subplot(1,3,2);
        imshow(kron(imgB,ones(20)));
        title(sprintf('Black: %d, White: %d', n-a, a));
        subplot(1,3,3);
        stem(s); hold on;
        axis([1,n+1,0,niter/3]);
        title(sprintf('Iteration: %d', i));
        hold off;
        drawnow;
    end
end

%% Distribution Simulation
% We will focus on three properties:
%   1) Shannon Entropy
%   2) KL-Distance
%   3) Kolmogrov Entropy

% Initial state
start_type = 2;
if start_type == 1
    s = rand(1,n+1);
    s = s/sum(s);
elseif start_type == 2
    s = ones(1,n+1);
    s = s/sum(s);
end
ss = s; % record initial state distribution

% Transition matrix from first state
B = A;
    
niter = n*2;
e = zeros(niter);
d = zeros(niter);
r = zeros(niter);

problemfig = figure();
set(problemfig, 'Position', [0 0 1024 960]);
subplot(3,1,1);
stem(s); hold on;
legend('Distribution'); hold off;
axis([1,n+1,0,0.5]);
subplot(3,1,2);
plot(e); hold on;
legend('KL-distance'); hold off;
subplot(3,1,3);
plot(d); hold on;
legend('Conditioned Entropy','Shannon Entropy'); hold off;

for i = 1:niter
    s = s*A;
    d(i) = KL_distance(s',stationary);
    e(i) = entropy(s);
    % relative entropy
    r(i) = relativeentropy(ss,B);
    B = B*A;
    % plot
    figure(problemfig);
    set(problemfig, 'Position', [0 0 1024 960]);
    subplot(3,1,1); stem(s);
    axis([1,n+1,0,0.5]);
    title(sprintf('Iteration: %d', i));
    legend('Distribution');
    subplot(3,1,2); plot(real(d(1:i))); axis([0,niter,0,10]);
    title(sprintf('KL-distance: %f', d(i)));
    legend('KL-distance');
    subplot(3,1,3); plot(real(r(1:i))); hold on; plot(e(1:i),'r-'); axis([0,niter,0,3]);
    title(sprintf('Conditioned Entropy: %f; Shannon Entropy: %f', r(i), e(i)));
    legend('Conditioned Entropy', 'Shannon Entropy'); hold off;
    drawnow;
%     Mpeak(i) = getframe(problemfig);
end

% filename = sprintf('DistSim1.avi');
% movie2avi(Mpeak, filename,'Compression', 'None', 'fps', 1);
