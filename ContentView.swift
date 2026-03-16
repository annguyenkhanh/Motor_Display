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

    func pushRoute(){

        guard let index = selectedRoute else { return }

        let route = routes[index]

        let coords = route.polyline.coordinates

        let compressed = RouteCompressor.compress(coords:coords)

        ble.sendRoute(points:compressed)
    }

    func pushRoute(){

        guard let index = selectedRoute else { return }

        let route = routes[index]

        let coords = route.polyline.coordinates

        let compressed = RouteCompressor.compress(coords:coords)

        let turns = TurnExtractor.extract(route:route)

        var turnJSON:[[String:Any]] = []

        for t in turns {

            turnJSON.append([
                "lat":t.lat,
                "lon":t.lon,
                "type":t.type.rawValue
            ])
        }

        let payload:[String:Any] = [
            "route":compressed,
            "turns":turnJSON
        ]

        ble.sendJSON(payload)
    }
}
