Use this CONFIG folder store files with matlab struct variables that contain lists of properties for things like line plots. Using this with a properties struct drastically shortens code. 

E.g. After a struct variable has been defined like this you can simply run plot(X, CondPlotStyles)

CondPlotStyles(1)
    DisplayName = 'Condition1'
    Color = 'b'
    LineStyle = '-'
    LineWidth = 1
    Marker = '.'
    MarkerFaceColor = 'b'
    MarkerSize = 10
    FontSize = 10
