//
//  ContentView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI

/**{
 Vista principal con la que abre la aplicacion.
 consta de un tabView que contiene la vista con los perfiles
 y otra con la lista de los eventos en orden ascendente de fecha.
 */
struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    //upcomingevents
    @FetchRequest(entity: Event.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Event.titleEvent, ascending: true)],
                  animation: .default)
    private var events: FetchedResults<Event>
    
    //profile list
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.nameProfile, ascending: true)],
        animation: .default)
    
    private var profiles: FetchedResults<Profile>
    @State var cambiarLista = false
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                Color("background")
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    if cambiarLista{
                        UpcomingListsView()
                    }
                    else{
                        ProfileListView()
                    }
                    
                VStack{
                    HStack(alignment: .center, spacing: 50){
                        Button(action:{
                            withAnimation {
                                cambiarLista = false
                            }
                            
                        },label:{
                            SelecctListButtonStyle(cambiarLista: $cambiarLista, texto: "Profiles", color: cambiarLista ? "backgroundButton" : "background3")
                        })
                        
                        Button(action:{
                            withAnimation {
                                cambiarLista = true
                            }
                        },label:{
                            SelecctListButtonStyle(cambiarLista: $cambiarLista, texto: "Upcoming", color: cambiarLista ? "background3" : "backgroundButton")
                        })
                        
                        
                    }.padding(.bottom,35)
                        
                }.frame( height: 25)
                        
                      
                }
                .navigationBarItems(leading: logoButtonDummy() ,trailing: saveProfileButton2())
                .accentColor(Color("colorTextoTitulo"))
                .navigationTitle("Perfect Gift")
                .navigationBarTitleDisplayMode(.inline)
                .colorMultiply(Color("background"))
                .accentColor(Color("background"))
                
                .onAppear{
                    setUpApparence()
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
        HStack{

                Image("logoPerfectgift")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
        }
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

struct SelecctListButtonStyle:View{
    @Binding var cambiarLista: Bool
    var texto: String
    var color: String
    
    var body: some View{
        ZStack(alignment: .center){
            Spacer()
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(color))
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
            Text(texto)
                .padding(5)
                .foregroundColor(Color("colorTextoTitulo"))
                .font(.custom("marker felt", size: 18))
        }.frame(width: UIScreen.main.bounds.width / 3, height: 35)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
