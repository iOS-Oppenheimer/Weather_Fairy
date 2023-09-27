import Foundation

class SearchPageViewModel {


    // 도시 검색 메서드
    func searchLocations(for cityName: String, completion: @escaping (Result<[(String, String, Double, Double)], Error>) -> Void) {
        // 한글 도시 이름을 URL 인코딩
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "유효하지 않은 도시 이름입니다.", code: 0, userInfo: nil)))
            return
        }

        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedCityName)&limit=5&appid=\(APIKeys.geoAPIKey)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
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
                               let englishName = location["name"] as? String {
                                cities.append((englishName, koreanName, lat, lon))
                            }
                        }
                        
                        if !cities.isEmpty {
                            completion(.success(cities))
                        } else {
                            completion(.failure(NSError(domain: "검색 결과가 없습니다.", code: 0, userInfo: nil)))
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

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct SearchPageTableViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            UIViewPreview {
//                let cell = SearchPageTableViewCell()
//                cell.nameLabel.text = "서울"
//                cell.englishNameLabel.text = "Seoul"
//                cell.coordinatesLabel.text = "Lat: 37.5665, Lon: 126.9780"
//                return cell
//            }
//            .previewLayout(.fixed(width: 375, height: 120))
//        }
//    }
//}
//
//struct UIViewPreview<View: UIView>: UIViewRepresentable {
//    let view: View
//
//    init(_ builder: @escaping () -> View) {
//        view = builder()
//    }
//
//    func makeUIView(context: Context) -> UIView { view }
//    func updateUIView(_ view: UIView, context: Context) { }
//}
//
//#endif

