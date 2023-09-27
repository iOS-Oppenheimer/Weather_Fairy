import Foundation

class SearchPageVM {

    // 도시 검색 메서드
    func searchLocation(for cityName: String, completion: @escaping (Result<(String, String, Double, Double), Error>) -> Void) {
        // 한글 도시 이름을 URL 인코딩
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "유효하지 않은 도시 이름입니다.", code: 0, userInfo: nil)))
            return
        }

        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedCityName)&limit=1&appid=\(geoAPIKey)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                        if let firstLocation = json?.first,
                           let lat = firstLocation["lat"] as? Double,
                           let lon = firstLocation["lon"] as? Double,
                           let localNames = firstLocation["local_names"] as? [String: String],
                           let koreanName = localNames["ko"],
                           let englishName = firstLocation["name"] as? String {
                            completion(.success((englishName, koreanName, lat, lon)))
                        } else {
                            completion(.failure(NSError(domain: "유효하지 않은 JSON 요청입니다.", code: 0, userInfo: nil)))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}
