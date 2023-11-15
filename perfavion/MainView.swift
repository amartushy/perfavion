//
//  ContentView.swift
//  perfavion
//
//  Created by Adrian Martushev on 4/4/23.
//

import SwiftUI
import UIKit

struct MainView: View {
    
    @ObservedObject var fm: FlightModel
    
    @Environment(\.horizontalSizeClass) var orientation

    @State private var isPortrait = false
    
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing : 0) {
                HeaderMainView()
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in

                        if UIDevice.current.orientation.rawValue <= 4 { // This will run code only on Portrait and Landscape changes
                            guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                            self.isPortrait = scene.interfaceOrientation.isPortrait
                        }
                    }

                HStack(spacing : 0) {
                    LeftMainView(fm : fm)
                        .frame(maxWidth: isPortrait ? geometry.size.width / 2.6 : geometry.size.width / 4)

                    
                    //RIGHT
                    VStack {
                        Text("RESULTATS")
                            .font(.custom("Arial Bold", size: 18))
                            .foregroundColor(Color("textGray"))
                            .padding(0)
                            .offset(y : 5)
                        
                        VStack {
                            
                            HStack(spacing: 0 ) {
                                
                                if(fm.b16 > 0) {
                                    Text("Il faut enlever \(String(format: "%.0f", round(fm.b20))) L")
                                        .font(.custom("Arial Bold", size: 16))
                                        .foregroundColor(Color("red"))
                                        .padding(5)
                                } else {
                                    Text("Ajout possible de \(String(format: "%.0f", round(fm.b20))) L")
                                        .font(.custom("Arial Bold", size: 16))
                                        .foregroundColor(Color("limeGreen"))
                                        .padding(5)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color("backgroundGray"))
                            .cornerRadius(10)
                            .padding()

                            ScrollView(.vertical, showsIndicators: false) {
                                
                                if(isPortrait) {

                                    VStack{
                                        DistanceTableView(fm : fm)
                                        ChartView(width: 400.0, height : 300.0, fm : fm)
                                        MassTableView(fm : fm)
                                    }
                                } else {
                                    HStack {
                                        VStack {
                                            Spacer()
                                            ChartView(width : geometry.size.width / 3.3, height: 500, fm : fm)
                                            Spacer()
                                        }
                                        
                                        VStack {
                                            DistanceTableView(fm : fm)
                                            MassTableView(fm : fm)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth : .infinity)
                        .background(Color("darkGray"))
                        .border(width: 5, edges: [.leading], color: .black)
                    }
                    .frame(minWidth: geometry.size.width / 3)

                }
                .frame(maxWidth : geometry.size.width)
                
            }
            .onTapGesture {
                hideKeyboard()
                fm.calculateAllValues()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}


struct DistanceTableView : View {
    
    @ObservedObject var fm: FlightModel

    
    func tableRowView(leftText : String, rightVal : Double) -> some View {
        HStack {
            Text(leftText)
                .font(.custom("Arial Bold", size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 130)
            
            
            Divider()
                .overlay(.white)
            
            HStack {
                Spacer()
                Text("\(String(format: "%.0f", round(rightVal)))")
                    .font(.custom("Arial Bold", size: 18))
                    .foregroundColor(.white)
                    .padding(.trailing)

            }
            .frame(width: 260)
        }
    }
    
    
    var body: some View {
        VStack(spacing : 0) {
            
            HStack {
                Text("")
                    .font(.custom("Arial Bold", size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 130)
                Divider()
                    .overlay(.white)
                
                HStack {
                    Text("Distances d'exploitation")
                        .font(.custom("Arial Bold", size: 16))
                        .foregroundColor(.white)
                        
                    Text("m")
                        .font(.custom("Arial Bold", size: 14 ))
                        .foregroundColor(.white)
                        .baselineOffset(-10.0)

                }
                .padding(.trailing)

                    .frame(width: 260)

            }
            .background(Color("tableGray"))
            Divider()
                .overlay(.white)
            
            tableRowView(leftText: "Distance deroulement au décollage", rightVal: fm.take_off_roll)
            Divider()
                .overlay(.white)
            
            tableRowView(leftText: "Distance de décollage (15 m)", rightVal: fm.take_off_distance)
            
            Divider()
                .overlay(.white)
            
            tableRowView(leftText: "Distance de roulement à l'atterrissage", rightVal: fm.landing_roll)
            
            Divider()
                .overlay(.white)
            tableRowView(leftText: "Distance d'atterrissage (15m)", rightVal: fm.landing_distance)
        }
        .frame(width: 400, height: 250)
        .background(Color("backgroundGray"))
        .cornerRadius(10)
        .padding()
    }
}



struct MassTableView : View {
    
    @ObservedObject var fm: FlightModel

    func tableRowView(leftText : String, massVal: Double,  CGVal : Double) -> some View {
        HStack {
            Text(leftText)
                .font(.custom("Arial Bold", size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 130)
            
            Divider()
                .overlay(.white)
            HStack {
                Spacer()
                Text("\(String(format: "%.0f", round(massVal)))")
                    .font(.custom("Arial Bold", size: 18))
                    .foregroundColor(.white)
                    .padding(.trailing)
            }
            .frame(width: 120)
            
            Divider()
                .overlay(.white)
            
            HStack {
                Spacer()
                Text("\(String(format: "%.2f", CGVal))")
                    .font(.custom("Arial Bold", size: 18))
                    .foregroundColor(.white)
                    .padding(.trailing)

            }
            .frame(width: 130)
        }
    }
    
    
    var body: some View {
        VStack(spacing : 0) {
            
            HStack {
                Text("")
                    .font(.custom("Arial Bold", size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 140)
                Divider()
                    .overlay(.white)
                
                HStack {
                    Text("Masse")
                        .font(.custom("Arial Bold", size: 16))
                        .foregroundColor(.white)
                        
                    Text("KG")
                        .font(.custom("Arial Bold", size: 14 ))
                        .foregroundColor(.white)
                        .baselineOffset(-10.0)

                }
                .padding(.trailing)
                .frame(width: 120)
                
                Divider()
                    .overlay(.white)
                
                HStack {
                    Text("CG")
                        .font(.custom("Arial Bold", size: 16))
                        .foregroundColor(.white)
                        
                    Text("M")
                        .font(.custom("Arial Bold", size: 14 ))
                        .foregroundColor(.white)
                        .baselineOffset(-10.0)

                }
                .padding(.trailing)
                .frame(width: 140)

            }
            .background(Color("tableGray"))
            Divider()
                .overlay(.white)
            
            tableRowView(leftText: "Masse sans carburant", massVal: fm.zero_fuel_mass, CGVal: fm.zero_fuel_CG)
            Divider()
                .overlay(.white)
            
            tableRowView(leftText: "Masse au décollage", massVal: fm.take_off_mass, CGVal: fm.take_off_CG)
            
            Divider()
                .overlay(.white)
            
            tableRowView(leftText: "Masse à l'atterrissage", massVal: fm.landing_mass, CGVal: fm.landing_CG)
        }
        .frame(width: 400, height: 200)
        .background(Color("backgroundGray"))
        .cornerRadius(10)
        .padding()
    }
}


struct LeftMainView : View {
    
    @ObservedObject var fm: FlightModel

    @State var showSurface = false
    @State var showRevetement = false
    
    var body : some View {
        
        GeometryReader { geometry in
            VStack(alignment: .leading) {

                VStack {
                    HStack {
                        Text("MASSES")
                            .font(.custom("Arial Bold", size: 14))
                            .foregroundColor(.white)
                            .offset(y : 5)
                        
                        Spacer()
                    }
                    
                    VStack {
                        VStack {
                            HStack {
                                Text("PILOTE")
                                    .font(.custom("Arial Bold", size: 16))
                                    .foregroundColor(.white)
                                Text("KG")
                                    .font(.custom("Arial Bold", size: 14))
                                    .foregroundColor(Color("textLightGray"))
                                
                                Spacer()

//                                TextField("0.0", value: $fm.c4, format: .number, prompt: Text("Enter"))
                                TextField(text : $fm.c4Str, prompt: Text("0").foregroundColor(.gray)) {
                                        Text("")
                                    }
                                    .onSubmit {
                                        fm.c4 = Double(fm.c4Str) ?? 0.0
                                        print(fm.c4)
                                        fm.calculateAllValues()
                                    }
                                    .font(.custom("Arial Bold", size: 24))
                                    .frame(minWidth: 10)
                                    .frame(maxWidth:  150)
                                    .foregroundColor( $fm.c4.wrappedValue == 0.0 ? .gray : .blue)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                            }
                            
//                            inputField(text: "PILOTE", units: "KG", fmVal : $fm.c4)
                            inputField(text: "PAX AVANT", units: "KG", fmStr : $fm.c5Str, fmVal : $fm.c5)
                            inputField(text: "PAX ARR 1", units: "KG", fmStr : $fm.c6Str, fmVal : $fm.c6)
                            inputField(text: "PAX ARR 2", units: "KG", fmStr : $fm.c7Str, fmVal : $fm.c7)
                            inputField(text: "BAGAGES", units: "KG", fmStr : $fm.c8Str, fmVal : $fm.c8)
                        }
                        .padding(8)
                    }
                    .background(Color("backgroundGray"))
                    .cornerRadius(10)
                    .padding(.bottom)
                    
                    HStack {
                        Text("CARBURANT")
                            .font(.custom("Arial Bold", size: 14))
                            .foregroundColor(.white)
                            .offset(y : 5)
                        
                        Spacer()
                    }

                    
                    VStack {
                        VStack {
                            inputField(text: "AU DECOLLAGE", units: "L", fmStr : $fm.c9Str, fmVal : $fm.c9)
                            inputField(text: "DELESTAGE", units: "L", fmStr : $fm.c10Str, fmVal : $fm.c10)
                            
                        }
                        .padding(8)
                    }
                    .background(Color("backgroundGray"))
                    .cornerRadius(10)
                    .padding(.bottom)
                    
                    HStack {
                        Text("DONNEES AERODROME")
                            .font(.custom("Arial Bold", size: 14))
                            .foregroundColor(.white)
                            .offset(y : 5)
                        
                        Spacer()
                    }

                    
                    VStack {
                        VStack {
                            inputField(text: "ALTITUDE", units: "ft", fmStr : $fm.c11Str, fmVal : $fm.c11)
                            inputField(text: "QNH", units: "hPA", fmStr : $fm.c12Str, fmVal : $fm.c12)
                            inputField(text: "TEMP", units: "C", fmStr : $fm.c13Str, fmVal : $fm.c13)
                            
                            inputChoice(text: "SURFACE", fmStr: fm.runwaySurface)
                                .alert("Select surface condition from the list", isPresented: $showSurface) {
                                    Button("SECHE", action: {
                                        fm.p15 = 1.0
                                        fm.runwaySurface = "SECHE"
                                        fm.calculateAllValues()
                                    })
                                    Button("MOUILLEE", action: {
                                        fm.p15 = 1.15
                                        fm.runwaySurface = "MOUILLEE"
                                        fm.calculateAllValues()
                                    })
                                    Button("Cancel", role: .cancel) { }
                                }
                            inputChoice(text: "REVETEMENT", fmStr: fm.runwayCondition)
                                .alert("Select runway surface from the list", isPresented: $showRevetement) {
                                    Button("REVETUE", action: {
                                        fm.p18 = 1.0
                                        fm.runwayCondition = "REVETUE"
                                        fm.calculateAllValues()
                                    })
                                    Button("HERBE", action: {
                                        fm.p18 = 1.15
                                        fm.runwayCondition = "HERBE"
                                        fm.calculateAllValues()
                                    })
                                    Button("Cancel", role: .cancel) { }
                                }
                        }
                        .padding(8)
                    }
                    .background(Color("backgroundGray"))
                    .cornerRadius(10)
                    .padding(.bottom)
                    
                    
                    
                    Spacer()
                    
//                    Button {
//                        fm.calculateAllValues()
//                    } label: {
//                        Text("CALCULER")
//                            .font(.custom("Arial Bold", size: 18))
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    .frame(maxWidth: .infinity)
//                    .background(Color("backgroundGray"))
//                    .cornerRadius(10)

                    
                    Spacer()
                    
                }
                .padding(5)

            }
            .background(Color("darkGray"))
        }
    }
    
    
    func inputField(text : String, units : String, fmStr : Binding<String>, fmVal : Binding<Double>) -> some View {
        HStack {
            Text(text)
                .font(.custom("Arial Bold", size: 16))
                .foregroundColor(.white)
            Text(units)
                .font(.custom("Arial Bold", size: 14))
                .foregroundColor(Color("textLightGray"))
            
            Spacer()
            TextField(text : fmStr, prompt: Text("0").foregroundColor(.gray)) {
                    Text("")
                }
                .onSubmit {
                    
                    fm.calculateAllValues()
                }
                .font(.custom("Arial Bold", size: 24))
                .frame(minWidth: 10)
                .frame(maxWidth:  150)
                .foregroundColor( fmVal.wrappedValue == 0.0 ? .gray : .blue)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
            
//            TextField("0.0", value: fmVal, format: .number)
//                .font(.custom("Arial Bold", size: 24))
//                .frame(minWidth: 10)
//                .frame(maxWidth:  150)
//                .onSubmit {
//                    fm.calculateAllValues()
//                }
//                .foregroundColor( fmVal.wrappedValue == 0.0 ? .gray : .blue)
//                .multilineTextAlignment(.trailing)
//                .keyboardType(.decimalPad)
        }
    }
    
    func inputChoice(text : String, fmStr : String) -> some View {
        HStack {
            Text(text)
                .font(.custom("Arial Bold", size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(fmStr)
                .font(.custom("Arial Bold", size: 14))
                .foregroundColor( fmStr == "" ? .gray : .blue)

            Button {
                if (text == "SURFACE") {
                    showSurface = true
                } else if (text == "REVETEMENT") {
                    showRevetement = true
                }
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.yellow)
                
            }
            .padding(.vertical, 1)
        }
    }
}




#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
    }
}
#endif


struct HeaderMainView : View {
    
    var body : some View {
        
        VStack {
            Text("perfavion.net")
                .font(.custom("Arial Bold", size: 12))
                .foregroundColor(Color("textGray"))
            
            HStack {
                Text("CALCUL DE PERFORMANCES | F-HBCH | PA28 Cherokee")
                    .font(.custom("Arial Bold", size: 14))
                    .foregroundColor(Color("textGray"))

                Spacer()
            }
        }
        .padding()
        .background(Color("topGray"))
    }
}






//Custom Border
extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}



struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(fm : FlightModel())
    }
}
