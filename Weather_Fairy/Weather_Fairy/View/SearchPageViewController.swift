import SnapKit
import SwiftUI
import UIKit

class SearchPageViewController: UIViewController, UISearchBarDelegate {
    
    private let viewModel = SearchPageVM()
    private var searchHistory = SearchHistory()
    private var searchResults: [(String, String, Double, Double)] = []
    
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
    }
    
    func setupUI() {
        let backgroundColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0)
        view.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.tintColor = .black
        
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
    
    // 서치바 검색 시 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            viewModel.searchLocation(for: searchText) { [weak self] result in
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
}

// 테이블뷰 Delegate, DataSource 설정
extension SearchPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPageTableViewCell.identifier, for: indexPath) as! SearchPageTableViewCell
        
        let result = searchResults[indexPath.row]
        
        cell.setLocationData(data: result)
        cell.showLoadingSpinner()
        
        viewModel.fetchWeatherData(lat: result.2, lon: result.3) { result in
            switch result {
            case .success(let weatherInfo):
                DispatchQueue.main.async {
                    cell.hideLoadingSpinner()
                    cell.setWeatherData(weatherInfo: weatherInfo)
                    cell.configure()
                    print(weatherInfo)
                }
            case .failure(let error):
                print("날씨 정보를 가져오는 데 실패했습니다: \(error)")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        
        let mainVC = MainViewController()
        mainVC.cityEngName = selectedResult.0
        mainVC.cityKorName = selectedResult.1
        mainVC.cityLat = selectedResult.2
        mainVC.cityLon = selectedResult.3
        
        navigationController?.pushViewController(mainVC, animated: true)
    }
}

// SwiftUI를 활용한 미리보기
struct SearchViewController_Previews: PreviewProvider {
    static var previews: some View {
        SearchVCRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}

struct SearchVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let searchViewController = SearchPageViewController()
        return UINavigationController(rootViewController: searchViewController)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    typealias UIViewControllerType = UIViewController
}
