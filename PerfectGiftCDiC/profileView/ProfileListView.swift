//
//  ProfileListView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI
import CoreData

struct ProfileListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.nameProfile, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<Profile>
    
    @State var showAddProfileView: Bool = false
    
    var body: some View {
            ZStack{
                                
                List{
                    ForEach(profiles) { profile in
                        //se muestra con el zstack para quitar la flecha de la celda.
                        ZStack{
                            NavigationLink(destination: DetailProfileView(profile: profile) ){
                                Text("Profile")
                            }.opacity(0)
                            
                            CellProfileListView(profile: profile)
                        }.background(Color("cellprofileBck"))
                        .cornerRadius(20)
                        

                    }
                    .onDelete(perform: deleteItems)
                    
                }.listStyle(InsetListStyle())
                
                
                
                
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
                                    .padding()
                                }

                            })
                    }

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
    
        private func addItem() {
            withAnimation {
                let newProfile = Profile(context: viewContext)
                newProfile.idProfile = UUID()
    
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

//struct ProfileListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
