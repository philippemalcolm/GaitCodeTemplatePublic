function PcntStrideSubCondGroup2 = MergeConditions(PcntStrideSubCondGroup, OrigCondS, NewCondS)
warning(['We made a major update to the MergeConditions() function.' ...
    'It should now be be run on the PCNTStrideSubCondGroup BEFORE all the scalars are calculated and StrideSubCondGroup file is generated.' ...
    'This is part of a 2 major simplifications to prevent that the scripts and filenames need to be adjusted depending on whether the project uses groups merging of conditions. ' ...
    'See Github page for the suggested sequence in the MAIN script. Old projects may need to manually download a version of the function before 2024-09-19.'])

VarNames = fieldnames(PcntStrideSubCondGroup);

for n = 1:numel(VarNames)

    OrigVar = PcntStrideSubCondGroup.(VarNames{n});
    OrigNstrides = size(OrigVar,2);
    OrigNsubs = size(OrigVar,3);
    % OrigNconds = size(OrigVar,4);
    OrigNgroups = size(OrigVar,5);

    NewNstrides = OrigNstrides * size(OrigCondS,2);
    NewNsubs = OrigNsubs;
    NewNconds = size(NewCondS,1);
    NewNgroups = OrigNgroups;

    PcntStrideSubCondGroup2.(VarNames{n}) = nan(100,NewNstrides,NewNsubs,NewNconds,NewNgroups);
    for p = 1:100
        for c = 1:size(OrigCondS,1)
            for g = 1:NewNgroups
                for s = 1:NewNsubs

                    OrigCond = OrigCondS(c,~isnan(OrigCondS(c,:)));
                    NewCond = NewCondS(c);

                    NewColumn = OrigVar(p,:,s,OrigCond,g);
                    PcntStrideSubCondGroup2.(VarNames{n})(p, 1:OrigNstrides*length(OrigCond),s,NewCond,g) = NewColumn(:);
                end
            end
        end
    end
end

