# CustomGraphView

A SwiftUI Package for graphing line charts. Inspiration from SwiftUICharts by willdale <https://github.com/willdale/SwiftUICharts>

# UI 
![](https://github.com/cbs9md/CustomGraphView/blob/main/Assets/CustomGraphViewPreviewGIF.gif)

# Tutorial

Initialize an array of CustomGraphDataPoint for every line you want to display on the graph
```
let dataPointsOne = [0, 5, 5, 7, 8].map { CustomGraphDataPoint(value: $0) }
let dataPointsTwo = [nil, 3, 7, 5, nil].map { CustomGraphDataPoint(value: $0) }
```

Wrap each array in a CustomGraphData, customizing the line color and legend title
```
let graphDataOne = CustomGraphData(points: dataPointsOne, color: .purple, legendTitle: "Purple")
let graphDataTwo = CustomGraphData(points: dataPointsTwo, color: .pink, legendTitle: "Pink")
```

Create a CustomGraphDataContainer from each CustomGraphData, specifying the max and min of the graph
```
let container = CustomGraphDataContainer(datas: [graphDataOne, graphDataTwo], max: 10, min: -10)
```

Customize your graph style
```
let style = CustomGraphViewStyle(
showLegend: true,
noDataMessage: "",
showSlider: true,
showYAxisLabels: true,
gridEdges: [],
showValuesOnGraph: false,
showValueOverSlider: false)
```

Define a Double as a source of truth corresponding to the index of the point selected by the slider on the graph.  If the index is out of range of the number of data points on the graph, the slider will not work.
```
@State var index = 0.0
```

Pass in all your defined variables to CustomGraphView
```
VStack {
    CustomGraphView(container: container,
                    index: $index,
                    style: style)
        .padding(40)
        .animation(.linear)
}
```
Money
