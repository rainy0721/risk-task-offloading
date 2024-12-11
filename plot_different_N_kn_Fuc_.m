repetition = 1;
cases = struct('users', 'hetero');
Probability_converging = [];
an = 0.1;
kns = [0.8,1.2, 10.5];
Ns = [1,50,100,200];

Probability_converging = cell(length(kns), length(Ns)); % ����һ����ά cell ����洢 PoF ����

for kn_index = 1:length(kns)
    kn = kns(kn_index);
    for N_index = 1:length(Ns)
        N = Ns(N_index);
        infile = sprintf('saved_runs/results/individual/different N kn/%s_N_%d_an_%.1f_kn_%.1f_%d.mat', cases.users, N, an, kn, repetition);
        data = load(infile);
        kati = data.results;
        Probability_converging{kn_index, N_index} = kati.Probability_converging;
    end
end

plot_different_N_kn_FuC(kns, Ns, Probability_converging);
