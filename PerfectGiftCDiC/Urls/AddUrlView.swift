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
    @State var titleUrl = ""
    @State var webUrl = ""
    @State var thumbailUrl = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    var defaultUrlThumbail = URL(string: "https://www.google.com/s2/favicons?domain=www.google.com")
    var urlThumbail = URL(string: "https://www.google.com/s2/favicons?domain=www.google.com")
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            
            VStack{
                
                Text("Web Title:")
                    .font(.custom("marker Felt", size: 24))
                    .foregroundColor(Color.purple)
                
                TextField("Title url", text: $titleUrl)
                    .padding(5)
                    .background(Color.white)
                    .font(.custom("Arial", size: 22))
                    .cornerRadius(5)
                    .onReceive(Just(titleUrl)){ value in
                        if value != ""{
                            if !newUrl{
                                updateUrl()
                            }
                        }
                        
                    }
                    .padding(.bottom, 15)
                
                Text("LINK")
                    .font(.custom("marker Felt", size: 24))
                    .foregroundColor(Color.purple)

                TextEditor(text: $webUrl)
                    .frame(height: UIScreen.main.bounds.height / 5.5)
                    .font(.custom("Arial", size: 18))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .cornerRadius(25)
                    .onReceive(Just(webUrl)){ value in
                        if value != ""{
                            if !newUrl{
                                updateUrl()
                            }
                            
                        }
                        
                    }
                Spacer()
                
            }
            .onTapGesture {
                //para ocultar el teclado
                    UIApplication.shared.endEditing()
                }
            .padding()
            .padding(.top, 50)
            .navigationBarItems(trailing:
                                   HStack{
                                       Spacer()
                
                                        Button(action: {
                                            print("borrar url")
                                            deleteIdea(url: urlIdea!)
                                        },label:{
                                            Image(systemName: "trash")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 35, height: 35)
                                                .foregroundColor(.purple)
                                        })
                                   })
            .onAppear{
                print(newUrl)
                print(urlIdea?.titleUrl ?? "no url")
                if !newUrl{
                    titleUrl = urlIdea?.titleUrl ?? "no title"
                    webUrl = urlIdea?.webUrl ?? "https://google.com"
                    
                    
                    if urlIdea?.thumbailUrl == nil{
                        print("abre como nulo")
                        thumbailUrl = UIImage(imageLiteralResourceName: "logoPerfectgift")
                    }
                    else{
                        let imgData = urlIdea?.thumbailUrl
                        let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                        thumbailUrl = UIImage(data: data)!
                    }
                    
                    
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
                        }).padding(20)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    }
                }
            }
            
            
        }
    }
    
    private func deleteIdea(url: UrlIdeas){
        
        viewContext.delete(url)
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        
    }
    

    
    private func updateUrl(){
        
        withAnimation {
            urlIdea?.titleUrl = titleUrl
            urlIdea?.webUrl =  comprobarUrlIntroducida(url: webUrl)
            
            downloadthumbail(url: (URL(string: ("https://www.google.com/s2/favicons?domain=" + webUrl)) ?? defaultUrlThumbail!)) { UIImage in
                let imageData =  UIImage.jpegData(compressionQuality: 1)
                let data = try! JSONEncoder().encode(imageData)
                urlIdea?.thumbailUrl = data
            }
            
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
        //presentationMode.wrappedValue.dismiss()
        
    }
    
    private func addUrl() {
        
        withAnimation {
            
            let thumbailImage = UIImage(imageLiteralResourceName: "logoPerfectgift").jpegData(compressionQuality: 0.5)
            var thumbailImageData = try! JSONEncoder().encode(thumbailImage)
            
            let newUrl = UrlIdeas(context: viewContext)
            newUrl.titleUrl = titleUrl
            newUrl.idUrl = UUID()
            newUrl.webUrl = comprobarUrlIntroducida(url: webUrl)
            newUrl.idIdeaUrl = idea?.idIdeas?.uuidString
            newUrl.ideaUrlRelation = idea
            //newUrl.thumbailUrl = thumbailImageData
            
            downloadthumbail(url: (URL(string: ("https://www.google.com/s2/favicons?domain=" + webUrl)) ?? defaultUrlThumbail!)) { UIImage in
                let imageData =  UIImage.jpegData(compressionQuality: 1)
                let data = try! JSONEncoder().encode(imageData)
                newUrl.thumbailUrl = data
            }
                do {
                    try viewContext.save()
                    print("url guardada")
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
        }
        
        
    }
    

}

//struct AddUrlView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddUrlView(
//    }
//}
