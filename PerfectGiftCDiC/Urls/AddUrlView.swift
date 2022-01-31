//
//  AddUrlView.swift
//  PerfectGiftCDiC
//
//  Created by Pablo Millan on 27/7/21.
//

import SwiftUI
import Combine

struct AddUrlView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    var idea: Ideas?
    var newUrl: Bool
    var urlIdea: UrlIdeas?
    @State var titleUrl = "vacio"
    @State var webUrl = "vacio"
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                TextField("Title url", text: $titleUrl)
                    .onReceive(Just(titleUrl)){ value in
                        if value != "vacio" && value != urlIdea?.titleUrl{
                            if !newUrl{
                                updateUrl()
                            }
                        }
                        
                    }
                TextField("web url", text: $webUrl)
                    .onReceive(Just(webUrl)){ value in
                        if value != "vacio" && value != urlIdea?.webUrl{
                            if !newUrl{
                                updateUrl()
                            }
                            
                        }
                        
                    }
                Spacer()
            }.onAppear{
                if !newUrl{
                    titleUrl = urlIdea?.titleUrl ?? "no title"
                    webUrl = urlIdea?.webUrl ?? "https://google.com"
                }
            }
            
            if newUrl{
                //boton guardar
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            if newUrl{
                                addUrl()
                            }else{
                                updateUrl()
                            }
                        }, label: {
                            
                            Text("Save")
                                .font(.custom("Marker Felt", size: 18))
                                .foregroundColor(.blue)
                                .padding(20)
                                .background(Color.orange)
                                .cornerRadius(25)
                        })
                    }
                }
            }
            
            
        }
    }
    
    
    private func updateUrl(){
        print(newUrl)
        withAnimation {
            urlIdea?.titleUrl = titleUrl
            urlIdea?.webUrl = webUrl
            
            do {
                try viewContext.save()
                print("url actualizada")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
       // presentationMode.wrappedValue.dismiss()
        
    }
    
    private func addUrl() {
        withAnimation {
            let newUrl = UrlIdeas(context: viewContext)
            newUrl.titleUrl = titleUrl
            newUrl.idUrl = UUID()
            newUrl.webUrl = webUrl
            newUrl.idIdeaUrl = idea?.idIdeas?.uuidString

            
            do {
                try viewContext.save()
                print("url guardada")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

//struct AddUrlView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddUrlView(
//    }
//}
