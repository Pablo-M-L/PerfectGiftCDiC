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
    
    
    
    var profile: Profile
    var numeroEventos: Int
    
    var body: some View {
        HStack{
            datosProfileCell(profile: profile, numeroEventos: numeroEventos)
                .buttonStyle(.borderless)
            Spacer()
            
            addIdeaButton(profile: profile)
                .buttonStyle(.borderless)
                .padding(.trailing,5)
        }
        
        
    }
    
    
    
}

struct datosProfileCell:View{
    @EnvironmentObject var viewModel: ViewModel
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    
    @State var upcomingEvent: eventUpcoming = eventUpcoming(id: UUID(), profileParent: Profile(), titleEvent: "no title", dateEvent: Date(), annualEvent: false, typeEvent: "BirthDay", observationEvent: "no observation")
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)],
        animation: .default)
    private var eventos: FetchedResults<Event>
    
    var profile: Profile
    var numeroEventos: Int
    @State private var showSheetMode = false
    
    var body: some View{
        
        ZStack{
                NavigationLink(destination: DetailProfileView(profile: profile), isActive: $showSheetMode){
                    Text("")
                }
            
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
            
        }
        .onTapGesture {
            self.showSheetMode = true
        }
        .onAppear{
            if !eventos.isEmpty{
                let eventFilter = eventos.filter{$0.profileEventRelation?.idProfile == profile.idProfile}
                if !eventFilter.isEmpty{
                    print("celda profile")
                    print(eventFilter[0].dateEvent)
                    
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

struct addIdeaButton: View{
    
    var profile: Profile
    @State private var showSheetMode = false
    
    var body: some View{
        ZStack{
            NavigationLink(destination: AddIdeaView(profile: profile), isActive: $showSheetMode){
                EmptyView()
            }
            
            ZStack{
                Image("addIdeaIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 23, height: 23)
                    .foregroundColor(Color("backgroundButton"))
                    .offset(x: -25, y: 25)
            }
                .onTapGesture {
                    self.showSheetMode = true
                }
        }.frame(width: 60 , height: 60)
    }
}

struct CellProfileListView_Previews: PreviewProvider {
    static var previews: some View {
        CellProfileListView(profile: Profile(), numeroEventos: 1)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
