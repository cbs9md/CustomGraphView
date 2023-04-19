//
//  File.swift
//  
//
//  Created by Chethan Shivaram on 4/19/23.
//

import Foundation

enum CustomGraphEdges {
    case left, right, top, bottom
}

struct CustomGraphDataContainer {
    internal init(datas: [CustomGraphData], max: Double, min: Double) {
        self.datas = datas
        self.max = max
        self.min = min
        let count = Double(datas.first?.points.count ?? 0)
        let step = (max-min)/count
        let rangeOfFloats = stride(from: min, through: max, by: step)
        self.yAxisLabels = rangeOfFloats.map { String(format: "%.1f", $0) }.reversed()
        self.xAxisLabels = datas.first?.points.map { $0.xAxisLabel } ?? []
        if let first = datas.first {
            self.indices = Array(first.points.indices)
        } else {
            self.indices = []
        }
        if count > 1 {
            self.numPoints = .atLeastTwo
        } else if count > 0 {
            self.numPoints = .onlyOne
        } else {
            self.numPoints = .none
        }
        self.count = Int(count)
    }
    
    let datas: [CustomGraphData]
    let max: Double
    let min: Double
    var yAxisLabels: [String]
    var xAxisLabels: [String]
    var indices: [Int]
    func getPoint(index: Int) -> CustomGraphDataPoint {
        
        if let first = datas.first, first.points.indices.contains(index) {
            return first.points[index]
        }
        // empty point
        return CustomGraphDataPoint(value: nil)
    }
    
    struct PointGroup {
        
    }
    
    var numPoints: NumberOfPoints
    var count: Int
    
    enum NumberOfPoints {
        case atLeastTwo, onlyOne, none
    }
}
        
struct CustomGraphData: Identifiable {
    let id = UUID()
    let points: [CustomGraphDataPoint]
    let color: Color
    let legendTitle: String
}

struct CustomGraphDataPoint: Identifiable {
    let id = UUID()
    let value: Double?
    let xAxisLabel: String
    let description: String
    
    init(value: Double?, xAxisLabel: String = "Mar", description: String = "") {
        self.value = value
        self.xAxisLabel = xAxisLabel
        self.description = description
    }
}
