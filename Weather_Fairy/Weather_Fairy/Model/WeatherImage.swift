import UIKit

class WeatherImage {
    func getImage(id: Int) -> UIImage? {
        if 200...232 ~= id {
            // Thunderstorm
            return UIImage(named: "thunderstorm.png")
        } else if 300...321 ~= id {
            // Drizzle
            return UIImage(named: "drizzle.jpeg")
        } else if 500...531 ~= id {
            // Rain
            return UIImage(named: "rain.png")
        } else if 600...622 ~= id {
            // Snow
            return UIImage(named: "snow.jpeg")
        } else if 701...771 ~= id {
            // Mist, Smoke, Haze, Dust, Fog, Sand, Ash, Squall
            return UIImage(named: "mist.jpeg")
        } else if 781 == id {
            // Tornado
            return UIImage(named: "tornado.jpeg")
        } else if 800 == id {
            // Clear
            return UIImage(named: "clear.jpeg")
        } else {
            // Clouds
            return UIImage(named: "clouds.jpeg")
        }
    }
}
