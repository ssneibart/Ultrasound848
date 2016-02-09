clear
setup
mat_file_name = 's2000_hypo_phantom.mat';
%% Test Code
data = load(mat_file_name);
time_limit = 2;
run_time = 0;
run_count = 0;
fprintf('Testing ')
disp(beamformer)
fprintf('\b\b...')
while run_time<time_limit
clear b x z
rehash
tic
[b,x,z] = beamformer(data.rf,data.acq_params);
t = toc;
run_count = run_count+1;
run_time = run_time+t;
end
fprintf('done\n')
fprintf('total runs completed = %g\n',run_count);
fprintf('elapsed run time = %g seconds\n',run_time);
fprintf('average run time = %g seconds\n',run_time/run_count)
%imagesc(x,z,b,[-40 0]);
imagesc(b)
% axis image
shg