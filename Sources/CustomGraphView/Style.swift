//
//  File.swift
//  
//
//  Created by Chethan Shivaram on 4/19/23.
//

import Foundation


struct CustomGraphViewStyle {
    
init(showLegend: Bool = true,
     noDataMessage: String = "No Data",
     showSlider: Bool = true,
     showYAxisLabels: Bool = true,
     gridEdges: [CustomGraphEdges] = [.left, .right, .top, .bottom],
     showValuesOnGraph: Bool = false,
     showValueOverSlider: Bool = false) {
    self.showLegend = showLegend
    self.noDataMessage = noDataMessage
    self.showSlider = showSlider
    self.showYAxisLabels = showYAxisLabels
    self.gridEdges = gridEdges
    self.showValuesOnGraph = showValuesOnGraph
    self.showValueOverSlider = showSlider ? showValueOverSlider : false
}
    
let showLegend: Bool
let noDataMessage: String
let showSlider: Bool
let showYAxisLabels: Bool
let gridEdges: [CustomGraphEdges]
let showValuesOnGraph: Bool
let showValueOverSlider: Bool
}
