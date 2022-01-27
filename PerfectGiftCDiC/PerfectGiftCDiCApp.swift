//
//  PerfectGiftCDiCApp.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI

@main
struct PerfectGiftCDiCApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)        }
    }
}
