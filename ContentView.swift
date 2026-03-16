import SwiftUI
import MapKit

struct Stop: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct ContentView: View {

    @StateObject var ble = BLEManager()

    @State private var startText = ""
    @State private var destinationText = ""

    @State private var stops:[Stop] = []

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude:10.782, longitude:106.698),
        span: MKCoordinateSpan(latitudeDelta:0.02, longitudeDelta:0.02)
    )

    @State private var routePolyline: MKPolyline?

    var body: some View {

        VStack(spacing:10){

            VStack{

                TextField("Start location", text:$startText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Destination", text:$destinationText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Add Stop"){

                    let stop = Stop(
                        name:"Stop",
                        coordinate:CLLocationCoordinate2D(latitude:10.784, longitude:106.701)
                    )

                    stops.append(stop)
                }

                ForEach(stops){ stop in
                    Text(stop.name)
                }

            }
            .padding()

            MapView(
                region:$region,
                routePolyline:$routePolyline
            )
            .frame(height:400)

            Button(action: {

                sendRouteToDisplay()

            }){

                Text("Push To Display")
                    .font(.headline)
                    .frame(maxWidth:.infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)

            }
            .padding()

        }
    }

    func sendRouteToDisplay(){

        guard let polyline = routePolyline else { return }

        var points:[[Double]] = []

        let coords = polyline.coordinates

        for c in coords {
            points.append([c.latitude,c.longitude])
        }

        ble.sendRoute(points:points)
    }
}
