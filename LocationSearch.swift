import MapKit

class LocationSearch {

    static func search(_ text:String,
                       completion:@escaping(CLLocationCoordinate2D?)->Void){

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text

        let search = MKLocalSearch(request:request)

        search.start { response, error in

            guard let item = response?.mapItems.first else {

                completion(nil)
                return
            }

            completion(item.placemark.coordinate)
        }
    }
}