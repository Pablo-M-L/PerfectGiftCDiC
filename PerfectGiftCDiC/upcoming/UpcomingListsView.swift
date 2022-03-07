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
            Text(NSLocalizedString("upcomingEvents", comment: ""))
                .foregroundColor(Color("colorTextoTitulo"))
                .font(.custom("marker Felt", size: 24))
                .padding(.top,10)
            
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.3)
                .frame(height: 5)
            
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
    
    @FetchRequest(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.dateEvent, ascending: true)],animation: .default)
    private var events: FetchedResults<Event>
    
    var body: some View{
        List{
            ForEach(getUpcomingEventSorted(eventsfitrados: events.filter{$0 == $0}), id: \.self) { evento in
                ZStack{
                    NavigationLink(destination: DetailEventView(event: getEventFromEventUpcoming(evento: evento, eventos: events)) ){
                        EmptyView()
                    }.opacity(0)
                    CellEventUpcomingList(event: evento)
                        .background(Color("cellprofileBck"))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 4, x: 3, y: 3)
                }
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
