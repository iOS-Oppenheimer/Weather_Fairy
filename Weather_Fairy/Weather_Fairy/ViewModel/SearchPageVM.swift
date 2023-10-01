import Foundation

class SearchPageVM {
    // 도시 검색 메서드

    func searchLocation(for cityName: String, completion: @escaping (Result<[(String, String, Double, Double)], APIError>) -> Void) {
        // 한글 도시 이름을 URL 인코딩
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.noCityName))
            return
        }

        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedCityName)&limit=5&appid=\(geoAPIKey)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(.failedRequest))
                    return
                }

                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]

                        var cities: [(String, String, Double, Double)] = []

                        for location in json ?? [] {
                            if let lat = location["lat"] as? Double,
                               let lon = location["lon"] as? Double,
                               let localNames = location["local_names"] as? [String: String],
                               let koreanName = localNames["ko"],
                               let englishName = location["name"] as? String
                            {
                                cities.append((englishName, koreanName, lat, lon))
                            }
                        }

                        if !cities.isEmpty {
                            completion(.success(cities))
                        } else {
                            completion(.failure(.noCityName))
                        }
                    } catch {
                        completion(.failure(.invalidData))
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<(String, String, Int, Int, Int, String), Error>) -> Void) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(geoAPIKey)&units=metric&lang=kr"

        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "유효하지 않은 URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "데이터 없음", code: 0, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)

                // 원하는 정보 추출
                var weatherInfo: (String, String, Int, Int, Int, String) = ("", "", 0, 0, 0, "")

                if let weather = weatherData.weather {
                    let weatherMain = weather.main
                    let weatherIcon = weather.icon ?? "No Icon"
                    weatherInfo.0 = weatherMain
                    weatherInfo.1 = weatherIcon
                }

                if let main = weatherData.main {
                    let temperature = Int(main.temp)
                    let tempMin = Int(main.temp_min)
                    let tempMax = Int(main.temp_max)
                    weatherInfo.2 = temperature
                    weatherInfo.3 = tempMin
                    weatherInfo.4 = tempMax
                }

                let currentTime = Date(timeIntervalSince1970: TimeInterval(weatherData.dt))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedTime = dateFormatter.string(from: currentTime)
                weatherInfo.5 = formattedTime

                completion(.success(weatherInfo))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }


    
}

