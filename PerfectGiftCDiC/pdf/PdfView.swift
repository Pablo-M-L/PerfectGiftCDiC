//
//  PdfView.swift
//  PerfectGiftCDiC
//
//  Created by pablo millan lopez on 6/3/22.
//

import SwiftUI
import PDFKit

struct PdfView: View {
    @State private var indicePdfActivo = 0
    let arrayIdiomas = ["EN","ES"]
    
    let fileUrles = Bundle.main.url(forResource: "IntruccionesPerfectGiftES", withExtension: "pdf")!
    let fileUrlen = Bundle.main.url(forResource: "IntruccionesPerfectGiftEN", withExtension: "pdf")!
    
    var body: some View {
        VStack{
            switch indicePdfActivo{
            case 0:
                PDFKitRepresentedView(fileUrlen)
            case 1:
                PDFKitRepresentedView(fileUrles)
            default:
                PDFKitRepresentedView(fileUrles)
            }
            
            Picker(NSLocalizedString("idioma", comment: ""), selection: $indicePdfActivo){
                ForEach(0..<arrayIdiomas.count){ index in
                    Text(arrayIdiomas[index]).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
            .background(Color("background2").opacity(0.5))
            .cornerRadius(10.0)
        }
    }
}


struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}

struct PdfView_Previews: PreviewProvider {
    static var previews: some View {
        PdfView()
    }
}
