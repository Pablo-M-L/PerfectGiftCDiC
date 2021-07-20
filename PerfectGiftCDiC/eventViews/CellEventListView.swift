//
//  CellEventListView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 8/7/21.
//

import SwiftUI

struct CellEventListView: View {
    
    var event: Event
    @State private var title = ""
    @State private var date = Date()
    
    var body: some View {
        VStack{
            Text("\(title), \(date, formatter: itemFormatter)")
        }.onAppear{
            title = event.titleEvent ?? "No event title"
            date = event.dateEvent ?? Date()
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        //formatter.timeStyle = .medium
        return formatter
    }()
}

struct CellEventListView_Previews: PreviewProvider {
    static var previews: some View {
        CellEventListView(event: Event())
    }
}
