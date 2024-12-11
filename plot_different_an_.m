repetition = 1;
cases = struct('users', 'hetero');
expected_utility = [];
b = [];
PoF = [];
N = 50;
kn = 1.2;
an_s = [0.1,0.3,0.5];
for i = 1:length(an_s)
    an = an_s(i);
    infile = ['saved_runs/results/individual/different an/', cases.users, '_N_', num2str(N), '_an_', num2str(round(an, 3)), '_kn_', num2str(round(kn, 3)),  '_', num2str(repetition),'.mat'];
    data = load(infile);
    kati = data.results;
    expected_utility{i} = kati.expected_utility;
    b{i} = kati.b;
    PoF{i} = kati.Probability_converging;
end
plot_different_an(an_s, b, PoF,expected_utility);