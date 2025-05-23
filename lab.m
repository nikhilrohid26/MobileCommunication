% Number of gNodeBs and UEs per gNodeB
num_gNBs = 5;
ues_per_gNB = 10;
total_UEs = num_gNBs * ues_per_gNB;

% Define gNodeB positions
gNB_pos = [20 20; 20 80; 50 50; 80 20; 80 80];

% Initialize UE positions and connections
UE_pos = zeros(total_UEs, 2);
UE_to_gNB = zeros(total_UEs, 1);

idx = 1;
for g = 1:num_gNBs
    for u = 1:ues_per_gNB
        % Generate UE positions around gNB (±10 unit range)
        UE_pos(idx, :) = gNB_pos(g, :) + (rand(1, 2)-0.5)*20;
        UE_to_gNB(idx) = g;
        idx = idx + 1;
    end
end

% Plotting
figure;
hold on;
title('gNodeBs and Connected UEs');
xlabel('X');
ylabel('Y');

% Plot gNodeBs
scatter(gNB_pos(:,1), gNB_pos(:,2), 200, 'r', 'filled');
text(gNB_pos(:,1), gNB_pos(:,2), "gNB" + string(1:num_gNBs), ...
    'VerticalAlignment','top','HorizontalAlignment','center', 'FontSize', 10);

% Plot UEs
scatter(UE_pos(:,1), UE_pos(:,2), 100, 'b', 'filled');
for i = 1:total_UEs
    % Draw connection line
    gnb = UE_to_gNB(i);
    plot([gNB_pos(gnb,1), UE_pos(i,1)], [gNB_pos(gnb,2), UE_pos(i,2)], 'k--');
    text(UE_pos(i,1), UE_pos(i,2), "UE" + string(i), ...
        'VerticalAlignment','bottom','HorizontalAlignment','right', 'FontSize', 8);
end

legend('gNodeB', 'UE', 'Connection');
axis([0 100 0 100]);
grid on;

% Preallocate table
T = table('Size', [total_UEs, 10], ...
    'VariableTypes', repmat("double", 1, 10), ...
    'VariableNames', {'UE_ID', 'gNB_ID', 'RSSI', 'SINR', 'Throughput', 'RBs', ...
                      'HARQ_retx', 'CQI', 'Latency', 'Jitter'});

% Generate synthetic metrics
for i = 1:total_UEs
    g = UE_to_gNB(i);
    dist = norm(gNB_pos(g,:) - UE_pos(i,:)); % distance

    T.UE_ID(i) = i;
    T.gNB_ID(i) = g;
    T.RSSI(i) = -30 - 0.5 * dist + randn(); % dBm
    T.SINR(i) = 20 - 0.2 * dist + randn(); % dB
    T.Throughput(i) = max(1, 100 - 0.8 * dist + randn()); % Mbps
    T.RBs(i) = randi([20, 100]);
    T.HARQ_retx(i) = randi([0, 5]);
    T.CQI(i) = randi([1, 15]);
    T.Latency(i) = max(1, 5 + 0.1 * dist + randn()); % ms
    T.Jitter(i) = max(0, 1 + 0.05 * dist + randn()); % ms
end

% Save to CSV
writetable(T, 'UE_gNB_metrics.csv');
disp('CSV file "UE_gNB_metrics.csv" saved.');
