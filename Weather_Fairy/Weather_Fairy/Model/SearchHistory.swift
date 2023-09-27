import Foundation

struct SearchHistory {
    private var history: [Location] = []
    private let maxHistoryCount = 7 // 최대 검색 기록 개수

    // 현재 검색 기록 반환
    var currentHistory: [Location] {
        return history
    }

    // UserDefaults에서 검색 기록 불러오기
    mutating func loadFromUserDefaults() {
        if let savedHistoryData = UserDefaults.standard.data(forKey: "SearchHistory"),
           let savedHistory = try? JSONDecoder().decode([Location].self, from: savedHistoryData) {
            history = savedHistory
        }
    }

    // UserDefaults에 검색 기록 저장하기
    private func saveToUserDefaults() {
        if let encodedHistory = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encodedHistory, forKey: "SearchHistory")
        }
    }

    // 검색 기록에 검색어 추가
    mutating func addSearch(_ location: Location) {
        // 중복 검색어 제거
        history = history.filter { $0.name != location.name }

        // 최대 검색 기록 개수 제한
        if history.count >= maxHistoryCount {
            history.removeFirst()
        }

        // 검색어를 검색 기록에 추가
        history.append(location)

        // UserDefaults에 저장
        saveToUserDefaults()
    }

    // 검색 기록 초기화
    mutating func clearHistory() {
        history.removeAll()

        // UserDefaults에서도 초기화
        UserDefaults.standard.removeObject(forKey: "SearchHistory")
    }
}
