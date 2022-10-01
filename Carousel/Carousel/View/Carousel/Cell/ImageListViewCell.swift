//
//  ImageListViewCell.swift
//  Carousel
//
//  Created by Agam Mishra on 01/10/22.
//

import UIKit

class ImageListViewCell: UITableViewCell {

    @IBOutlet weak var imgView: ImageLoader!
    @IBOutlet weak var descriptionLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTheme()
    }

    func setTheme() {
        self.imgView.backgroundColor = .black
        self.imgView.contentMode = .scaleAspectFit
        self.imgView.image = UIImage(named: "placeholder")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.setTheme()
    }
}
