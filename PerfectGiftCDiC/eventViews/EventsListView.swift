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
    @State private var ideasListEmpty = false
    
    init(filter: String, profile: Profile){
        events = FetchRequest<Event>(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)], predicate: NSPredicate(format: "profileEventRelation.nameProfile MATCHES[dc] %@", filter),animation: .default)
        
        profileParent = profile
        
    }
    
    var body: some View {
        ZStack{
            List{
                ForEach(sortEventsProfile(eventos: events), id: \.self) { event in
                    
                    ZStack{
                        NavigationLink(destination: DetailEventView(event: event) ){
                            EmptyView()
                        }.opacity(0)
                        
                        CellEventListView(event: event)
                    }.background(Color("cellprofileBck"))
                        .cornerRadius(20)
                    
                    
                    
                }
            }.listStyle(.inset)
            
            
            VStack{
                if ideasListEmpty{
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: AddEventView(profile: profileParent), isActive: $showAddEvent){
                            EmptyView()
                        }
                        
                        Button(action:{
                            showAddEvent = true
                            
                        }, label:{
                            ZStack{
                                Image("addEventIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color("backgroundButton"))
                                    .offset(x: -65, y: 70)
                            }
                            .frame(width: 150, height: 150)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding()
                        })
                        
                        Spacer()
                    }
                    
                }
            }                    .onAppear {
                //comprobar si el fetchrequest está vacio
                if events.wrappedValue.isEmpty{
                    ideasListEmpty = true
                }else{
                    ideasListEmpty = false
                }
                
            }
            
        }
        
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView(filter: "pablo", profile: Profile())
    }
}
