//
//  CellProfileListView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 6/7/21.
//

import SwiftUI
import CoreData

struct CellProfileListView: View {
    
    //    TextEditor is backed by UITextView. So you need to get rid of the UITextView's backgroundColor first and then you can set any View to the background.
    //        init() {
    //            UITextView.appearance().backgroundColor = .clear
    //        }
    
    
    var profile: Profile
    var numeroEventos: Int
    
    
    @State var upcomingEvent: eventUpcoming = eventUpcoming(id: UUID(), titleEvent: "no title", dateEvent: Date(), annualEvent: false, observationEvent: "no observation")
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)],
        animation: .default)
    private var eventos: FetchedResults<Event>
    
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    
                    Image(uiImage: imgServicio)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 10)
                    
                    VStack(alignment: .leading){
                        
                        Text(profile.nameProfile ?? "sin nombre")
                            .font(.custom("Marker Felt", size: 22))
                            .bold()
                            .foregroundColor(.purple)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        
                        HStack{
                            if numeroEventos > 0{
                                VStack(alignment: .leading){
                                    
                                    Text("\(upcomingEvent.titleEvent)")
                                        .bold()
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                    Text("\(upcomingEvent.dateEvent, formatter: itemFormatter)")
                                        .bold()
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.3)
                                    
                                }
                                
                                Spacer()
                                
                                HStack(alignment: .top){
                                    Text("\(calcularDiasQueFaltan(dateEvent: upcomingEvent.dateEvent))")
                                        .font(.custom("Marker Felt", size: 22))
                                    Text("Dias")
                                        .font(.custom("Marker Felt", size: 10))
                                }
                                .padding(5)
                                .background(Color("background3"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                                .offset(x: 0, y: -20)

                            }
                            else{
                                Text("No hay eventos")
                                    .bold()
                            }
                        }
                        .font(.custom("Marker Felt", size: 16))
                        .foregroundColor(Color("backgroundButton"))
                    }
                    Spacer()
                    
                }
            }
            .frame(height: 100)
            .onAppear{
                if !eventos.isEmpty{
                    let eventFilter = eventos.filter{$0.profileEventRelation?.nameProfile == profile.nameProfile}
                    if !eventFilter.isEmpty{
                        upcomingEvent =  getUpcomingEvent(eventsfitrados: eventFilter)
                    }
                }
                
                
                if profile.imageProfile == nil{
                    imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
                }
                else{
                    let imgData = profile.imageProfile
                    let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                    imgServicio = UIImage(data: data)!
                }
            }
        }
    }
    
    
    
}

struct CellProfileListView_Previews: PreviewProvider {
    static var previews: some View {
        CellProfileListView(profile: Profile(), numeroEventos: 1)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
