//
//  HomeViewController.swift
//  MovieApp
//
//  Created by User on 16.08.2024.
//

import UIKit

enum Sections: Int {
    case TrendingMovies
    case Popular
    case TrendingTv
    case UpcomingMovies
    case TopRated
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    private let sectionTitles: [String] = ["Trending Movies", "Popular", "Trending TV", "Upcoming Movies", "Top Rated"]
    
    private var trendingMovies: [Title] = []
    private var popularMovies: [Title] = []
    private var trendingTvs: [Title] = []
    private var upcomingMovies: [Title] = []
    private var topRatedMovies: [Title] = []
    
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.reuseIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        fetchData()
        configureHeroHeaderUIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        adjustTableViewOffset()
    }
    
    func configureHeroHeaderUIView() {
        ApiCaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                guard let titleName = selectedTitle?.original_title else { return }
                guard let posterURL = selectedTitle?.poster_path else { return }
                self?.headerView?.configure(with: TitleViewModel(titleName: titleName, posterURL: posterURL))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func  adjustTableViewOffset() {
        let scrollView = UIScrollView()
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y:min(0, -offset))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        homeFeedTable.backgroundColor = .black
    }
    
    func configureNavBar() {
        let image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        let customBarButton = UIBarButtonItem(customView: button)
        customBarButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        customBarButton.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        customBarButton.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true

        self.navigationItem.setLeftBarButton(customBarButton, animated: true)
            
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(didTapHeartButton))
        ]
        
        navigationController?.navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
               appearance.configureWithTransparentBackground()
               navigationController?.navigationBar.standardAppearance = appearance
               navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func didTapHeartButton() {
        DispatchQueue.main.async {
            let vc = FavouriteViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        ApiCaller.shared.getTrendingMovies { [weak self] result in
            defer { dispatchGroup.leave() }
            self?.handleResult(result, for: .TrendingMovies)
        }
        
        dispatchGroup.enter()
        ApiCaller.shared.popularMovies { [weak self] result in
            defer { dispatchGroup.leave() }
            self?.handleResult(result, for: .Popular)
        }
        
        dispatchGroup.enter()
        ApiCaller.shared.getTrendingTvs { [weak self] result in
            defer { dispatchGroup.leave() }
            self?.handleResult(result, for: .TrendingTv)
        }
        
        dispatchGroup.enter()
        ApiCaller.shared.upcomingMovies { [weak self] result in
            defer { dispatchGroup.leave() }
            self?.handleResult(result, for: .UpcomingMovies)
        }
        
        dispatchGroup.enter()
        ApiCaller.shared.topRatedMovies { [weak self] result in
            defer { dispatchGroup.leave() }
            self?.handleResult(result, for: .TopRated)
        }

        dispatchGroup.notify(queue: .main) {
            self.homeFeedTable.reloadData()
        }
    }

    private func handleResult(_ result: Result<[Title], Error>, for section: Sections) {
        switch result {
        case .success(let titles):
            switch section {
            case .TrendingMovies:
                self.trendingMovies = titles
            case .Popular:
                self.popularMovies = titles
            case .TrendingTv:
                self.trendingTvs = titles
            case .UpcomingMovies:
                self.upcomingMovies = titles
            case .TopRated:
                self.topRatedMovies = titles
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.reuseIdentifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            cell.configure(with: trendingMovies)
        case Sections.Popular.rawValue:
            cell.configure(with: popularMovies)
        case Sections.TrendingTv.rawValue:
            cell.configure(with: trendingTvs)
        case Sections.UpcomingMovies.rawValue:
            cell.configure(with: upcomingMovies)
        case Sections.TopRated.rawValue:
            cell.configure(with: topRatedMovies)
        default:
            break
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = sectionTitles[section]
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.lowercased().capitalized
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y:min(0, -offset))
                
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//class HomeViewController: UIViewController {
//
//    private let sectionTitles: [String] = ["Trending Movies", "Popular", "Trending TV", "Upcoming movies", "Top rated"]
//
//    private let homeFeedTable: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.reuseIdentifier)
//        tableView.showsVerticalScrollIndicator = false
//        tableView.separatorStyle = .none
//        return tableView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .black
//        view.addSubview(homeFeedTable)
//
//        homeFeedTable.delegate = self
//        homeFeedTable.dataSource = self
//
//        configureNavBar()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        homeFeedTable.frame = view.bounds
//        homeFeedTable.backgroundColor = .black
//
//        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
//        homeFeedTable.tableHeaderView = headerView
//    }
//
//    func configureNavBar() {
//
//        let image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
//        let button = UIButton(type: .custom)
//        button.setImage(image, for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
//
//        let customBarButton = UIBarButtonItem(customView: button)
//        customBarButton.customView?.translatesAutoresizingMaskIntoConstraints = false
//        customBarButton.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        customBarButton.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
//
//        // Устанавливаем этот кастомный элемент как левую кнопку в навигационном баре
//        self.navigationItem.setLeftBarButton(customBarButton, animated: true)
//
//        navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
//            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
//        ]
//
//        navigationController?.navigationBar.tintColor = .white
//    }
//
//}
//
//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sectionTitles.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.reuseIdentifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
//
//        switch indexPath.section {
//        case Sections.TrendingMovies.rawValue:
//            ApiCaller.shared.getTrendingMovies { result in
//                switch result {
//                case .success(let titles):
//                    cell.configure(with: titles)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        case Sections.Popular.rawValue:
//            ApiCaller.shared.popularMovies { result in
//                switch result {
//                case .success(let titles):
//                    cell.configure(with: titles)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        case Sections.TrendingTv.rawValue:
//            ApiCaller.shared.getTrendingTvs { result in
//                switch result {
//                case .success(let titles):
//                    cell.configure(with: titles)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        case Sections.UpcomingMovies.rawValue:
//            ApiCaller.shared.upcomingMovies { result in
//                switch result {
//                case .success(let titles):
//                    cell.configure(with: titles)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        case Sections.TopRated.rawValue:
//            ApiCaller.shared.topRatedMovies { result in
//                switch result {
//                case .success(let titles):
//                    cell.configure(with: titles)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        default:
//            return UITableViewCell()
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitles[section]
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else { return }
////        var config = header.defaultContentConfiguration()
////        config.text = sectionTitles[section].lowercased()
////        config.textProperties.color = .white
////        config.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
////        config.textToSecondaryTextHorizontalPadding = 20  // Добавление отступа текста
////        header.contentConfiguration = config
//        header.textLabel?.text = sectionTitles[section]
//        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        header.textLabel?.textColor = .white
//        header.textLabel?.text = header.textLabel?.text?.lowercased().capitalized
//        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//
//        navigationController?.navigationBar.transform = .init(translationX: 0, y:min(0, -offset))
//    }
//}
