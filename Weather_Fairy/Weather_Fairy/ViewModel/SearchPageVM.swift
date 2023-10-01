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

    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (Result<(String, String, Int, Int, Int, String), Error>) -> Void) {
        // API 키와 좌표를 이용해 URL 생성
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(geoAPIKey)&units=metric&lang=kr"
        
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
                let weatherData = try decoder.decode(WeatherModel.self, from: data)
                
                // 원하는 정보 추출
                let weatherInfo: (String, String, Int, Int, Int, String) = (
                    weatherData.weather.first?.main ?? "",
                    weatherData.weather.first?.icon ?? "아이콘 없음",
                    Int(weatherData.main.temp),
                    Int(weatherData.main.temp_min),
                    Int(weatherData.main.temp_max),
                    DateFormat.formattedTime(from: weatherData.dt)
                )
                
                completion(.success(weatherInfo))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }




    
}

