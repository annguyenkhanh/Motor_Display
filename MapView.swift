import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion
    @Binding var routePolyline: MKPolyline?

    func makeUIView(context:Context)->MKMapView{

        let map = MKMapView()

        map.setRegion(region, animated:false)

        return map
    }

    func updateUIView(_ map:MKMapView, context:Context){

        map.removeOverlays(map.overlays)

        if let route = routePolyline {

            map.addOverlay(route)
        }

        map.delegate = context.coordinator
    }

    func makeCoordinator()->Coordinator{
        Coordinator()
    }

    class Coordinator:NSObject, MKMapViewDelegate{

        func mapView(_ mapView:MKMapView,
                     rendererFor overlay:MKOverlay)->MKOverlayRenderer{

            if let polyline = overlay as? MKPolyline {

                let renderer = MKPolylineRenderer(polyline:polyline)

                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 5

                return renderer
            }

            return MKOverlayRenderer()
        }
    }
}
