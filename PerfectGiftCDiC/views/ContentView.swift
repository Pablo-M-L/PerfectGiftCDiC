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
    
    init() {
        
        UINavigationBar.appearance().backgroundColor = UIColor(Color("background"))
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color("colorTextoTitulo")),
            .font : UIFont(name:"Marker Felt", size: 50)!]
        
        UITabBar.appearance().backgroundColor = UIColor.purple
        
    }
    var body: some View {
            NavigationView{
                TabView{
                    ProfileListView()
                        .tabItem {
                            Image(systemName: "person.fill.badge.plus")
                        }.tag(0)
                    
                    
                    
                    UpcomingListsView()
                        .tabItem {
                            Image(systemName: "calendar.badge.clock")
                        }.tag(1)
                }
                .accentColor(Color("backgroundButton"))
                .navigationTitle("Perfect Gift")
                .colorMultiply(Color("background"))
                .edgesIgnoringSafeArea(.all)
            }
    
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
