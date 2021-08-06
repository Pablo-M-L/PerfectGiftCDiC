//
//  ContentView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI

struct ContentView: View {
    
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
                    
                    
                    
                    //UpcomingListsView()
                        PruebaViewmodelView()
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
