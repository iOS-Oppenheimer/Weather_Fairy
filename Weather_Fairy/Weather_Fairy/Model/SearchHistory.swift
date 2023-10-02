import Foundation

class SearchHistory {
    var searchHistory: [Location] = []
    
    init() {
        loadSearchHistory()
    }
    
    private func saveSearchHistory() {
        // 7개 이하까지만 저장
        if searchHistory.count > 7 {
            searchHistory.removeLast(searchHistory.count - 7)
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(searchHistory) {
            UserDefaults.standard.set(encoded, forKey: "SearchHistory")
        }
    }
    // 검색기록 UserDefaultes에 저장
    private func loadSearchHistory() {
        if let data = UserDefaults.standard.data(forKey: "SearchHistory") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Location].self, from: data) {
                searchHistory = decoded
            }
        }
    }
    
    // 검색 기록 추가
    func addLocationToHistory(_ location: Location) {
        // 이미 저장된 도시 삭제
        searchHistory = searchHistory.filter { $0.engName != location.engName }
        // 새로운 검색 기록 맨 앞에 추가
        searchHistory.insert(location, at: 0)
        saveSearchHistory()
    }
    
    // 검색 기록 비우는 메서드
    func clearSearchHistory() {
        searchHistory.removeAll()
        saveSearchHistory()
    }

    func getSearchHistory() -> [Location] {
        return searchHistory
    }
}
