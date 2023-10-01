import Foundation

class SearchHistory {
    var searchHistory: [Location] = []
    
    init() {
        loadSearchHistory()
    }
    
    private func saveSearchHistory() {

        if searchHistory.count > 7 {
            searchHistory.removeLast(searchHistory.count - 7)
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(searchHistory) {
            UserDefaults.standard.set(encoded, forKey: "SearchHistory")
        }
    }
    
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

        searchHistory = searchHistory.filter { $0.engName != location.engName }

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
