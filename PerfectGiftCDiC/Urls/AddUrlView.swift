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
                
                Text("Title")
                    .font(.custom("marker Felt", size: 18))
                    .foregroundColor(Color.purple)
                TextField("Title url", text: $titleUrl)
                    .background(Color.white)
                    .onReceive(Just(titleUrl)){ value in
                        if value != ""{
                            if !newUrl{
                                updateUrl()
                            }
                        }
                        
                    }
                
                Text("Web")
                    .font(.custom("marker Felt", size: 18))
                    .foregroundColor(Color.purple)

                TextEditor(text: $webUrl)
                    .frame(height: UIScreen.main.bounds.height / 5.5)
                    .font(.custom("Arial", size: 18))
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
        presentationMode.wrappedValue.dismiss()
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \UrlIdeas.idUrl, ascending: true)],
            animation: .default)
        
        var profiles: FetchedResults<Ideas>
        
        viewContext.delete(url)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        
    }
    
    func downloadthumbail(url: URL, completionImage: @escaping (UIImage)-> Void){
        
        URLSession.shared.dataTask(with: url){data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else{
                if let error = error {
                    print("error en la descarga de thumbail \(error)")
                }
                return
            }
            
            if response.statusCode == 200{
                if let image = UIImage(data: data){
                    completionImage(image)
                }else{
                    print("no es una imagen")
                }
            }
            else{
                print("error \(response.statusCode)")
            }
            
        }.resume()
        
    }
    
    private func updateUrl(){
        
        withAnimation {
            urlIdea?.titleUrl = titleUrl
            urlIdea?.webUrl =  webUrl
            
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
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        let group = DispatchGroup()
        
        withAnimation {
            
            let thumbailImage = UIImage(imageLiteralResourceName: "logoPerfectgift").jpegData(compressionQuality: 0.5)
            var thumbailImageData = try! JSONEncoder().encode(thumbailImage)
            
            let newUrl = UrlIdeas(context: viewContext)
            newUrl.titleUrl = titleUrl
            newUrl.idUrl = UUID()
            newUrl.webUrl = webUrl
            newUrl.idIdeaUrl = idea?.idIdeas?.uuidString
            newUrl.ideaUrlRelation = idea
            
            queue.async(group: group) {
                downloadthumbail(url: (URL(string: ("https://www.google.com/s2/favicons?domain=" + webUrl)) ?? defaultUrlThumbail!)) { UIImage in
                    group.enter()
                    let imageData =  UIImage.jpegData(compressionQuality: 1)
                    let data = try! JSONEncoder().encode(imageData)
                    thumbailImageData = data
                    group.leave()
                    print("save data")
                
                }
                
                group.wait(timeout: .now() + .seconds(2))
                
                newUrl.thumbailUrl = thumbailImageData
                
                do {
                    try viewContext.save()
                    print("url guardada")
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }

                print("guardar")
                
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
                
                
            }
            
            

            


        }
        
        
    }
}

//struct AddUrlView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddUrlView(
//    }
//}
