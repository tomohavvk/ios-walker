
struct LocationDTO: Codable {
  var latitude: Double
  var longitude: Double
  var accuracy: Double
  var speed: Double
  var time: Int64
  var altitude: Double?
  var altitudeAccuracy: Double?
  var bearing: Double?
  var simulated: Bool?
}
