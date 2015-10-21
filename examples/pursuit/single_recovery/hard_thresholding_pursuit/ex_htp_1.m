close all;
clear all;
clc;
rng('default');
png_export = true;
pdf_export = false;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

mf = SPX_Figures();

% Signal space 
N = 256;
% Number of measurements
M = 32;
% Sparsity level
K = 4;
% Construct the signal generator.
gen  = SPX_SparseSignalGenerator(N, K);
% Generate bi-uniform signals
x = gen.biUniform(1, 2);
% Sensing matrix
Phi = SPX_SimpleDicts.gaussian_dict(M, N);
% Measurement vectors
y = Phi.apply(x);
% Hard thresholding pursuit solver instance
solver = SPX_HardThresholdingPursuit(Phi, K);
solver.Verbose = true;
solver.NormalizedMode = true;
% Solve the sparse recovery problem
result = solver.solve(y);
% Solution vector
z = result.z;
fprintf('Number of iterations: %d\n', result.iterations);
stats = SPX_SparseRecovery.recovery_performance(Phi, K, y, x, z);
SPX_SparseRecovery.print_recovery_performance(stats);

mf.new_figure('HTP solution');
subplot(411);
stem(x, '.');
title('Sparse vector');
subplot(412);
stem(z, '.');
title('Recovered sparse vector');
subplot(413);
stem(abs(x - z), '.');
title('Recovery error');
subplot(414);
stem(y, '.');
title('Measurement vector');