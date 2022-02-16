//
//  PruebaViewmodelView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 4/8/21.
//

import SwiftUI

struct PruebaViewmodelView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = ViewModel()
    private var helper = CoredataHelper()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.nameProfile, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<Profile>
    
    
    var body: some View {
        List{
            ForEach(viewModel.profileList, id: \.self){ item in
                cellPrueba(profile: item, numeroEventos: 1)
            }
        }
            .onAppear{
                viewModel.profileList = helper.getProlfileList(profiles: profiles)
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
    }
}

struct cellPrueba: View{
    
    var profile: profileListItem
    var numeroEventos: Int
    
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State var upcomingEvent: eventUpcoming = eventUpcoming(id: UUID(), titleEvent: "no title", dateEvent: Date(), annualEvent: false, observationEvent: "no observation")
    
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
                        
                        Text(profile.nameProfile)
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
//                if !eventos.isEmpty{
//                    let eventFilter = eventos.filter{$0.profileEventRelation?.nameProfile == profile.nameProfile}
//                    if !eventFilter.isEmpty{
//                        upcomingEvent =  getUpcomingEvent(eventsfitrados: eventFilter)
//                    }
//                }
                
                
                if profile.imageProfile.pngData() == nil{
                    imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
                }
                else{
                    imgServicio = profile.imageProfile
                }
            }
        }
    }
}

struct PruebaViewmodelView_Previews: PreviewProvider {
    static var previews: some View {
        PruebaViewmodelView()
    }
}
