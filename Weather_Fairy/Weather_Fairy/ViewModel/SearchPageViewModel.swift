import Foundation

class SearchPageViewModel {
    
    func convertWeatherData(data: WeatherData) -> [String] {
        var weatherInfo: [String] = []
        
        
        let temperature = "\(Int(Double(data.main.temp)))°C"
        let tempMin = "\(Int(Double(data.main.temp_min)))°C"
        let tempMax = "\(Int(Double(data.main.temp_max)))°C"
        let description = data.weather.first?.description ?? "N/A"
        let weatherId = "\(String(describing: data.weather.first?.id))"
        let weatherIcon = "\(String(describing: data.weather.first?.icon))"
        
        weatherInfo.append(temperature)
        weatherInfo.append(tempMin)
        weatherInfo.append(tempMax)
        weatherInfo.append(description)
        weatherInfo.append(weatherId)
        weatherInfo.append(weatherIcon)
        
        return weatherInfo
    }
    
    func convertTime(data: WeatherData) -> String? {
        let timezoneOffset = data.timezone
        let adjustedTimezoneOffset = timezoneOffset - 32400
        let timezone = TimeZone(secondsFromGMT: adjustedTimezoneOffset)
        let currentUTCDate = Date()
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timezone ?? TimeZone.current
        if let currentDateInCity = calendar.date(byAdding: .second, value: Int(adjustedTimezoneOffset), to: currentUTCDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
            dateFormatter.timeZone = timezone
            _ = dateFormatter.string(from: currentDateInCity)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let currentFormattedTime = timeFormatter.string(from: currentDateInCity)
            
            return currentFormattedTime
        }
        
        return nil
    }


}
