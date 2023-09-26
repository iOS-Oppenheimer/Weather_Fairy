import Foundation

struct Location: Codable {
    let name: String // 도시 영어 이름
    let koreanName: String // 도시 한글 이름
    let lat: Double // 위도
    let lon: Double // 경도
}
