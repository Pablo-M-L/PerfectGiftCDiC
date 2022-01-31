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

    var profileParent: Profile
    @State private var showAddEvent = false

    init(filter: String, profile: Profile){
            events = FetchRequest<Event>(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)], predicate: NSPredicate(format: "profileEventRelation.nameProfile MATCHES[dc] %@", filter),animation: .default)

        profileParent = profile

    }
    
    var body: some View {
        ZStack{
            VStack{
                Text("EVENTS")
                    .foregroundColor(Color("colorTextoTitulo"))
                    .font(.custom("marker Felt", size: 18))
                List{
                    ForEach(events.wrappedValue, id: \.self) { event in
                        
                        ZStack{
                            NavigationLink(destination: DetailEventView(event: event) ){
                                Text("Events")
                            }.opacity(0)
                            
                            CellEventListView(event: event)
                        }.background(Color("cellprofileBck"))
                         .cornerRadius(20)

                        
                            
                    }
                   // .onDelete(perform: deleteItems)
                    
                }
                

            }
            
            HStack{
                Spacer()
                
                VStack{
                    Spacer()
                    
                    //boton añadir evento
                    Button(action: {
                        showAddEvent = true
                    }, label: {
                        ZStack{
                            Circle()
                                .foregroundColor(Color("backgroundButton"))
                            Image(systemName: "calendar.badge.plus")
                                .resizable()
                                .foregroundColor(.white)
                                .background(Color("backgroundButton"))
                                .aspectRatio(contentMode: .fit)
                                .padding(8)
                            
                            
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                    }).sheet(isPresented: $showAddEvent) {
                        AddEventView(profile: profileParent)
                    }
                }
            }.padding(.bottom, 30)
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
        EventsListView(filter: "pablo", profile: Profile())
    }
}
