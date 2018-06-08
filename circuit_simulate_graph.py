#!/usr/bin/env python

import fileinput
import plotly
import plotly.graph_objs as go

names = []
count = 0

for line in fileinput.input():
    if not count:
        names = line.split()
        voltage, currents = [[] for i in range(len(names))]
        currents = [[] for i in range(len(names))]
    elif count > 1:
        line = line.split()
        for i in range(0, len(names)):
            voltage[i].append(line[i*2])
            currents[i].append(line[(i*2)+1])
    count += 1
        
traces = []
for i in range(len(names)):
    traces.append(go.Scatter(
        x = range(0, count-2),
        y = voltage[i],
        mode = 'lines+markers',
        name = names[i],
        line = dict(color = ('rgb(205, 12, 24)'))
    ))
    traces.append(go.Scatter(
        x = range(0, count-2),
        y = currents[i],
        mode = 'lines+markers',
        name = names[i],
        line = dict(color = ('rgb(22, 96, 167)'))
    ))
    
fig = dict(data=traces)
plotly.offline.plot(fig, filename='temp_plot.html')
        
