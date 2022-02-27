//
//  CellFavoriteView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 10/2/22.
//

import SwiftUI

struct CellFavoriteView: View {
    
    @State var upcomingEvent: eventUpcoming = eventUpcoming(id: UUID(), titleEvent: "no title", dateEvent: Date(), annualEvent: false, observationEvent: "no observation")
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)],
        animation: .default)
    private var eventos: FetchedResults<Event>
    
    @State var numeroEventos: Int = 0
    
    var favorite: FavoriteData
    
    @State private var imgFavoriteProfile = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    
    
    var body: some View {
            HStack{
                //imagen del perfil
                Image(uiImage: imgFavoriteProfile)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 65, height: 70)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 3))
                    .padding(.leading, 8)
                    .padding(.trailing, 3)
                


                VStack(alignment: .leading){
                    //nombre del perfil
                    Text(favorite.nameProfileFav )
                        .font(.custom("Marker Felt", size: 16))
                        .bold()
                        .foregroundColor(.purple)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    //muestra el nombre del evento mas cercano y la fecha.
                    HStack{
                        if numeroEventos > 0{
                            VStack(alignment: .leading){
                                Text("\(upcomingEvent.titleEvent)")
                                    .font(.custom("Marker Felt", size: 20))
                                    .bold()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.3)
                                Text("\(upcomingEvent.dateEvent, formatter: itemFormatter)")
                                    .bold()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.3)


                                //barra de progreso que indica los dias que faltan
                                ZStack{

                                    HStack{
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(.red)
                                            .opacity(0.7)
                                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 25, alignment: .leading)
                                        Spacer()
                                    }
                                    HStack{
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(.green)
                                            .opacity(0.8)
                                            .frame(width: ((UIScreen.main.bounds.width / 2.5) * CGFloat(calcularDiasQueFaltan(dateEvent: upcomingEvent.dateEvent))) / 365,
                                                   height: 25,
                                                   alignment: .leading)
                                        Spacer()
                                    }
                                    Text("\(calcularDiasQueFaltan(dateEvent: upcomingEvent.dateEvent)) Days")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.custom("marker felt", size: 16))
                                        .minimumScaleFactor(0.3)
                                        .lineLimit(1)
                                }

                            }
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
            .padding(5)
            .padding(.vertical, 10)
            .background(Color("cellprofileBck"))
            .onAppear{
                if !eventos.isEmpty{
                    let eventFilter = eventos.filter{$0.profileEventRelation?.idProfile == UUID(uuidString:favorite.idProfileFav)}
                    if !eventFilter.isEmpty{
                        self.numeroEventos = 1
                        upcomingEvent =  getUpcomingEvent(eventsfitrados: eventFilter)
                    }
                }

                let imgData = favorite.imgProfileFav
                let data = try! JSONDecoder().decode(Data.self, from: imgData)
                imgFavoriteProfile = UIImage(data: data)!
        }
    }
}

//struct CellFavoriteView_Previews: PreviewProvider {
//    static var previews: some View {
//        CellFavoriteView()
//    }
//}
