//
//  FlightModel.swift
//  perfavion
//
//  Created by Adrian Martushev on 4/6/23.
//

import Foundation



class FlightModel: ObservableObject {
    @Published var c4Str = ""
    @Published var c5Str = ""
    @Published var c6Str = ""
    @Published var c7Str = ""
    @Published var c8Str = ""
    @Published var c9Str = ""
    @Published var c10Str = ""
    @Published var c11Str = ""
    @Published var c12Str = ""
    @Published var c13Str = ""
    @Published var c14Str = ""
    
    @Published var c4 = 0.0
    @Published var c5 = 0.0
    @Published var c6 = 0.0
    @Published var c7 = 0.0
    @Published var c8 = 0.0
    @Published var c9 = 0.0
    @Published var c10 = 0.0
    @Published var c11 = 0.0
    @Published var c12 = 0.0
    @Published var c13 = 0.0
    @Published var c14 = 0.0
    
    @Published var runwayCondition = ""
    @Published var p15 = 1.0
    @Published var runwaySurface = ""
    @Published var p18 = 1.0
    
    @Published var m22 = 0.0
    
    @Published var b16 = 0.0
    @Published var b20 = 0.0
    
    //Calculated values
    @Published var take_off_roll = 0.0
    @Published var take_off_distance = 0.0
    @Published var landing_roll = 0.0
    @Published var landing_distance = 0.0
    
    @Published var take_off_mass = 0.0
    @Published var landing_mass = 0.0
    @Published var zero_fuel_mass = 0.0

    @Published var take_off_CG = 0.0
    @Published var landing_CG = 0.0
    @Published var zero_fuel_CG = 0.0
    
    func calculateDensityAltitude() {
        let m22 = (c11 + ((1013 - c12) * 27.9)) + 120 * (c13 - (15 - (((c11 + ((1013 - c12) * 27.9)) * 2) / 1000)))
        self.m22 = m22
    }
    
    func calculateTakeOffDistances() {
        self.take_off_roll = 221.21 * exp(m22 * pow(10, -4)) * p15 * p18
        self.take_off_distance = 490.44 * exp(m22 * pow(10, -4)) * p15 * p18
    }
    
    func calculateLandingDistance() {
        landing_roll = 193.62 * exp(m22 * 3 * pow(10, -5))
        landing_distance = 359.72 * exp(m22 * 2 * pow(10, -5))
    }
    
    func calculateMasses() {
        take_off_mass = 674.6 + c4 + c5 + c6 + c7 + c8 + c9 * 0.721
        landing_mass = take_off_mass - c10 * 0.721
        zero_fuel_mass = 674.6 + c4 + c5 + c6 + c7 + c8
    }
    
    func calculateCenterOfGravities() {
        let n3 = 674.6 * 2.3
        let n4 = c4 * 2.17
        let n5 = c5 * 2.17
        let n6 = c6 * 2.99
        let n7 = c7 * 2.99
        let n8 = c8 * 3.63
        let n9 = c9 * 0.721 * 2.41
        let n10 = c10 * 0.721 * 2.41

        take_off_CG = (n3 + n4 + n5 + n6 + n7 + n8 + n9) / take_off_mass
        landing_CG = (n3 + n4 + n5 + n6 + n7 + n8 + n9 - n10) / landing_mass
        zero_fuel_CG = (n3 + n4 + n5 + n6 + n7 + n8) / zero_fuel_mass
    }
    
    func calculateQOF() {
            
        let max_tank_fuel = 180.0
        let max_TOW = 1088.0 //max take off weight
        let Deltafuel = max_tank_fuel - c9
        let Deltamass = max_TOW - take_off_mass
        let DeltamassL = Deltamass/0.721
        let b16 = min(Deltafuel, DeltamassL)
        
        
        self.b20 = abs(b16)
    }
    
    func calculateAllValues() {
        //initialize values
        self.c4 = Double(self.c4Str) ?? 0.0
        self.c5 = Double(self.c5Str) ?? 0.0
        self.c6 = Double(self.c6Str) ?? 0.0
        self.c7 = Double(self.c7Str) ?? 0.0
        self.c8 = Double(self.c8Str) ?? 0.0
        self.c9 = Double(self.c9Str) ?? 0.0
        self.c10 = Double(self.c10Str) ?? 0.0
        self.c11 = Double(self.c11Str) ?? 0.0
        self.c12 = Double(self.c12Str) ?? 0.0
        self.c13 = Double(self.c13Str) ?? 0.0
        self.c14 = Double(self.c14Str) ?? 0.0

        
        self.calculateDensityAltitude()
        self.calculateLandingDistance()
        self.calculateTakeOffDistances()
        self.calculateMasses()
        self.calculateCenterOfGravities()
        self.calculateQOF()
    }
    
    
    func calcmaxCGMass() -> String {
        
        var maxCG = 0.0
        
        if 2.31...2.41 ~= take_off_CG {
            maxCG = 1088
            
        } else if 2.20...2.31 ~= take_off_CG {
            maxCG = 827.273 * take_off_CG - 823.0
            
        } else if 2.13...2.20 ~= take_off_CG {
            maxCG = 3557.14 * take_off_CG - 6828.0

        }
        
        let graphColor = maxCG < take_off_mass ? "red" : "limeGreen"
                
        return graphColor
    }
}
