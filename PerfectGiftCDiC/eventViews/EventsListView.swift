//
//  EventsListView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 8/7/21.
//

import SwiftUI
import CoreData

struct EventsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    var events: FetchRequest<Event>
    
    init(filter: String){
            events = FetchRequest<Event>(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)], predicate: NSPredicate(format: "profileEventRelation.nameProfile MATCHES[dc] %@", filter),animation: .default)
    }
    
    var body: some View {
        
        VStack{
            Text("lista de eventos")
            
            List{
                ForEach(events.wrappedValue, id: \.self) { event in
                    NavigationLink(destination: DetailEventView(event: event) ){
                        CellEventListView(event: event)
                    }
                    
                        
                }
                //.onDelete(perform: deleteItems)
                
            }
        }.onAppear{
            dump(events)
        }
    }
    
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { events[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView(filter: "pablo")
    }
}
