import Foundation

struct HourlyForecast: Decodable {
    let list: [HourlyWeather]
}

struct HourlyWeather: Decodable {
    let main: HourlyMain
    let dt_txt: String
    let weather: [Weather]
}

struct HourlyMain: Decodable {
    let temp: Double
}

struct DailyForecast: Decodable {
    let list: [DailyWeather]
}

struct DailyWeather: Decodable {
    let main: DailyMain
    let dt_txt: String
    let weather: [Weather]
}

struct DailyMain: Decodable {
    let temp: Double
}

struct WeatherData: Decodable {
    let main: MainInfo
    let sys: Sys
    let wind: Wind
    let weather: [Weather]
    let timezone: Int
}

struct MainInfo: Decodable {
    let temp: Double
    let humidity: Int
    let temp_min: Double
    let temp_max: Double
}

struct Sys: Decodable {
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct Wind: Decodable {
    let speed: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
    let icon: String

}
