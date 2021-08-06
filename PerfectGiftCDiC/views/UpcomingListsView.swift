//
//  UpcomingListsView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI
import CoreData

struct UpcomingListsView: View {
    
    @FetchRequest(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)],
                  animation: .default)
    private var events: FetchedResults<Event>
    
    var body: some View {
        VStack{
            List{
                ForEach(events, id: \.self) { evento in
                    Text("title: \(evento.titleEvent ?? "empty")")
                }
            }
        }
    }
}

struct UpcomingListsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingListsView()
    }
}
