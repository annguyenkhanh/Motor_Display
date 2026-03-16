import SwiftUI
import MapKit

struct ContentView: View {

    @StateObject var ble = BLEManager()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 10.782,
            longitude: 106.698
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )

    var body: some View {

        VStack {

            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.top)

            Button(action: {

                let route = [
                    [10.782,106.698],
                    [10.783,106.700],
                    [10.784,106.702],
                    [10.785,106.704]
                ]

                ble.sendRoute(points: route)

            }) {

                Text("Send Route To Display")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

        }
    }
}