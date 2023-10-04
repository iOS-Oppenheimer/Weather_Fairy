import UIKit
import SwiftUI
import SnapKit

class SearchPageViewController: UIViewController, UISearchBarDelegate {
    
    private let apiViewModel = APIViewModel()
    private let searchPageViewModel = SearchPageViewModel()
    private var searchResults: [(String, String, Double, Double)] = []
    private let searchHistory = SearchHistory()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "도시 또는 공항 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(SearchPageTableViewCell.self, forCellReuseIdentifier: "SearchPageTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displaySearchHistory()
        setupNavigationBar()

        
    }
  
    // 네비게이션 바 설정 및 삭제 버튼 추가
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteSearchHistory(_:)))
        navigationItem.rightBarButtonItem = deleteButton
        
        // 검색 기록이 비어 있는 경우 삭제 버튼 비활성화
        if searchHistory.getSearchHistory().isEmpty {
            deleteButton.isEnabled = false
        }
    }

    func setupUI() {
        let backgroundColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0)
        view.backgroundColor = backgroundColor

        
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // 서치바가 비어있는 경우 검색 기록을 표시
            displaySearchHistory()
        } else {
            apiViewModel.searchLocation(for: searchText) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let coordinates):
                        self?.searchResults = coordinates
                        self?.tableView.reloadData()
                    case .failure(let error):
                        switch error {
                        case .noCityName:
                            print("에러: 유효하지 않은 도시 이름입니다.")
                        case .noData:
                            print("에러: 데이터가 없습니다.")
                        case .invalidJSON:
                            print("에러: JSON 파싱 에러입니다.")
                        case .failedRequest:
                            print("에러: 요청에 실패하였습니다.")
                        case .invalidData:
                            print("에러: 검색어와 일치하는 도시가 없습니다.")
                        case .failedResponse:
                            print("에러: 응답을 받을 수 없습니다.")
                        case .invalidResponse:
                            print("에러: 응답이 유효하지 않습니다.")
                        }
                    }
                }
            }
        }
    }
    
    // 검색 기록 표시
    func displaySearchHistory() {
        let searchHistory = SearchHistory().getSearchHistory()

        // 검색 기록이 있을 때만 테이블뷰에 출력
        if !searchHistory.isEmpty {
            searchResults = searchHistory.map { ($0.engName, $0.korName, $0.lat, $0.lon) }
        } else {
            // 검색 기록이 없을 때는 검색 결과 초기화
            searchResults = []
        }

        tableView.reloadData()
    }
    
    // 검색 기록 삭제 버튼 메서드
    @objc func deleteSearchHistory(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "검색 기록 삭제", message: "검색 기록을 모두 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            // 검색 기록 삭제
            SearchHistory().clearSearchHistory()
            // 검색 결과 초기화
            self?.searchResults = []
            self?.tableView.reloadData()
            // 삭제 버튼 비활성화
            sender.isEnabled = false
        }))
        present(alert, animated: true, completion: nil)
    }
    

}

// 테이블뷰 Delegate, DataSource 설정
extension SearchPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPageTableViewCell.identifier, for: indexPath) as! SearchPageTableViewCell
        
        if searchResults.isEmpty {
            // 검색 결과가 없는 경우, 검색 기록 표시
            let searchHistory = SearchHistory().getSearchHistory()
            if indexPath.row < searchHistory.count {
                let location = searchHistory[indexPath.row]
                cell.setLocationData(data: (location.engName, location.korName, location.lat, location.lon))
                cell.hideLoadingSpinner()
                cell.configure()
            }
        } else {
            // 검색 결과가 있는 경우, 검색 결과 표시
            let result = searchResults[indexPath.row]
            cell.setLocationData(data: result)
            cell.showLoadingSpinner()
            
            
            apiViewModel.fetchWeatherData(latitude: result.2, longitude: result.3) { result in
                switch result {
                case .success(let weatherInfo):
                    DispatchQueue.main.async {
                        let data = self.searchPageViewModel.convertWeatherData(data: weatherInfo)
                        let timeData = self.searchPageViewModel.convertTime(data: weatherInfo)
                        cell.weatherData = weatherInfo
                        cell.hideLoadingSpinner()
                        cell.setWeatherData(data: data, timeData: timeData ?? "")
                        cell.configure()
                    }
                case .failure(let error):
                    print("날씨 정보를 가져오는 데 실패했습니다: \(error)")
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchPageTableViewCell {
            let selectedResult = searchResults[indexPath.row]
            addToSearchHistory(Location(engName: selectedResult.0, korName: selectedResult.1, lat: selectedResult.2, lon: selectedResult.3))
            
            let mainVC = MainViewController()
            mainVC.cityEngName = selectedResult.0
            mainVC.cityKorName = selectedResult.1
            mainVC.cityLat = selectedResult.2
            mainVC.cityLon = selectedResult.3
            mainVC.currentWeatherData = cell.weatherData
            
            navigationController?.setViewControllers([mainVC], animated: true)
        }
    }
    
    func addToSearchHistory(_ location: Location) {
        searchHistory.addLocationToHistory(location)
    }
}
