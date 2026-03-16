import MapKit

enum TurnType:String {

    case left
    case right
    case straight
    case uturn
    case unknown
}

struct TurnInstruction {

    var lat:Double
    var lon:Double
    var type:TurnType
}

class TurnExtractor {

    static func extract(route:MKRoute)->[TurnInstruction] {

        var instructions:[TurnInstruction] = []

        for step in route.steps {

            let text = step.instructions.lowercased()

            var type:TurnType = .straight

            if text.contains("left") {
                type = .left
            }
            else if text.contains("right") {
                type = .right
            }
            else if text.contains("u-turn") {
                type = .uturn
            }

            let coord = step.polyline.coordinates.first ?? CLLocationCoordinate2D()

            let turn = TurnInstruction(
                lat:coord.latitude,
                lon:coord.longitude,
                type:type
            )

            instructions.append(turn)
        }

        return instructions
    }
}