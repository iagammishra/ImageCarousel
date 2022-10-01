//
//  CarouselCell.swift
//  Carousel
//
//  Created by Agam Mishra on 01/10/22.
//

import UIKit

class CarouselCell: UICollectionViewCell {

    @IBOutlet weak var imgView: ImageLoader!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTheme()
    }

    func setTheme() {
        self.imgView.backgroundColor = .black
        self.imgView.image = UIImage(named: "placeholder")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.setTheme()
    }
}
