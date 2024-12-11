//
//  FavouriteViewController.swift
//  MovieApp
//
//  Created by User on 28.08.2024.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    private var titles: [TitleItemFavourite] = [TitleItemFavourite]()
    
    private let favouriteTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        title = "Favourite"
        
        view.addSubview(favouriteTable)
        configureNavBarForUpcomingAndSearch()
        
        favouriteTable.delegate = self
        favouriteTable.dataSource = self
        
        fetchLocalStorageForFavourite()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("favourite"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForFavourite()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favouriteTable.frame = view.bounds
    }
    
    private func fetchLocalStorageForFavourite() {
        DataPersistanceManager.shared.fetchingFavouriteTitleFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                
                DispatchQueue.main.async {
                    self?.favouriteTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        cell.config(with: TitleViewModel(titleName: title.original_title ?? "Unknown", posterURL: title.poster_path ?? ""))
        cell.backgroundColor = .black
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        guard let titleOverview = title.overview else { return }
        
        ApiCaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(youtubeVideo: videoElement, title: titleName, overview: titleOverview, rate: title.vote_average ))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    let alert = UIAlertController(title: "Oops", message: "We don't have this movie data.. Try again later..", preferredStyle: .alert)
                    alert.addAction(.init(title: "Ok", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistanceManager.shared.deleteFavouriteTitleFromDatabaseWith(with: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success(let success):
                    print("Delete from database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
}
