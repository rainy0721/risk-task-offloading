repetition = 1;
cases = struct('users', 'hetero');
expected_utility = [];
b = [];
PoF = [];
N = 50;
an = 0.1;
kns = [0.8,1.2,10.5];
for i = 1:length(kns)
    kn = kns(i);
    infile = ['saved_runs/results/individual/different kn/', cases.users, '_N_', num2str(N), '_an_', num2str(round(an, 3)), '_kn_', num2str(round(kn, 3)),  '_', num2str(repetition),'.mat'];
    data = load(infile);
    kati = data.results;
    expected_utility{i} = kati.expected_utility;
    b{i} = kati.b;
    PoF{i} = kati.Probability_converging;
    overhead{i} = kati.overall_head;
end
plot_different_kn(kns, b, PoF,expected_utility,overhead);
