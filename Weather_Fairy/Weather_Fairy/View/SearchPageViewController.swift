import UIKit
import SwiftUI
import SnapKit

class SearchPageViewController: UIViewController, UISearchBarDelegate {
    
    private let viewModel = SearchPageViewModel()
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
        
        // searchBar 추가
        view.addSubview(searchBar)
        
        // tableView 추가
        view.addSubview(tableView)
        
        // SnapKit을 사용하여 레이아웃 설정
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom) // searchBar 아래에 위치
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        
    }
    
    // 서치바 검색 시 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            viewModel.searchLocations(for: searchText) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let coordinates):
                        self?.searchResults = coordinates
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("에러: \(error)")
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

        cell.nameLabel.text = result.1
        cell.englishNameLabel.text = result.0
        cell.coordinatesLabel.text = "Lat: \(result.2), Lon: \(result.3)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    typealias UIViewControllerType = UIViewController
}
