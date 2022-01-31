//
//  IdeasListView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 26/7/21.
//

import SwiftUI

struct IdeasListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showSheetMode = false
    var profile: Profile
    var ideas: FetchRequest<Ideas>
 //   var eventParent: Event
    
//    init(filterProfile: String,  filterEvent: String, event: Event){
//        ideas = FetchRequest<Ideas>(entity: Ideas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)], predicate: NSPredicate(format: "idProfileIdea MATCHES[dc] %@ AND idEventIdea MATCHES[dc] %@", filterProfile, filterEvent),animation: .default)
        


  //      eventParent = event

  //  }
    
    init(profile: Profile){
        ideas = FetchRequest<Ideas>(entity: Ideas.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ideas.ideaTitle, ascending: true)], predicate: NSPredicate(format: "idProfileIdea MATCHES[dc] %@", profile.idProfile?.uuidString ?? "nadie"),animation: .default)
        
        self.profile = profile
    }
    
    var body: some View {
        
        ZStack{
            VStack{
                Text("IDEAS")
                    .foregroundColor(Color("colorTextoTitulo"))
                    .font(.custom("marker Felt", size: 18))
                List{
                    ForEach(ideas.wrappedValue, id: \.self) { idea in
                        ZStack{
                            NavigationLink(destination: DetailIdeaView(idea: idea) ){
                                Text("idea")
                            }.opacity(0)
                            CellIdeaListView(idea: idea)
                        }.background(Color("cellprofileBck"))
                        .cornerRadius(20)

                    }.onDelete { IndexSet in
                    }
                }
            }
            
            //Boton de añadir idea
            HStack{
                Spacer()
                VStack{
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
                    }).buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showSheetMode,
                               onDismiss: {print("cerrar vista añadir idea") },
                               content: {AddIdeaView(profile: profile, showSheetMode: $showSheetMode)})
                        .padding()
                }
                
            }.padding(.bottom,30)
        }
        
    }
    
}

//struct IdeasListView_Previews: PreviewProvider {
//    static var previews: some View {
//        IdeasListView(filterProfile: "pablo", filterEvent: "cumple")
//    }
//}
