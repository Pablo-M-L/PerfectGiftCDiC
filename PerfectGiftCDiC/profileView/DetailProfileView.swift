//
//  DetailProfileView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 7/7/21.
//

import SwiftUI

struct DetailProfileView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State var profile: Profile
    @State private var nameProfile = ""
    @State private var annotationsProfile = ""
    @State private var mostrarImagePicker = false
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    //boton cambiar imagen y toggle
                    HStack{
                        Button(action:{
                            self.mostrarImagePicker.toggle()
                        },label:{
                            VStack{
                                if let uiImage = imgServicio{
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .padding(.bottom, 3)
                                }
                                else{
                                    Image(systemName: "person")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .padding(.bottom, 3)
                                }
                            }
                            .shadow(color: .gray, radius: 3, x: 2, y: 2)
                        })
                        .sheet(isPresented: $mostrarImagePicker){
                            ImagePicker(selectedImage: self.$imgServicio)
                        }
                    }
                    
                    VStack(alignment: .leading){
                        
                        TextFieldProfile(hint: "Name Profile", dataString: $nameProfile)
                        TextFieldProfile(hint: "Info", dataString: $annotationsProfile)
                    }
                    
                }.padding([.horizontal, .top], 10)
                
                EventsListView(filter: profile.nameProfile ?? "nadie")
                
                Spacer()
            }
            
            
            
            VStack{
                
                Spacer()
                //boton añadir evento
                HStack{
                    
                    Spacer()
                    
                    NavigationLink(destination: AddEventView(profile: profile), label: {
                        ZStack{
                            Circle()
                                .foregroundColor(.blue)
                            Image(systemName: "calendar.badge.plus")
                                .resizable()
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .padding(8)
                            
                            
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                    })
                }
            }
            
            
            
        }.onAppear{
            nameProfile = profile.nameProfile ?? "sin nombre"
            annotationsProfile = profile.annotationsProfile ?? ""
            if profile.imageProfile == nil{
                imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
            }
            else{
                let imgData = profile.imageProfile
                let data = try! JSONDecoder().decode(Data.self, from: imgData!)
                imgServicio = UIImage(data: data)!
            }
        }
        .onDisappear{
            saveChangesProfile()
        }
        .navigationTitle(nameProfile)
    }
    
    func saveChangesProfile(){
        profile.nameProfile = nameProfile
        profile.annotationsProfile = annotationsProfile
        let imagenUIRedimensionada = resizeImage(image: imgServicio)
        let imageData =  imagenUIRedimensionada.jpegData(compressionQuality: 0.5)
        let data = try! JSONEncoder().encode(imageData)
        profile.imageProfile = data
        
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

struct TextFieldProfile: View{
    var hint: String
    @Binding var dataString: String
    
    var body: some View{
        TextField(hint, text: $dataString)
            .padding([.vertical, .leading],5)
            .lineLimit(1)
            .background(Color(.white))
            .font(.custom("marker Felt", size: 12))
            .cornerRadius(8)
    }
}

struct DetailProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DetailProfileView(profile: Profile())
    }
}
