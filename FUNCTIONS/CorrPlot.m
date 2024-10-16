function [pValue, rSquared, p2] = CorrPlot(X, Y)
[X,Y]=RemoveNans(X(:),Y(:));
lm = stepwiselm(table(X(:),Y(:)), "linear");
rSquared = lm.Rsquared.Ordinary;
pValue = lm.ModelFitVsNullModel.Pvalue;

if pValue <= 0.1
    Xfit = reshape(linspace(min(X(:)),max(X(:)),100),[],1);
    Yfit = predict(lm,Xfit);
    p2 = plot(Xfit,Yfit,'k--','handlevisibility', 'off');
end
title(['Rsquared:',num2str(rSquared,2), ', pValue: ',num2str(pValue,3)])
