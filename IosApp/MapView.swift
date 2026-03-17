import SwiftUI
import MapKit

struct MapView:UIViewRepresentable{

    var routes:[MKRoute]

    @Binding var selected:Int?

    func makeUIView(context:Context)->MKMapView{

        let map = MKMapView()

        map.delegate = context.coordinator

        let tap = UITapGestureRecognizer(
            target:context.coordinator,
            action:#selector(Coordinator.tapMap(_:))
        )

        map.addGestureRecognizer(tap)

        return map
    }

    func updateUIView(_ map:MKMapView, context:Context){

        map.removeOverlays(map.overlays)

        for (index,route) in routes.enumerated(){

            map.addOverlay(route.polyline)

            context.coordinator.routes = routes
            context.coordinator.selected = $selected
        }
    }

    func makeCoordinator()->Coordinator{

        Coordinator()
    }

    class Coordinator:NSObject,MKMapViewDelegate{

        var routes:[MKRoute] = []

        var selected:Binding<Int?>?

        func mapView(_ mapView:MKMapView,
                     rendererFor overlay:MKOverlay)->MKOverlayRenderer{

            guard let poly = overlay as? MKPolyline else {

                return MKOverlayRenderer()
            }

            let renderer = MKPolylineRenderer(polyline:poly)

            renderer.lineWidth = 6

            renderer.strokeColor = .gray

            return renderer
        }

        @objc func tapMap(_ gesture:UITapGestureRecognizer){

            let map = gesture.view as! MKMapView

            let point = gesture.location(in:map)

            let coord = map.convert(point,toCoordinateFrom:map)

            var closest = 0
            var bestDistance = Double.infinity

            for (i,route) in routes.enumerated(){

                let first = route.polyline.coordinates.first!

                let d = hypot(first.latitude-coord.latitude,
                              first.longitude-coord.longitude)

                if d < bestDistance{

                    bestDistance = d
                    closest = i
                }
            }

            selected?.wrappedValue = closest
        }
    }
}