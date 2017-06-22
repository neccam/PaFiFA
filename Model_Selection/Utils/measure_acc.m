function [ acc ] = measure_acc( pred, labels )
    acc = sum(pred == labels)/numel(labels);
    if isnan(acc)
        acc = 0;
    end
end

