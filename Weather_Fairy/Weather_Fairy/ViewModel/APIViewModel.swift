import Foundation

class APIViewModel {
    
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
                if error != nil {
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

    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (Result<(Int, String, String, Int, Int, Int, String), Error>) -> Void) {
        // API 키와 좌표를 이용해 URL 생성
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(geoAPIKey)&units=metric&lang=kr"
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "유효하지 않은 URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
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

                if let timezoneOffset = weatherData.timezone as? Int {
                    let adjustedTimezoneOffset = timezoneOffset - 32400
                    let timezone = TimeZone(secondsFromGMT: adjustedTimezoneOffset)
                    let currentUTCDate = Date()

                    var calendar = Calendar(identifier: .gregorian)
                    calendar.timeZone = timezone ?? TimeZone.current
                    if let currentDateInCity = calendar.date(byAdding: .second, value: Int(adjustedTimezoneOffset), to: currentUTCDate) {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
                        dateFormatter.timeZone = timezone
                        let formattedDate = dateFormatter.string(from: currentDateInCity)

                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "hh:mm a"
                        let currentFormattedTime = timeFormatter.string(from: currentDateInCity)

                        let weatherInfo: (Int, String, String, Int, Int, Int, String) = (
                            weatherData.weather.first?.id ?? 0,
                            weatherData.weather.first?.description ?? "",
                            weatherData.weather.first?.icon ?? "아이콘 없음",
                            Int(Double(weatherData.main.temp).rounded()),
                            Int(Double(weatherData.main.temp_min).rounded()),
                            Int(Double(weatherData.main.temp_max).rounded()),
                            currentFormattedTime
                        )
                        completion(.success(weatherInfo))
                    } else {
                        completion(.failure(NSError(domain: "시간 변환 실패", code: 0, userInfo: nil)))
                    }
                } else {
                    completion(.failure(NSError(domain: "타임존 정보 없음", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func mainFetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData) -> Void) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(geoAPIKey)&units=metric&lang=kr"

        guard let url = URL(string: urlStr) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Failed to fetch data with error: ", error)
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)

                DispatchQueue.main.async {
                    // UI 업데이트 및 배경 이미지 변경
                    completion(weatherData)
                }

            } catch {
                print("Failed to parse JSON with error: ", error)
            }
        }

        task.resume()
    }

    func fetchHourlyWeatherData(latitude: Double, longitude: Double, completion: @escaping ([HourlyWeather]) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(geoAPIKey)&units=metric&lang=kr"

        guard let url = URL(string: urlString) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch data with error: ", error)
                return
            }

            guard let data = data else {
                print("No data returned from the server")
                return
            }

            do {
                let decoder = JSONDecoder()
                let hourlyForecast = try decoder.decode(HourlyForecast.self, from: data)
                print("Hourly Forecast Data: \(hourlyForecast)")
                DispatchQueue.main.async {
                    completion(hourlyForecast.list)
                }
            } catch {
                print("Failed to parse JSON with error: ", error)
            }
        }
        task.resume()
    }

    func fetchDailyWeatherData(latitude: Double, longitude: Double, completion: @escaping ([DailyWeather]) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(geoAPIKey)&units=metric&lang=kr&cnt=40"

        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch data with error: ", error)
                return
            }

            guard let data = data else {
                print("No data returned from the server")
                return
            }

            do {
                let decoder = JSONDecoder()
                let dailyForecast = try decoder.decode(DailyForecast.self, from: data)
                DispatchQueue.main.async {
                    completion(dailyForecast.list)
                }
            } catch {
                print("Failed to parse JSON with error: ", error)
            }
        }

        task.resume()
    }
}
