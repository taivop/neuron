function [f] = fig_FinalWeightsVsDifferentInitialWeights(initialWeights, finalWeights)

f = figure();
hold on;

colours = ['y','m','c','r','g','b','w','k'];

for i=1:size(finalWeights,1)
    colourIndex = round(mod(i,size(colours,2)) + 1);
    fprintf('i=%d, index=%d\n',i,colourIndex);
    plot(ones(1,120) .* initialWeights(i), colours(colourIndex));
    plot(finalWeights(i,:),colours(colourIndex));
end;

hold off;