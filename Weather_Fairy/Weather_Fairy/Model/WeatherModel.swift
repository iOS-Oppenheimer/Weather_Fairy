import Foundation

struct WeatherModel: Codable {
    // 좌표 정보
    struct Coordinate: Codable {
        let lon: Double // 경도
        let lat: Double // 위도
    }
    
    // 날씨 정보
    struct WeatherInfo: Codable {
        let id: Int // 날씨 상태 ID
        let main: String // 날씨 상태
        let description: String // 날씨 설명
        let icon: String // 날씨 아이콘 식별자
    }
    
    // 기본 정보
    struct MainInfo: Codable {
        let temp: Double // 현재 온도
        let feels_like: Double // 체감 온도
        let temp_min: Double // 최소 온도
        let temp_max: Double // 최대 온도
        let pressure: Int // 기압
        let humidity: Int // 습도
        let sea_level: Int? // 해수면 기압 (일부 지역에서만 제공)
        let grnd_level: Int? // 지면 기압 (일부 지역에서만 제공)
    }
    
    // 바람 정보
    struct WindInfo: Codable {
        let speed: Double // 바람 속도 (m/s)
        let deg: Int // 바람 방향 (도)
        let gust: Double? // 돌풍 속도 (m/s) - 일부 지역에서만 제공
    }
    
    // 구름 정보
    struct CloudsInfo: Codable {
        let all: Int // 구름 밀도 (0-100)
    }
    
    // 시스템 정보
    struct SystemInfo: Codable {
        let type: Int? // 내부 파라미터 (옵셔널)
        let id: Int? // 내부 파라미터 (옵셔널)
        let country: String // 국가 코드
        let sunrise: TimeInterval? // 일출 시간 (Unix 타임스탬프, 옵셔널)
        let sunset: TimeInterval? // 일몰 시간 (Unix 타임스탬프, 옵셔널)
    }
    
    let coord: Coordinate // 좌표 정보
    let weather: [WeatherInfo] // 날씨 정보 배열
    let base: String // 기상 데이터 원본 정보
    let main: MainInfo // 기본 정보
    let visibility: Int // 가시성 (미터)
    let wind: WindInfo // 바람 정보
    let clouds: CloudsInfo // 구름 정보
    let dt: TimeInterval // 데이터 시간 (Unix 타임스탬프)
    let sys: SystemInfo? // 시스템 정보 (옵셔널)
    let timezone: Int // 시간대
    let id: Int // 도시 ID
    let name: String // 도시 이름
    let cod: Int? // 상태 코드 (옵셔널)
}
