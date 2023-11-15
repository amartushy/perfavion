//
//  perfavionApp.swift
//  perfavion
//
//  Created by Adrian Martushev on 4/4/23.
//

import SwiftUI
import Combine
import UIKit


@main
struct perfavionApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(fm: FlightModel())
        }
    }
}


/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}
