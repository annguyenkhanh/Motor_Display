import MapKit

class RouteService {

    static func calculateRoute(
        start:CLLocationCoordinate2D,
        end:CLLocationCoordinate2D,
        completion:@escaping([MKRoute])->Void
    ){

        let request = MKDirections.Request()

        request.source = MKMapItem(
            placemark:MKPlacemark(coordinate:start)
        )

        request.destination = MKMapItem(
            placemark:MKPlacemark(coordinate:end)
        )

        request.requestsAlternateRoutes = true

        let direction = MKDirections(request:request)

        direction.calculate { response, error in

            guard let routes = response?.routes else {

                completion([])
                return
            }

            completion(routes)
        }
    }
}