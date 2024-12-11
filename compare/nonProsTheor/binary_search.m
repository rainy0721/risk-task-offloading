function root = binary_search(func, a, b, tolerance)
% ���ַ�����ʵ��
    while (b - a) > tolerance
        mid = (a + b) / 2;
        if func(mid) == 0
            root = mid;
            return;
        elseif func(mid) * func(a) < 0
            b = mid;
        else
            a = mid;
        end
    end
    root = (a + b) / 2;
end
