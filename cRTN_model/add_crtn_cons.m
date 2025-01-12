%% The lin rtn without flexible control

%% initialize
cons_basic_crtn = [];

%% resource balance (a)
temp = repmat(G_IK, 1, 1, NOF_INTERVAL) .* D_IKT;% production
temp = permute(sum(temp, 2), [1, 3, 2]); % production (convert into proper dimension)
temp1 = [temp(2 : end, :); zeros(1, NOF_INTERVAL)]; % consumption, resource 1 consumed by task 2
cons_basic_crtn = [cons_basic_crtn, R_IT(:, 2 : end) <= R_IT(:, 1 : end - 1) + temp - temp1];% change of resource

% resource upper limit
cons_basic_crtn = [cons_basic_crtn, R_IT(:, 2 : end) >= 0];
cons_basic_crtn = [cons_basic_crtn, R_IT(1 : index_resource_mat_s(end), 2 : end) <= 1];

% initial resources 
cons_basic_crtn = [cons_basic_crtn, R_IT(:, 1) == 0];


%% Task execution (b)
% the total operating time in a time slot:
cons_basic_crtn = [cons_basic_crtn, sum(D_IKT, 2) == 1];% sum the second dimension

% non-negative & less than 1
cons_basic_crtn = [cons_basic_crtn, D_IKT <= 1];
cons_basic_crtn = [cons_basic_crtn, D_IKT >= 0];

% for operating points kun that are unavailable once the task starts (milp programming)
% task that keeps operating if R_i-1 > 0
% processing task: 1: non-stop once started
cons_basic_crtn = [cons_basic_crtn, ...
    permute(D_IKT(index_task_processing(1), 1, :), [1, 3, 2]) <= ones(1, NOF_INTERVAL) - u_RT(1, :)];
cons_basic_crtn = [cons_basic_crtn, ...
    R_IT(index_task_processing(1), 1 : end - 1) <= u_RT(1, :)];

% processing task: 2-4: non-stop once started
cons_basic_crtn = [cons_basic_crtn, ...
    permute(D_IKT(index_task_processing(2 : end), 1, :), [1, 3, 2]) <= ones(NOF_PROCESS - 1, NOF_INTERVAL) - u_RT(2 : NOF_PROCESS, :)];
cons_basic_crtn = [cons_basic_crtn, ...
    R_IT(index_task_processing(2 : end) - 1, 1 : end - 1) <= u_RT(2 : NOF_PROCESS, :)];% R_i-1
cons_basic_crtn = [cons_basic_crtn, ...
    R_IT(index_task_processing(2 : end), 1 : end - 1) <= u_RT(2 : NOF_PROCESS, :)];% R_i

% waiting task: non-stop once started
cons_basic_crtn = [cons_basic_crtn, ...
    permute(D_IKT(index_task_waiting, 1, :), [1, 3, 2]) <= ones(NOF_PROCESS, NOF_INTERVAL) - u_RT(NOF_PROCESS + 1 : end, :)];
cons_basic_crtn = [cons_basic_crtn, ...
    R_IT(index_task_waiting - 1, 1 : end - 1) <= u_RT(NOF_PROCESS + 1 : end, :)];% R_i-1
cons_basic_crtn = [cons_basic_crtn, ...
    R_IT(index_task_waiting, 1 : end - 1) <= u_RT(NOF_PROCESS + 1 : end, :)];% R_i

% tasks with 2 operating points (except the melting task)
temp = [index_task_processing(2 : end), index_task_output, index_task_input];
cons_basic_crtn = [cons_basic_crtn, ...
    D_IKT(temp, 3, :) == 0];


%% Transfer time (h)
% not operating if R_i-1 < 1
temp = [index_task_output, index_task_input];
cons_basic_crtn = [cons_basic_crtn, ...
    permute(D_IKT(temp, 2, :), [1, 3, 2]) == on_RT];% feels bad
% (b) guarantees that D_IKT(temp, 1, :) is also binvar
% cons_basic_crtn = [cons_basic_crtn, ...
%     permute(D_IKT(index_task_processing(2 : 4), 2, :), [1, 3, 2]) == on_IKT];


%% Product Delivery (8)
% final products by the end of the time horizon
cons_basic_crtn = [cons_basic_crtn, R_IT(end, end) == NOF_HEAT];

% add to cons
cons = [cons, cons_basic_crtn];

