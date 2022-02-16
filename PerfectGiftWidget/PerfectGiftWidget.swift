//
//  PerfectGiftWidget.swift
//  PerfectGiftWidget
//
//  Created by pablo millan lopez on 9/2/22.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
        
        let entry = SimpleEntry(date: Date(),configuration: configuration)
        
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
}

struct PerfectGiftWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    var body: some View {
        GeometryReader{ geometry in
                switch family{
                case .systemSmall:

                    basicFrame(indFav: 0, geometry: geometry, divisorWidht: CGFloat(1.2), divisorHeight: CGFloat(1.2))
                case .systemMedium:
                    HStack(alignment: .center){
                        Spacer()
                        basicFrame(indFav: 0, geometry: geometry, divisorWidht: CGFloat(1.2), divisorHeight: CGFloat(3))
                        basicFrame(indFav: 1, geometry: geometry, divisorWidht: CGFloat(1.2), divisorHeight: CGFloat(3))
                       // basicFrame(indFav: 2, geometry: geometry, divisorWidht: CGFloat(1.6), divisorHeight: CGFloat(4))
                        Spacer()
                    }
                case .systemLarge:
                    VStack(alignment: .center){
                        Spacer()
                        HStack(alignment: .center){
                            Spacer()
                            basicFrame(indFav: 0, geometry: geometry, divisorWidht: CGFloat(2.7), divisorHeight: CGFloat(3))
                            basicFrame(indFav: 1, geometry: geometry, divisorWidht: CGFloat(2.7), divisorHeight: CGFloat(3))
                            //basicFrame(indFav: 2, geometry: geometry, divisorWidht: CGFloat(3), divisorHeight: CGFloat(4))
                            Spacer()
                        }
                        HStack(alignment: .center){
                            Spacer()
                            basicFrame(indFav: 2, geometry: geometry, divisorWidht: CGFloat(2.7), divisorHeight: CGFloat(3))
                            basicFrame(indFav: 3, geometry: geometry, divisorWidht: CGFloat(2.7), divisorHeight: CGFloat(3))
                            //basicFrame(indFav: 2, geometry: geometry, divisorWidht: CGFloat(3), divisorHeight: CGFloat(4))
                            Spacer()
                        }
                        Spacer()
                    }
                case .systemExtraLarge:
                    Text("extra large")
    
    
                @unknown default:
                    fatalError()
                }
            
        }.background(AngularGradient(gradient: Gradient(colors: [.purple,.white,.yellow,.purple,.white,.pink]), center: .topLeading))
        .onAppear {

            
            
        }

        
    }
}

@main
struct PerfectGiftWidget: Widget {
    let kind: String = "PerfectGiftWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PerfectGiftWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct basicFrame:View{
    
    
    @State var upcomingDays = 180
    @State var nameFav = "no name"
    @State var imageFav = UIImage(imageLiteralResourceName: "logoPerfectgift")
    
    var indFav: Int
    var geometry: GeometryProxy
    var divisorWidht: CGFloat
    var divisorHeight: CGFloat

    var body: some View{
        VStack(alignment: .center){
            Spacer()
            HStack{
                Spacer()
                
                imageCircle(divisor: divisorWidht, width: geometry.size.width / divisorHeight, height: geometry.size.height, image: imageFav, upcomingDays: upcomingDays)

                Spacer()
            }
            Spacer()
        }.padding(1)
            .onAppear {
                imageFav = HelperWidget.getImageFav(indFav: indFav)
                let uuidFav = HelperWidget.getIdProfileFav(indFav:indFav)
                let dateEvent = HelperWidget.getUpcomingEventDate(idProfile: uuidFav)
                upcomingDays = HelperWidget.calcularDiasQueFaltanWidget(dateEvent: dateEvent)
            }

    }
}

struct imageCircle: View{
    var divisor: CGFloat
    var width: CGFloat
    var height: CGFloat
    var image: UIImage
    var upcomingDays: Int
    
    var body: some View{
        
        ZStack{
            Image(uiImage: image)
                .resizable()
                .frame(width: width, height: height / divisor)
                .cornerRadius(29)
                .scaledToFit()
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(getColorBorder(days: upcomingDays), lineWidth: 8)
                )
                .shadow(color: .gray, radius: 2, x: 1.8, y: 2.8)
            
            VStack{
                Spacer()
                Text("\(upcomingDays) Days")
                    .foregroundColor(.black)
                    .font(.custom("marker Felt", size: 18))
                    
                    .padding(.vertical,3)
                    .padding(.horizontal, 5)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.bottom,5)
            }.minimumScaleFactor(0.3)

        
        }
            
    }
    
    func getColorBorder(days: Int)-> Color{
        if days >= 183{
            return Color.green
        }
        else if days < 183 && days > 93{
            return Color.yellow
        }
        else if days <= 93{
            return Color.red
        }
        return Color.orange
    }
    
}

struct PerfectGiftWidget_Previews: PreviewProvider {
    static var previews: some View {
        PerfectGiftWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
