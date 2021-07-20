//
//  ContentView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showProfileListView = true
    @State private var showAddProfileView = false
    
    init() {
        
        UINavigationBar.appearance().backgroundColor = UIColor(Color("background"))
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color("colorTextoTitulo")),
            .font : UIFont(name:"Marker Felt", size: 50)!]
        
    }
    var body: some View {
            NavigationView{
                TabView{
                    ProfileListView()
                        .tabItem {
                            Image(systemName: "person.fill.badge.plus")
                        }
                    
                    
                    UpcomingListsView()
                        .tabItem {
                            Image(systemName: "calendar.badge.clock")
                        }
                    
                    
                    
                    
                }
                .navigationTitle("Perfect Gift")
                .colorMultiply(Color("background"))
                .edgesIgnoringSafeArea(.all)
            }
    
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
