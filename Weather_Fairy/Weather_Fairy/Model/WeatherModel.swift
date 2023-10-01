import Foundation

struct WeatherData: Codable {
    struct Coordinate: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct WeatherInfo: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct MainInfo: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
        let sea_level: Int?
        let grnd_level: Int?
    }
    
    struct WindInfo: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    
    struct CloudsInfo: Codable {
        let all: Int
    }
    
    struct SystemInfo: Codable {
        let type: Int
        let id: Int?
        let country: String
        let sunrise: TimeInterval?
        let sunset: TimeInterval?
    }
    
    let coord: Coordinate
    let weather: [WeatherInfo]
    let base: String
    let main: MainInfo
    let visibility: Int
    let wind: WindInfo
    let clouds: CloudsInfo
    let dt: TimeInterval
    let sys: SystemInfo
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
