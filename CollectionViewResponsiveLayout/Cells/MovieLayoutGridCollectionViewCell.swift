//
//  MovieGridCollectionViewCell.swift
//  CollectionViewResponsiveLayout
//
//  Created by Alfian Losari on 2/8/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit

class MovieLayoutGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    private var imageURL: URL?
    
    override func prepareForReuse() {
        self.posterImageView.image = nil
    }

    func setup(with movie: Movie) {
        self.imageURL = movie.posterURL
        ImageCache.downloadImage(url: movie.posterURL) { [weak self](result) in
            guard let imageURL = self?.imageURL, movie.posterURL == imageURL else {
                return
            }
            if case let .success(image) = result {
                self?.posterImageView.image = image
            }
        }
        
    }

}
