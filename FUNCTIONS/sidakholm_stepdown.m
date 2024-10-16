% Method comes from: http://books.google.com/books?id=Ta5UzMajyu0C&pg=PA31
% Multiple Compairsons and Multiple Tests: Using the SAS System
% Chapter 2, Concepts and Basic Methods for Multiple Comparisons and Tests

function [pvalues_adjusted] = sidakholm_stepdown(pvalues)

% if min(diff(sort(pvalues))) == 0
%     fprintf('\nERROR: I cannot sort the p values!\n')
%     %keyboard
% end

n = length(pvalues);
pvalues_sorted = sort(pvalues);

for j = 1:n
    indicies(j) = (find(pvalues == pvalues_sorted(j)));
end


for i = 1:n
    if i < n
        pvalue_adjusted = 1-(1-pvalues_sorted(i))^(n-i+1);
    else
        pvalue_adjusted = pvalues_sorted(i);
    end
    
    if i > 1
        pvalues_adjusted_sorted(i) = max(pvalues_adjusted_sorted(i-1),pvalue_adjusted);
    else
        pvalues_adjusted_sorted(i) = pvalue_adjusted;
    end
end

for k = 1:n
    pvalues_adjusted(indicies(k)) = pvalues_adjusted_sorted(k);
end

end
