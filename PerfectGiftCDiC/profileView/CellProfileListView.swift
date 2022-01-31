//
//  CellProfileListView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 6/7/21.
//

import SwiftUI
import CoreData

/** formato de cada celda (fila) de perfil que se muesta en la vista de profileList*/
struct CellProfileListView: View {
    
    //    TextEditor is backed by UITextView. So you need to get rid of the UITextView's backgroundColor first and then you can set any View to the background.
    //        init() {
    //            UITextView.appearance().backgroundColor = .clear
    //        }
    
    @EnvironmentObject var viewModel: ViewModel
    
    var profile: Profile
    var numeroEventos: Int
    
    
    @State var upcomingEvent: eventUpcoming = eventUpcoming(id: UUID(), titleEvent: "no title", dateEvent: Date(), annualEvent: false, observationEvent: "no observation")
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)],
        animation: .default)
    private var eventos: FetchedResults<Event>
    
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var showSheetMode = false
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    //imagen del perfil
                    Image(uiImage: imgServicio)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 65, height: 70)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 3))
                        .padding(.leading, 8)
                        .padding(.trailing, 3)
                    
                    VStack(alignment: .leading){
                        //nombre del perfil
                        Text(profile.nameProfile ?? "sin nombre")
                            .font(.custom("Marker Felt", size: 26))
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
                                    Text("In \(calcularDiasQueFaltan(dateEvent: upcomingEvent.dateEvent)) Days")
                                        .bold()
                                        .minimumScaleFactor(0.3)
                                        .foregroundColor(.red)
                                    Text("\(upcomingEvent.dateEvent, formatter: itemFormatter)")
                                        .bold()
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                    
                                }
                            }
                            else{
                                Text("No hay eventos")
                                    .bold()
                            }
                        }
                        .font(.custom("Marker Felt", size: 16))
                        .foregroundColor(Color("backgroundButton"))
                    }.padding(.vertical,5)
                    
                    Spacer()

                    Button(action: {
                        print("abrir sheet")
                        showSheetMode = true
                    }, label: {
                        ZStack{
                               Circle()
                                   .foregroundColor(Color("backgroundButton"))
                               Image(systemName: "person.fill.badge.plus")
                                   .resizable()
                                   .foregroundColor(.white)
                                   .background(Color("backgroundButton"))
                                   .aspectRatio(contentMode: .fit)
                                   .padding(8)
                           
                       }
                       .frame(width: 50, height: 50)
                    }).buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $showSheetMode,
                               onDismiss: {print("cerrar vista añadir idea") },
                               content: {AddIdeaView(profile: profile, showSheetMode: $showSheetMode)})
                        .padding(5)
                }
            }
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
