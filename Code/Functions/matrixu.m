function Labels = matrixu(classes,totalW,bmu)
Labels = cell(totalW,1);% for each vector in sTo, make a list of all new labels
for d=1:length(bmu)
    m = bmu(d);t = m; f = d;Labels{t}{length(Labels{t})+1} = classes{f,1};   
end
for i=1:length(Labels)% calculate frequency of each label in each node
    new_labels = {}; new_freq = [];
    for j=1:length(Labels{i})
        if isempty(Labels{i}{j}) % ignore
        elseif ~any(strcmp(Labels{i}{j},new_labels)) % a new one!
            k = length(new_labels) + 1;new_labels{k} = Labels{i}{j};%#ok
            new_freq(k) = sum(strcmp(new_labels{k},Labels{i}));%#ok
        else % an old one, ignore
        end
    end
    if ~isempty(new_labels)% based on frequency, select label(s) to be added
        [~, order] = sort(1./(1+new_freq));% sort labels according to frequency
        new_labels = new_labels(order);Labels{i} = new_labels{1};
    end
end



