import MapKit

class RouteCompressor{

    static func compress(
        coords:[CLLocationCoordinate2D],
        step:Int = 10
    )->[[Double]]{

        var result:[[Double]] = []

        for i in stride(from:0, to:coords.count, by:step){

            let c = coords[i]

            result.append([c.latitude,c.longitude])
        }

        return result
    }
}