%% The original rtn with flexible control


%% initialize
cons_flxb_rtn = [];

%% Melting Duration Bounds (12)
for time_index = 1 : NOF_INTERVAL - param.tau_U
    % N_i_EAh,t', starting time of tranfer task after melting
    temp = N_IT(index_task_melting + 1, ...
        (time_index + param.tau_L) : (time_index + param.tau_U));
    % N_i_Eh,t', starting time of melting task
    cons_flxb_rtn = [cons_flxb_rtn, sum(temp, 2) >= N_IT(index_task_melting, time_index)];
end
% last interval - param.tau_L
for time_index = NOF_INTERVAL - param.tau_U + 1 : NOF_INTERVAL - param.tau_L
    % N_i_EAh,t', starting time of tranfer task after melting
    temp = N_IT(index_task_melting + 1, ...
        (time_index + param.tau_L) : end);
    % N_i_Eh,t', starting time of melting task
    cons_flxb_rtn = [cons_flxb_rtn, sum(temp, 2) >= N_IT(index_task_melting, time_index)];
end
% last intervals 
cons_flxb_rtn = [cons_flxb_rtn, 0 >= N_IT(index_task_melting, NOF_INTERVAL - param.tau_L + 1 : end)];


%% Melting Power Bounds (13)
% lower power bound
cons_flxb_rtn = [cons_flxb_rtn, param.P_L * S_HT <= P_HT];
% upper power bound
cons_flxb_rtn = [cons_flxb_rtn, P_HT <= param.P_U * S_HT];


%% Melting Status Evolution (14)
cons_flxb_rtn = [cons_flxb_rtn, ...
    S_HT(:, 2 : end) - S_HT(:, 1 : end - 1) == ...
    N_IT(index_task_melting, 2 : end) - N_IT(index_task_melting + 1, 2 : end)];
cons_flxb_rtn = [cons_flxb_rtn, ...
    S_HT(:, 1) == N_IT(index_task_melting, 1)];% first time slot

cons_flxb_rtn = [cons_flxb_rtn, ...
    sum(S_HT(:, :)) <= 1];% first time slot

%% Melting Energy Requirement (15)
% in the >= form, same as ==
cons_flxb_rtn = [cons_flxb_rtn, ...
    sum(P_HT * delta, 2) >= param.nominal_power(1) * param.processing_time(1) / 60];
