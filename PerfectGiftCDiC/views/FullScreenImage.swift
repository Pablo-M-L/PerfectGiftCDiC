//
//  FullScreenImage.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 16/2/22.
//

import SwiftUI

struct FullScreenImage: View {
    @Binding var image: UIImage
    @State var showPickerImage = false
    
    
    var body: some View {
        ZStack{
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.gray)
                    .frame(width: 150, height: 10)
                    .padding(.top,50)
                Image(systemName: "arrow.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            VStack{
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    .padding(30)
                    .onTapGesture{
                        showPickerImage = true
                        }
                    .sheet(isPresented: $showPickerImage){
                        ImagePicker(selectedImage: $image, selectedImageDone: $showPickerImage)
                    }
                Text("Tap to Change")
                    .font(.footnote)
            }
        }
        
    }
}

//struct FullScreenImage_Previews: PreviewProvider {
//    static var previews: some View {
//        FullScreenImage()
//    }
//}
