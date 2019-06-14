//
//  MovieListCollectionViewCell.swift
//  CollectionViewResponsiveLayout
//
//  Created by Alfian Losari on 2/8/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit

class MovieLayoutListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    private var imageURL: URL?
    
    override func prepareForReuse() {
        self.posterImageView.image = nil
    }
    
    func setup(with movie: Movie) {
        self.imageURL = movie.posterURL
        movieTitleLabel.text = movie.title
        movieDescriptionLabel.text = "\(movie.voteAveragePercentText) - \(movie.yearText)"
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
