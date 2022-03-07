//
//  AddProfileView.swift
//  PerfectGiftCDiC
//
//  Created by pablo on 5/7/21.
//

import SwiftUI
import CloudKit
import CoreData

struct AddProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var nameProfile = ""
    @State private var annotationsProfile = ""
    @State private var mostrarImagePicker = false
    @State private var imageDone = false
    @State private var imgServicio = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    var body: some View {
        ZStack{
            
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical){
                
                VStack{
                    
                    //boton cambiar imagen y toggle
                    HStack{
                        Spacer()
                        
                        Button(action:{
                            self.mostrarImagePicker.toggle()
                        },label:{
                            VStack{
                                if let uiImage = imgServicio{
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(20)
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 3))
                                        .padding(.bottom, 3)
                                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                }
                                else{
                                    Image(systemName: "person")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(20)
                                        .frame(width: 100, height: 100)
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 3))
                                        .padding(.bottom, 3)
                                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                }
                                
                                HStack(alignment: .center){
                                    Text(NSLocalizedString("changeImage", comment: ""))
                                }
                            }
                        })
                            .sheet(isPresented: $mostrarImagePicker){
                                ImagePicker(selectedImage: self.$imgServicio, selectedImageDone: $imageDone)
                            }
                        
                        Spacer()
                        
                    }.padding(.trailing, 7)
                    
                    VStack{
                        Text(NSLocalizedString("personName", comment: ""))
                            .foregroundColor(Color("colorTextoTitulo"))
                            .font(.custom("marker Felt", size: 22))
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)

                        TextField(NSLocalizedString("enterPersonName", comment: ""), text: $nameProfile)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(8)
                        
                    }.font(.custom("Marker Felt", size: 18))
                        .padding()
                    
                    VStack{
                        Text(NSLocalizedString("details", comment: ""))
                            .foregroundColor(Color("colorTextoTitulo"))
                            .font(.custom("marker Felt", size: 22))
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                        
                            TextField(NSLocalizedString("details", comment: ""), text: $annotationsProfile)
                            //.multilineTextAlignment(.leading)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(8)
                        
                    }.font(.custom("marker Felt", size: 18))
                        .padding(.horizontal, 10)
                    Spacer()
                    
                    Button(action:{
                        addProfile()
                        presentationMode.wrappedValue.dismiss()
                    },label:{
                        ZStack{
                            Text(NSLocalizedString("addPerson", comment: ""))
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: 50)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .font(.custom("Marker Felt", size: 20))
                                .cornerRadius(25)
                                .padding()
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        }
                    }).padding()
                    
                }
                .navigationTitle(NSLocalizedString("addPersonTit", comment: ""))
            }
        }
    }
    
    
    private func addProfile() {
        withAnimation {
            let newProfile = Profile(context: viewContext)
            newProfile.idProfile = UUID()
            newProfile.annotationsProfile = annotationsProfile
            newProfile.nameProfile = nameProfile
            let imagenUIRedimensionada = resizeImage(image: imgServicio)
            let imageData =  imagenUIRedimensionada.jpegData(compressionQuality: 0.5)
            let data = try! JSONEncoder().encode(imageData)
            newProfile.imageProfile = data
            
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

struct AddProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileView()
    }
}
