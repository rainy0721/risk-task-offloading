repetition = 1;
cases = struct('users', 'hetero');
Probability_converging = [];
an_s = [0.1, 0.3, 0.5];
kn = 1.2;
Ns = [1,50,100,200];

Probability_converging = cell(length(an_s), length(Ns)); % 创建一个二维 cell 数组存储 PoF 数据

for an_s_index = 1:length(an_s)
    an = an_s(an_s_index);
    for N_index = 1:length(Ns)
        N = Ns(N_index);
        infile = sprintf('saved_runs/results/individual/different N an/%s_N_%d_an_%.1f_kn_%.1f_%d.mat', cases.users, N, an, kn, repetition);
        data = load(infile);
        kati = data.results;
        Probability_converging{an_s_index, N_index} = kati.Probability_converging;
    end
end

plot_different_N_an_FuC(an_s, Ns, Probability_converging);