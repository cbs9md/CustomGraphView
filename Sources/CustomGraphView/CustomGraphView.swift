//
//  CustomGraphView.swift
//  UI Playground
//
//  Created by Chethan Shivaram on 3/6/23.
//

import SwiftUI

struct CustomGraphView: View {
    
    let container: CustomGraphDataContainer
    @Binding var index: Double
    let style: CustomGraphViewStyle
    @Namespace var animation
    
    init(container: CustomGraphDataContainer, index: Binding<Double>, style: CustomGraphViewStyle = .init()) {
        self.container = container
        _index = index
        self.style = style
    }
    
    var body: some View {
        VStack {
            switch container.numPoints {
            case .atLeastTwo:
                GeometryReader { geo in
                    ZStack {
                        if style.showYAxisLabels {
                            yAxis(height: geo.size.height)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        xAxis(width: geo.size.width)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .offset(y: 30)

                        grid(width: geo.size.width, height: geo.size.height)
                        ForEach(container.datas) { data in
                            line(width: geo.size.width,
                                 height: geo.size.height,
                                 points: data.points,
                                 maxY: container.max,
                                 minY: container.min,
                                 color: data.color)
                        }
                        
                        tapBoxes(width: geo.size.width)

                        
                        if style.showSlider {
                            slider(width: geo.size.width, height: geo.size.height)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                        if style.showValuesOnGraph {
                            ForEach(container.datas) { data in
                                valuesOnGraph(width: geo.size.width,
                                              height: geo.size.height,
                                              points: data.points,
                                              maxY: container.max,
                                              minY: container.min,
                                              color: data.color)
                            }
                        }
                        
                        if style.showValueOverSlider {
                            ForEach(container.datas) { data in
                                valueOverSlider(width: geo.size.width,
                                              height: geo.size.height,
                                              points: data.points,
                                              maxY: container.max,
                                              minY: container.min,
                                              color: data.color)
                            }
                        }
                        
                        
                    }
                }
                
                if style.showLegend {
                    legend
                        .offset(y: 30)
                }
            case .onlyOne:
                GeometryReader { geo in
                    ZStack {
                        if style.showYAxisLabels {
                            yAxis(height: geo.size.height)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        xAxis(width: geo.size.width)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .offset(y: 30)

                        grid(width: geo.size.width, height: geo.size.height)
                        ForEach(container.datas) { data in
                            line(width: geo.size.width,
                                 height: geo.size.height,
                                 points: data.points,
                                 maxY: container.max,
                                 minY: container.min,
                                 color: data.color)
                        }
                    }
                }
               
            case .none:
                Text(style.noDataMessage)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .font(.custom("Raleway-Regular", size: 13))
        .foregroundColor(.white)
    }
    
    func xAxis(width: CGFloat) -> some View {
        ZStack {
            ForEach(container.xAxisLabels.indices, id: \.self) { i in
                let numerator = CGFloat(i)
                let denominator = CGFloat(container.xAxisLabels.count-1)
                Text("\(container.xAxisLabels[i])")
                    .padding(5)
                    .rotationEffect(.degrees(45))
                    .offset(x: (numerator/denominator)*width-18)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func yAxis(height: CGFloat) -> some View {
        ZStack {
            ForEach(container.yAxisLabels.indices, id: \.self) { i in
                let numerator = CGFloat(i)
                let denominator = CGFloat(container.yAxisLabels.count-1)
                Text(container.yAxisLabels[i])
                    .padding(5)
                    .offset(y: (numerator/denominator)*height-24)
                    .foregroundColor(.gray)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    func grid(width: CGFloat, height: CGFloat) -> some View {
        Path { path in
            let rowHeight = height / CGFloat(5)
            let columnWidth = width / CGFloat(5)
            
            // Vertical grid lines
            if style.gridEdges.contains(.left) {
                path.move(to: CGPoint(x: columnWidth * CGFloat(0), y: 0))
                path.addLine(to: CGPoint(x: columnWidth * CGFloat(0), y: height))
            }
            
            for i in 1..<5 {
                path.move(to: CGPoint(x: columnWidth * CGFloat(i), y: 0))
                path.addLine(to: CGPoint(x: columnWidth * CGFloat(i), y: height))
            }
            
            if style.gridEdges.contains(.right) {
                path.move(to: CGPoint(x: columnWidth * CGFloat(6), y: 0))
                path.addLine(to: CGPoint(x: columnWidth * CGFloat(6), y: height))
            }
            
            // Horizontal grid lines
            if style.gridEdges.contains(.top) {
                path.move(to: CGPoint(x: 0, y: rowHeight * CGFloat(0)))
                path.addLine(to: CGPoint(x: width, y: rowHeight * CGFloat(0)))
            }
            
            for i in 1..<5 {
                path.move(to: CGPoint(x: 0, y: rowHeight * CGFloat(i)))
                path.addLine(to: CGPoint(x: width, y: rowHeight * CGFloat(i)))
            }
            
            if style.gridEdges.contains(.bottom) {
                path.move(to: CGPoint(x: 0, y: rowHeight * CGFloat(6)))
                path.addLine(to: CGPoint(x: width, y: rowHeight * CGFloat(6)))
            }
        }
        .stroke(Color.gray, style: StrokeStyle(lineWidth: 0.5, dash: [8], dashPhase: 0))
    }
    
    func line(width: CGFloat,
              height: CGFloat,
              points: [CustomGraphDataPoint],
              maxY: Double,
              minY: Double,
              color: Color) -> some View {
        ZStack(alignment: .topLeading) {
            Path { path in
                for index in points.indices {

                    let xPosition = width * CGFloat(index) / CGFloat(points.count - 1)

                    let yAxis = maxY - minY

                    if let value = points[index].value {
                        let yPosition = (1 - CGFloat((value - minY) / yAxis)) * height
                        
                        if path.isEmpty {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        }
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
            }
            .stroke(color, lineWidth: 1.5)
       
            Path { path in
                for index in points.indices {

                    let xPosition = width * CGFloat(index) / CGFloat(points.count - 1)

                    let yAxis = maxY - minY

                    if let value = points[index].value {
                        let yPosition = (1 - CGFloat((value - minY) / yAxis)) * height
                        
                        if path.isEmpty {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        }
                        let radius: CGFloat = 5
                        path.addEllipse(in: CGRect(x: xPosition-radius, y: yPosition-radius, width: radius*2, height: radius*2))
                        
                    }
                }
            }
            .stroke(color, lineWidth: 4.5)
        }
    }
    
    func slider(width: CGFloat, height: CGFloat) -> some View {
        DiscreteSlider(value: $index,
                       in: 0...Double(container.count-1),
                       onEditingChanged: { bool in
        },
                     track: {
                        Color.clear
                            .frame(width: width)
                     }, fill: {
                        Color.clear
                     }, thumb: {
                        Rectangle()
                             .foregroundColor(.white)
                             .frame(width: 2, height: height)
                             .frame(width: 45, height: height)
                             .contentShape(Rectangle())
                             .shadow(radius: 10)
                      },
                     thumbSize: CGSize(width: 0, height: 0),
                     height: height)
        
 
    }
    
    func valuesOnGraph(width: CGFloat,
                       height: CGFloat,
                       points: [CustomGraphDataPoint],
                       maxY: Double,
                       minY: Double,
                       color: Color) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(points.indices, id: \.self) { index in
                let point = points[index]
                if let value = point.value {
                    let xPosition = width * CGFloat(index) / CGFloat(points.count - 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((value - minY) / yAxis)) * height
                    Text(String(format: "%.1f", value))
                        .bold()
                        .scaleEffect(1.2)
                        .position(x: xPosition, y: yPosition-25)
                        .opacity(style.showValueOverSlider && style.showSlider && Int(self.index) == index ? 0.0 : 1.0)
                }
            }
        }
    }
    
    
    func valueOverSlider(width: CGFloat,
                       height: CGFloat,
                       points: [CustomGraphDataPoint],
                       maxY: Double,
                       minY: Double,
                       color: Color) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(points.indices, id: \.self) { index in
                let point = points[index]
                if let value = point.value {
                    let xPosition = width * CGFloat(index) / CGFloat(points.count - 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((value - minY) / yAxis)) * height
                    
                    if Double(index) == self.index {
                        Text(String(format: "%.1f", value))
                            .bold()
                            .padding(10)
                            .background(Color("BraveDullBlue").opacity(0.6))
                            .clipShape(Circle())
                            .overlay(Circle().stroke().foregroundColor(color))
                            .scaleEffect(1.5)
                            .position(x: xPosition, y: yPosition-45)
                    }
                    
                }
            }
        }
    }
    
    func tapBoxes(width: CGFloat) -> some View {
        let tapWidth = width/CGFloat(container.count-1)
        return Rectangle()
            .opacity(0.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                HStack(spacing: 0) {
                    ForEach(0..<container.count) { i in
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.index = Double(i)
                            }
                    }
                }
                    .frame(width: width + tapWidth)
            )
        
    }
    
    var legend: some View {
        HStack(spacing: 25) {
            ForEach(container.datas) { data in
                HStack(spacing: 10) {
                    Rectangle()
                        .frame(width: 35, height: 3)
                        .foregroundColor(data.color)
                    Text(data.legendTitle)
                        .font(.custom("Raleway-Regular", size: 15))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

class CustomGraphViewModel: ObservableObject {
    @Published var index: Double = 2
}

struct CustomGraphViewPreview: View {
    @State var index = 0.0
    var body: some View {
        CustomGraphView(container: CustomGraphDataContainer.dummyData(), index: $index, style: CustomGraphViewStyle(showLegend: true,
                                                                                                                            noDataMessage: "", showSlider: true, showYAxisLabels: true, gridEdges: [],
                                                                                                                            showValuesOnGraph: false, showValueOverSlider: false))
            .padding(40)
            .background(Color("BraveDarkBlue").ignoresSafeArea())
            .animation(.linear)
    }
}

struct CustomGraphView_Previews: PreviewProvider {
    static var previews: some View {
        CustomGraphViewPreview()
    }
}

extension CustomGraphDataContainer {
    static func dummyData() -> CustomGraphDataContainer {
        return CustomGraphDataContainer(datas: [CustomGraphData(points: [0].map { CustomGraphDataPoint(value: $0) }, color: .purple, legendTitle: "Left" ), CustomGraphData(points: [nil].map { CustomGraphDataPoint(value: $0) }, color: .pink, legendTitle: "Right")], max: 5, min: -5)
    }
}
