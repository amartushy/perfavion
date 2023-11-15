//
//  ChartView.swift
//  perfavion
//
//  Created by Adrian Martushev on 4/7/23.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    var width : Double
    var height : Double
    
    @ObservedObject var fm: FlightModel

    var data : [ChartDataEntry] = [
        ChartDataEntry(distance: 2.13, mass: 675),
        ChartDataEntry(distance: 2.13, mass: 748),
        ChartDataEntry(distance: 2.2, mass: 997),
        ChartDataEntry(distance: 2.31, mass: 1088),
        ChartDataEntry(distance: 2.41, mass: 1088),
        ChartDataEntry(distance: 2.41, mass: 675)
    ]

    struct ChartDataEntry : Identifiable {
        let id = UUID()
        var distance: Double
        var mass: Double

        init(distance : Double, mass : Double) {
            self.distance = distance
            self.mass = mass
        }
    }

    var body: some View {
        VStack {
            Chart(data) {
                LineMark(
                    x: .value("Distance", $0.distance),
                    y: .value("Mass", $0.mass)
                )
                .foregroundStyle(Color(fm.calcmaxCGMass()))
                
                PointMark(
                    x: .value("Distance", fm.take_off_CG),
                    y: .value("Distance", fm.take_off_mass)
                )
                .foregroundStyle(.green)
                
                PointMark(
                    x: .value("Distance", fm.landing_CG),
                    y: .value("Distance", fm.landing_mass)
                )
                .foregroundStyle(.orange)

                
                PointMark(
                    x: .value("Distance", fm.zero_fuel_CG),
                    y: .value("Distance", fm.zero_fuel_mass)
                )
                .foregroundStyle(.white)

                
            }
            .chartYScale(domain: [675, 1100] )
            .chartXScale(domain : [2.10, 2.45] )
//            .chartXAxisLabel(position: .bottom, alignment: .center) {
//                Text("Distance au point de référence (m)")
//                    .foregroundColor(.white)
//            }
//            .chartYAxisLabel(position: .leading, alignment: .center) {
//                Text("Distance au point de référence (m)")
//                    .foregroundColor(.white)
//
//            }
            .chartXAxis {
                AxisMarks(
                    preset : .aligned,
                    position : .top,
                    values: .automatic(desiredCount: 4)
                ) { _ in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.white)
                    
                    AxisTick(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.white)
                    
                    AxisValueLabel()
                        .foregroundStyle(Color.white)
                }
                
            }
            .chartYAxis {
                AxisMarks(
                    preset : .aligned,
                    position : .leading,
                    values: .automatic(desiredCount: 5)
                ) { _ in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.white)
                      
                    AxisTick(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.white)
                      
                    AxisValueLabel()
                        .foregroundStyle(Color.white)
                }
            }
            .padding()

        }
        .frame(width: self.width, height: self.height)
        .background(Color("backgroundGray"))
        .cornerRadius(10)
        .padding()
    }
}




struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(width: 400.0, height : 300.0, fm : FlightModel())
    }
}
