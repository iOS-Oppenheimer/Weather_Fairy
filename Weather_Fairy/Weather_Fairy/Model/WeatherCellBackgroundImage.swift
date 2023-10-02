import UIKit

class WeatherCellBackgroundImage {
    func getImage(id: Int) -> UIImage? {
        if 200...232 ~= id {
            // Thunderstorm
            return UIImage(named: "thunderstormCellBG.png")
        } else if 300...321 ~= id {
            // Drizzle
            return UIImage(named: "drizzleCellBG.png")
        } else if 500...531 ~= id {
            // Rain
            return UIImage(named: "rainCellBG.png")
        } else if 600...622 ~= id {
            // Snow
            return UIImage(named: "snowCellBG.png")
        } else if 701...771 ~= id {
            // Mist, Smoke, Haze, Dust, Fog, Sand, Ash, Squall
            return UIImage(named: "mistCellBG.png")
        } else if 781 == id {
            // Tornado
            return UIImage(named: "tornadoCellBG.png")
        } else if 800 == id {
            // Clear
            return UIImage(named: "clearCellBG.png")
        } else {
            // Clouds
            return UIImage(named: "cloudsCellBG.png")
        }
    }
}
