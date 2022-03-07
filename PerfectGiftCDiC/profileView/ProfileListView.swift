//
//  ProfileListView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI
import CoreData
import Combine

/**
 Vista que contiene la lista de perfiles creados.
 */
struct ProfileListView: View {
    
    @State var recargarLista = true
    @State var showAddProfileView: Bool = false
    
    var body: some View {
        VStack{
            Text(NSLocalizedString("persons", comment: ""))
                .foregroundColor(Color("colorTextoTitulo"))
                .font(.custom("marker Felt", size: 24))
                .padding(.top,10)
            
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.3)
                .frame(height: 5)
            
            if recargarLista{
                profileList()
            }
            else{
                profileList()
            }
        }.onAppear{
            recargarLista.toggle()
        }
    }
    
}

/**
 struct saveProfileButton, boton flotante que abre la vista AddProfileView para añadir un perfil nuevo.
 */
struct saveProfileButton: View{
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
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 20)
                            .padding(.bottom, 120)
                        }
                        
                    })
            }
            
        }
    }
}

/** struct profileList, lista de perfiles que se muestra en la vista profileListView */
struct profileList: View{
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.nameProfile, ascending: true)],
        animation: .default)
    
    private var profiles: FetchedResults<Profile>
    
    
    var body: some View{
        
        if profiles.count > 0{
            List{
                ForEach(profiles) { profile in
                CellProfileListView(profile: profile, numeroEventos: profile.eventProfileRelation?.count ?? 0)
                    .background(Color("cellprofileBck"))
                     .cornerRadius(20)
                     .shadow(color: .gray, radius: 2, x: 3, y: 3)
                     .padding(.vertical, 10)
                    //se muestra con el zstack para quitar la flecha de la celda.
                }
                .onDelete(perform: deleteItems)
            }.listStyle(.inset)
                .padding(.top,15)
                .padding(.bottom,25)
        }else{
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
                                        .frame(width: 250, height: 250)
                                    Image(systemName: "person.fill.badge.plus")
                                        .resizable()
                                        .foregroundColor(.white)
                                        //.background(Color("backgroundButton"))
                                        .aspectRatio(contentMode: .fit)
                                        .padding(8)
                                        .frame(width: 200, height: 200)
                                    
                                }
                                
                                .padding(.trailing, UIScreen.main.bounds.width / 5)
                                .padding(.bottom, UIScreen.main.bounds.height / 6)
                            }
                            
                        })
                }
                Spacer()
            }
        }

            
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { profiles[$0] }.forEach(viewContext.delete)
            
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

struct ProfileListView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
