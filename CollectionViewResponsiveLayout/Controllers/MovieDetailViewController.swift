//
//  MovieDetailViewController.swift
//  CollectionViewResponsiveLayout
//
//  Created by Alfian Losari on 08/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

class MovieDetailViewController: UIHostingController<MovieDetail> {
    
    init(view: MovieDetail, movie: Movie) {
        super.init(rootView: view)
        title = movie.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissTapped(_:)))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
