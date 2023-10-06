
import Foundation

class MainViewModel {
    private var apiViewModel = APIViewModel()
    
    // 현재 날씨 데이터를 가져와서 가공한 후 반환
    func fetchAndUpdateWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData) -> Void) {
        apiViewModel.mainFetchWeatherData(latitude: latitude, longitude: longitude) { data in
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
       
    // 시간대별 날씨 데이터를 가져와서 가공한 후 반환
    func fetchAndUpdateHourlyWeatherData(latitude: Double, longitude: Double, completion: @escaping ([HourlyWeather]) -> Void) {
        apiViewModel.fetchHourlyWeatherData(latitude: latitude, longitude: longitude) { hourlyForecast in
            DispatchQueue.main.async {
                completion(hourlyForecast)
            }
        }
    }
       
    // 일별 날씨 데이터를 가져와서 가공한 후 반환
    func fetchAndUpdateDailyWeatherData(latitude: Double, longitude: Double, completion: @escaping ([DailyWeather]) -> Void) {
        apiViewModel.fetchDailyWeatherData(latitude: latitude, longitude: longitude) { dailyForecast in
            DispatchQueue.main.async {
                completion(dailyForecast)
            }
        }
    }
       
    // 도시 검색 결과를 반환
    func searchLocation(for cityName: String, completion: @escaping (Result<[(String, String, Double, Double)], APIError>) -> Void) {
        apiViewModel.searchLocation(for: cityName, completion: completion)
    }

    // 시간 변환 로직
    func convertTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
