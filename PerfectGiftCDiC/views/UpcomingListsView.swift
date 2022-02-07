//
//  UpcomingListsView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI
import CoreData

struct UpcomingListsView: View {
    
    @State private var recargarLista = false
    
    var body: some View {
        VStack{
            if recargarLista{
                EventUpcomingList()
            }else{
                EventUpcomingList()
            }
        }.onAppear{
            recargarLista.toggle()
        }
        

        
    }
}

struct EventUpcomingList: View{
    
    @FetchRequest(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.dateEvent, ascending: false)],
                  animation: .default)
    private var events: FetchedResults<Event>
    
    var body: some View{
        List{
            ForEach(events, id: \.self) { evento in
                ZStack{
                    NavigationLink(destination: DetailEventView(event: evento) ){
                        Text("event")
                    }.opacity(0)
                    CellEventUpcomingList(event: evento)
                }.background(Color("cellprofileBck"))
                .cornerRadius(20)
                .shadow(color: .gray, radius: 4, x: 3, y: 3)
                }
            }.listStyle(.inset)
            .padding(.top,15)
            .padding(.bottom,25)
    }
    
}
struct UpcomingListsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingListsView()
    }
}
