import Foundation

struct DateFormat {
    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    static let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.locale = Locale(identifier: "Ko_kr")
            return formatter
        }()
    
    // Unix 타임스탬프를 원하는 날짜 및 시간 형식으로 변환하는 타입 메서드
    static func formattedTime(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return timeFormatter.string(from: date)
    }
}
