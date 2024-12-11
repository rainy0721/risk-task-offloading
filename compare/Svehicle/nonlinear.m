function[c,ceq] = nonlinear(x,i,avg_rate_userIndex_locationIndex,f_j_R,cj,F_j_V,fj,Di_,T_j_tol,E_j_tol,total,t_stay,power,b)
%非线性不等式约束
        c2 = 0;
        c5 = 0;
        c6 = 0;
        c9 = 0;
        for j = 1:length(x)
                if j <= 2
                    c1(j) = x(j)  / avg_rate_userIndex_locationIndex( i,j ) + x(j) * cj(i,1) / f_j_R;
                    c2 = c2 + c1(j);
                    c8(j) =  x(j) / avg_rate_userIndex_locationIndex(i,j) * power ;
                    c9 = c9+ c8(j);
                end
                if j > 2
                    if sum(b(:,j)) / Di_(j - 2) >=1
                        c3(j-2) = x(j) / avg_rate_userIndex_locationIndex( i,j ) + x(j)* cj(i,1) / fj(i,1) ;
                        c4(j-2) = 1e-16 * cj(i,1) * (fj(i,1))^ 2 *  x(j) ;
                        c5 = c5 + c3(j-2);
                        c6 = c6 + c4(j-2);
                        c8(j) =  x(j) / avg_rate_userIndex_locationIndex(i,j) * power ;
                        c9 = c9+ c8(j);
                    else
                        c3(j-2) = x(j) / avg_rate_userIndex_locationIndex( i,j ) + x(j) * cj(i,1) / F_j_V(j-2) + ...
                        cj(i,1) / fj(i,1) * ( x(j)^2 / Di_(j-2) + x(j) * ( total(i,j)) / Di_(j-2));
                        c4(j-2) = 1e-16 * cj(i,1) * (fj(i,1))^ 2 *  x(j) * ( x(j) + total(i,j)) / Di_(j-2);
                        c5 = c5 + c3(j-2);
                        c6 = c6 + c4(j-2);
                        c8(j) =  x(j) / avg_rate_userIndex_locationIndex(i,j) * power ;
                        c9 = c9+ c8(j);
                    end
                end
        end
        if sum(b(:,3)) / Di_(1) >=1
            c11 =   x(3) / avg_rate_userIndex_locationIndex(i,3) - t_stay(i,1);
        else
           c11 =  (cj(i,1) *  x(3) / ((1 - (total(i,3) + x(3)) / Di_(1)) *  F_j_V(1)) + x(3) / avg_rate_userIndex_locationIndex(i,3)) * (1 - (total(i,3) + x(3)) / Di_(1))  +  x(3) / avg_rate_userIndex_locationIndex(i,3) * ((total(i,3) + x(3)) / Di_(1)) - t_stay(i,1);
        end
%         if sum(b(:,4)) / Di_(2) >=1
%              c12 =   x(4) / avg_rate_userIndex_locationIndex(i,4) - t_stay(i,2);
%         else
%              c12 =  (cj(i,1) *  x(4) / ((1 - (total(i,4) + x(4)) / Di_(2)) *  F_j_V(2)) + x(4) / avg_rate_userIndex_locationIndex(i,4)) * (1 - (total(i,4) + x(4)) / Di_(2)) +  x(4) / avg_rate_userIndex_locationIndex(i,4) * ((total(i,4) + x(4)) / Di_(2)) - t_stay(i,2);
%         end
%         if sum(b(:,5)) / Di_(3) >=1
%             c13 =   x(5) / avg_rate_userIndex_locationIndex(i,5) - t_stay(i,3);
%         else
%             c13 =  (cj(i,1) *  x(5) / ((1 - (total(i,5) + x(5)) / Di_(3)) *  F_j_V(3)) +  x(5) / avg_rate_userIndex_locationIndex(i,5) ) * (1 - (total(i,5) + x(5)) / Di_(3))  +  x(5) / avg_rate_userIndex_locationIndex(i,5) * ((total(i,5) + x(5)) / Di_(3)) - t_stay(i,3);
%         end  
%          if sum(b(:,6)) / Di_(4) >=1
%             c14 =   x(6) / avg_rate_userIndex_locationIndex(i,6) - t_stay(i,4);
%         else
%             c14 =  (cj(i,1) *  x(6) / ((1 - (total(i,6) + x(6)) / Di_(4)) *  F_j_V(4)) +  x(6) / avg_rate_userIndex_locationIndex(i,6))* (1 - (total(i,6) + x(6)) / Di_(4))   +  x(6) / avg_rate_userIndex_locationIndex(i,6) * ((total(i,6) + x(6)) / Di_(4)) - t_stay(i,4);
%          end              
        c7 = c2+ c5 - T_j_tol(i);
        c10 = c9 + c6 - E_j_tol(i);
        c = [c7;c10;c11];
         %c = [c7;c10;c11;c12;c13;c14;c15;c16;c17;c18;c19;c20];
        ceq = [];
end