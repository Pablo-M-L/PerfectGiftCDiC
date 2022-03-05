//
//  ContentView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI
import WidgetKit

/**{
 Vista principal con la que abre la aplicacion.
 consta de un tabView que contiene la vista con los perfiles
 y otra con la lista de los eventos en orden ascendente de fecha.
 */
struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    //upcomingevents
    @FetchRequest(entity: Ideas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)],
                  animation: .default)
    private var ideas: FetchedResults<Ideas>
    
    
    //events
    @FetchRequest(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)],
                  animation: .default)
    private var events: FetchedResults<Event>
    
    //url
    @FetchRequest(entity: UrlIdeas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UrlIdeas.titleUrl, ascending: true)],
                  animation: .default)
    private var url: FetchedResults<UrlIdeas>
    
    //profile list
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.nameProfile, ascending: true)],
        animation: .default)
    
    private var profiles: FetchedResults<Profile>
    
    @State var vistaActiva: VistaActiva = .profiles
    @State var firstAppRun = true
    
    var body: some View {
        
        if !firstAppRun{
            NavigationView{
            
            ZStack{
                
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    if vistaActiva == .favorites{
                        FavoritesListView()
                    }
                    else if vistaActiva == .profiles{
                        ProfileListView()
                        
                    }
                    else if vistaActiva == .upcoming{
                        UpcomingListsView()
                    }
                    
                    VStack{
                        HStack(alignment: .center, spacing: 50){
                            Button(action:{
                                withAnimation {
                                    vistaActiva = .favorites
                                }
                                
                            },label:{
                                SelecctListButtonStyle(vistaActiva: $vistaActiva, listaAsociadaAlBoton: .favorites)
                            })
                            
                            Button(action:{
                                withAnimation {
                                    vistaActiva = .profiles
                                }
                                
                            },label:{
                                SelecctListButtonStyle(vistaActiva: $vistaActiva, listaAsociadaAlBoton: .profiles)
                            })
                            
                            Button(action:{
                                withAnimation {
                                    vistaActiva = .upcoming
                                }
                            },label:{
                                SelecctListButtonStyle(vistaActiva: $vistaActiva, listaAsociadaAlBoton: .upcoming)
                            })
                            
                            
                        }.padding(.bottom,35)
                        
                    }.frame( height: 25)
                    
                    
                }
                .navigationBarItems(leading: logoButtonDummy() ,trailing: saveProfileButton2())
                .navigationTitle("Perfect Gift")
                .navigationBarTitleDisplayMode(.inline)
                .colorMultiply(Color("background"))
                
                .onAppear{
                    setUpApparence()
                    print("eventos: \(events.count)")
                    print("ideas: \(ideas.count)")
                    print("urls: \(url.count)")
                    
                    //cargar favoritos
                    if let usersdefault = UserDefaults(suiteName: appGroupName), let arrayFav: [FavoriteData] = usersdefault.getArray(forKey: key.arrayFavoriteData.rawValue){
                        HelperWidget.arrayFavoriteData = arrayFav
                        
                    }
                    else{
                        for i in 1...6{
                            HelperWidget.cargarListaFavoritosDefaultUser(sortNumber: Int(i))
                        }
                    }
                    
                    HelperWidget.leerListaFavoritos()
                    
                    //guardar lista de eventos en usersdefault como array de EventDateUpComing para poder acceder a ellos desde el widget
                    
                        if !events.isEmpty{
                            var arrayEvents = [EventDateUpComing]()
                            
                            if let userDefault = UserDefaults(suiteName: appGroupName){
                                for event in events{
                                    print("si hay eventos")
                                    let eventsUpcoming = EventDateUpComing(
                                                            dateEvent: event.dateEvent ?? Date(),
                                                            titleEvent: event.titleEvent ?? "no title",
                                                            idProfileFav: event.profileEventRelation?.idProfile!.uuidString ?? "5000",
                                                            annualEvent: event.annualEvent)
                                    arrayEvents.append(eventsUpcoming)
                                }
                                
                                userDefault.setArray(arrayEvents, forKey: key.arrayEvents.rawValue)
                            }
                    }
                }
                
                
                
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        }
        else{
            MensajeBienvenidaView(firstAppRun: $firstAppRun)
                .onAppear {
                    //comprueba si es la primera vez que se abre la aplicacion
                    if let checkfirstAppRun = UserDefaults.standard.value(forKey: key.firstAppRun.rawValue) as? Bool{
                        print("first \(checkfirstAppRun)")
                        firstAppRun = checkfirstAppRun
                    }
                }
                
        }
        
        
    }
    
    
    func setUpApparence(){
        UINavigationBar.appearance().backgroundColor = UIColor(Color("background"))
        UINavigationBar.appearance().tintColor = .blue //UIColor(Color("background"))
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color("colorTextoTitulo")),
            .font : UIFont(name:"Marker Felt", size: 44)!]
        
        
        
        UITabBar.appearance().backgroundColor = UIColor(Color("backgroundButton"))
        UITabBar.appearance().barTintColor = UIColor(Color("backgroundButton"))
        UITabBar.appearance().unselectedItemTintColor = .white
    }
    
}

struct logoButtonDummy:View{
    
    var body: some View{
        
        Button(action:{
            
            print("ayuda")
        },label:{
            HStack{
                
                Image("logoPerfectgift")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
                
                Spacer()
            }
        })
        
    }
}

struct saveProfileButton2: View{
    var body: some View{
        VStack{
            Spacer()
            
            HStack{
                
                Spacer()
                
                NavigationLink(
                    destination: AddProfileView(),
                    label: {
                        HStack{
                            Spacer()
                            
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
                            .frame(width: 30 , height: 30)
                            
                        }
                        
                    })
            }
            
        }
    }
}

enum VistaActiva{
    case favorites
    case profiles
    case upcoming
}

struct SelecctListButtonStyle:View{
    @Binding var vistaActiva: VistaActiva
    var listaAsociadaAlBoton: VistaActiva
    
    var body: some View{
        ZStack(alignment: .center){
            Spacer()
//            RoundedRectangle(cornerRadius: 20)
//                .foregroundColor(Color(vistaActiva == listaAsociadaAlBoton ? "background3" : "bacgroundButton"))
//                .shadow(color: .gray, radius: 2, x: 2, y: 2)

                switch listaAsociadaAlBoton{
                case .favorites:
                    Image(vistaActiva == listaAsociadaAlBoton ? "favoriteIconDark" : "favoriteIconLight")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(5)
                        .background(Color(vistaActiva == listaAsociadaAlBoton ? "backgroundButton" : "background3"))
                        .cornerRadius(20)
                    
                case .profiles:
                    Image(vistaActiva == listaAsociadaAlBoton ? "personsIconDark" : "personsIconLight")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(5)
                        .background(Color(vistaActiva == listaAsociadaAlBoton ? "backgroundButton" : "background3"))
                        .cornerRadius(20)
                    
                case .upcoming:
                    Image(vistaActiva == listaAsociadaAlBoton ? "upcomingIconDark" : "upcomingIconLight")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(5)
                        .background(Color(vistaActiva == listaAsociadaAlBoton ? "backgroundButton" : "background3"))
                        .cornerRadius(20)
                }
        }.frame(width: UIScreen.main.bounds.width / 4.5, height: 60)
         .shadow(color: .gray, radius: 2, x: 2, y: 2)
         .padding(.bottom, 15)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
