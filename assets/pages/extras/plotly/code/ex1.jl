# This file was generated, do not modify it. # hide
z =  [10     10.625  12.5  15.625  20
     5.625  6.25    8.125 11.25   15.625
     2.5    3.125   5.    8.125   12.5
     0.625  1.25    3.125 6.25    10.625
     0      0.625   2.5   5.625   10]

data   = PlotlyJS.contour(; z=z)
layout = PlotlyJS.Layout(; title="Basic Contour Plot")
plt    = PlotlyJS.plot(data, layout)

fdplotly(plt) # hide
