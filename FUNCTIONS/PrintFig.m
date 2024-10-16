function PrintFig(Handle, FigSaveName, PrintPropertyStruct)
for n = 1:numel(PrintPropertyStruct)
    if strcmp(PrintPropertyStruct(n).FileType,'jpeg') || strcmp(PrintPropertyStruct(n).FileType,'jpg')
        %% Save as .jpg
        Handle.PaperUnits = PrintPropertyStruct(n).PaperUnits; Handle.PaperPosition = PrintPropertyStruct(n).PaperPosition;
        print(Handle, '-djpeg', sprintf('-r%d', PrintPropertyStruct(n).Resolution), strrep(FigSaveName,'.fig','.jpg'));

    elseif  strcmpi(PrintPropertyStruct(n).FileType,'vector')
        %% Save as vector
        Handle.PaperUnits = PrintPropertyStruct(n).PaperUnits; Handle.PaperPosition = PrintPropertyStruct(n).PaperPosition;
        print(Handle, '-dmeta', strrep(FigSaveName,'.fig','.emf')); % saves in vector format which is useful for publications
    end
end