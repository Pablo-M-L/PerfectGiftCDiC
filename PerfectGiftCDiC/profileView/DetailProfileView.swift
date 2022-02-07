//
//  DetailProfileView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 7/7/21.
//

import SwiftUI
import Combine

struct DetailProfileView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var helper: ViewModel
    
    var profile: Profile
    
    
    @State private var nameProfile = "vacio"
    @State private var annotationsProfile = "vacio"
    @State private var mostrarImagePicker = false
    @State private var imageDone = false
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    @State private var vistaActiva: vistaActiva = .ideas
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            //bloque de datos del profile
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
                                        .overlay(Circle().stroke(.white, lineWidth: 3))
                                        .padding(.bottom, 3)
                                        .onReceive(Just(imageDone)) { done in
                                            if done{
                                                saveChangesProfile()
                                            }
                                        }
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
                            ImagePicker(selectedImage: self.$imgServicio, selectedImageDone: $imageDone)
                        }
                    }
                    
                    //nombre y anotaciones
                    VStack(alignment: .leading){
                        
                        TextFieldProfile(hint: "Name Profile", dataString: $nameProfile)
                            //onReceive detecta cambio en la variable nameProfile, si hay cambio llama a la funcion de guardar en BD.
                            //tambien se compara con el string "vacio" que es el valor inicial, porque detectaba el cambio en la variable
                            //al abrir la pantalla, y guardaba en la BD el valor "vacio", borrando el dato correcto.
                            .onReceive(Just(nameProfile)){ value in
                                if value != "vacio" && value != profile.nameProfile{
                                    saveChangesProfile()
                                }
                            }
                        TextFieldProfile(hint: "Info", dataString: $annotationsProfile)
                            .onReceive(Just(nameProfile)){ value in
                                if value != "vacio" && value != profile.annotationsProfile{
                                    saveChangesProfile()
                                }
                            }
                    }

                    
                }.padding([.horizontal, .top], 10)
                
                
                if vistaActiva == .ideas{
                    IdeasListView(profile: profile)
                        .colorMultiply(Color("background"))
                        .edgesIgnoringSafeArea(.all)
                }
                else if vistaActiva == .eventos{
                    EventsListView(filter: profile.nameProfile ?? "nadie", profile: profile)
                        .colorMultiply(Color("background"))
                        .edgesIgnoringSafeArea(.all)
                }
                else if vistaActiva == .regalados{
                    ListGiftDoitView(profile: profile)
                        .colorMultiply(Color("background"))
                        .edgesIgnoringSafeArea(.all)
                }

                
                VStack{
                    HStack(alignment: .center, spacing: 50){
                        Button(action:{
                            withAnimation {
                                vistaActiva = .ideas
                            }
                            
                        },label:{
                            SelecctViewListButtonStyle(vistaActiva: $vistaActiva, texto: "Ideas")
                        })
                        
                        Button(action:{
                            withAnimation {
                                vistaActiva = .eventos
                            }
                        },label:{
                            SelecctViewListButtonStyle(vistaActiva: $vistaActiva, texto: "Events")
                        })
                        
                        Button(action:{
                            withAnimation {
                                vistaActiva = .regalados
                            }
                        },label:{
                            SelecctViewListButtonStyle(vistaActiva: $vistaActiva, texto: "Gifts")
                        })
                        
                        
                    }.padding(.bottom,35)
                        
                }.frame( height: 25)
                
            }
            
            
            
            
            
        }.onAppear{
            setupAppearance()
            helper.currentProfile = profile
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
        .navigationTitle(nameProfile == "" ? "Name" : nameProfile )
    }
    
    func setupAppearance() {
        //setea los colores de los puntos y el fondo de los indicadores del tabview
      UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("colorTextoTitulo"))
      UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    //funcion que guarda el nombre, anotaciones e imagen del perfil.
    func saveChangesProfile(){
        withAnimation{
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
        
       // presentationMode.wrappedValue.dismiss()

    }
}

enum vistaActiva: String{
    case ideas = "Ideas"
    case eventos = "Events"
    case regalados = "Gifts"
}
struct TextFieldProfile: View{
    var hint: String
    @Binding var dataString: String
    
    var body: some View{
        TextField(hint, text: $dataString)
            .padding([.vertical, .leading],5)
            .lineLimit(1)
            .background(Color(.white))
            .font(.custom("marker Felt", size: 18))
            .cornerRadius(8)
    }
}

struct SelecctViewListButtonStyle:View{
    @Binding var vistaActiva: vistaActiva
    var texto: String
    
    var body: some View{
        ZStack(alignment: .center){
            Spacer()
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(vistaActiva.rawValue == texto ? Color("background3") : Color("backgroundButton"))
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
            Text(texto)
                .padding(5)
                .foregroundColor(Color("colorTextoTitulo"))
                .font(.custom("marker felt", size: 18))
        }.frame(width: UIScreen.main.bounds.width / 4.5, height: 35)
    }
    
}


//struct DetailProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailProfileView(profile: Profile())
//    }
//}
