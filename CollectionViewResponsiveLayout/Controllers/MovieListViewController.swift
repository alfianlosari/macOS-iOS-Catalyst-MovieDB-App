//
//  MainListCollectionViewController.swift
//  CollectionViewResponsiveLayout
//
//  Created by Alfian Losari on 2/8/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit

private let listReuseIdentifier = "ListCell"
private let gridReuseIdentifier = "GridCell"

class MovieListViewController: UICollectionViewController {
    
    private let endpoint: Endpoint
    private let movieService: MovieService
    
    private var movies = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var layoutOption: LayoutOption = .list {
        didSet {
            setupLayout(with: view.bounds.size)
        }
    }
    
    init(endpoint: Endpoint, movieService: MovieService) {
        self.endpoint = endpoint
        self.movieService = movieService
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayoutObserver()
        setupCollectionView()
        setupNavigationBarItem()
        setupLayout(with: view.bounds.size)
        self.loadMovies()
    }
    
    func setupLayoutObserver() {
        NotificationCenter.default.addObserver(forName: layoutChangeNotification, object: nil, queue: nil) {[weak self] (note) in
            guard let userInfo = note.userInfo, let layout = userInfo["layout"] as? LayoutOption else {
                return
            }
            self?.layoutOption = layout
        }
    }
    
    private func loadMovies() {
        movieService.fetchMovies(from: endpoint, params: nil, successHandler: { [weak self](movieResponse) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.movies = movieResponse.results
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupLayout(with: size)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLayout(with: view.bounds.size)
    }
    
    private func setupCollectionView() {
        title = endpoint.description
        collectionView.register(UINib(nibName: "MovieLayoutListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: listReuseIdentifier)
        collectionView.register(UINib(nibName: "MovieLayoutGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: gridReuseIdentifier)
    }
    
    private func setupLayout(with containerSize: CGSize) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        switch layoutOption {
        case .list:
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.sectionInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 8.0, right: 0)
            
            if traitCollection.horizontalSizeClass == .regular {
                let minItemWidth: CGFloat = 300
                let numberOfCell = containerSize.width / minItemWidth
                let width = floor((numberOfCell / floor(numberOfCell)) * minItemWidth)
                flowLayout.itemSize = CGSize(width: width, height: 91)
            } else {
                flowLayout.itemSize = CGSize(width: containerSize.width, height: 91)
            }
            
        case .largeGrid, .smallGrid:
            let minItemWidth: CGFloat
            if layoutOption == .smallGrid {
                minItemWidth = 106
            } else {
                minItemWidth = 160
            }
            
            let numberOfCell = containerSize.width / minItemWidth
            let width = floor((numberOfCell / floor(numberOfCell)) * minItemWidth)
            let height = ceil(width * (4.0 / 3.0))

            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 1
            flowLayout.itemSize = CGSize(width: width, height: height)
            flowLayout.sectionInset = .zero
        }
        
        collectionView.reloadData()
    }
    
    private func setupNavigationBarItem() {
        let barButtonItem = UIBarButtonItem(title: "Layout", style: .plain, target: self, action: #selector(layoutTapped(_:)))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func layoutTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Layout", message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        alertController.addAction(UIAlertAction(title: "List", style: .default, handler: { (_) in
            self.layoutOption = .list
        }))
        
        alertController.addAction(UIAlertAction(title: "Large Grid", style: .default, handler: { (_) in
            self.layoutOption = .largeGrid
        }))
        
        alertController.addAction(UIAlertAction(title: "Small Grid", style: .default, handler: { (_) in
            self.layoutOption = .smallGrid
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}

extension MovieListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutOption {
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listReuseIdentifier, for: indexPath) as! MovieLayoutListCollectionViewCell
            let movie = movies[indexPath.item]
            cell.setup(with: movie)
            return cell
            
        case .largeGrid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridReuseIdentifier, for: indexPath) as! MovieLayoutGridCollectionViewCell
            let movie = movies[indexPath.item]
            cell.setup(with: movie)
            return cell
            
        case .smallGrid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridReuseIdentifier, for: indexPath) as! MovieLayoutGridCollectionViewCell
            let movie = movies[indexPath.item]
            cell.setup(with: movie)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.item]
        let movieItemData = MovieItemData(movieService: movieService, movie: movie)
        let movieDetailVC = MovieDetailViewController(view: MovieDetail(movieData: movieItemData), movie: movie)
        if traitCollection.horizontalSizeClass == .regular {
            let navController = UINavigationController(rootViewController: movieDetailVC)
            movieDetailVC.preferredContentSize = CGSize(width: 450, height: CGFloat.infinity)
            navController.modalPresentationStyle = .formSheet
            present(navController, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
    }
}
