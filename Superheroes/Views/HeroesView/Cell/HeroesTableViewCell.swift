//
//  HeroesTableViewCell.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 18/03/2022.
//

import UIKit

class HeroesTableViewCell: UITableViewCell {

    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroFullNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func cellSetup(heroImage: Data?, heroName: String, heroFullName: String) {
        heroImg.layer.cornerRadius = 25.0
        if let heroImage = heroImage {
            heroImg.image = UIImage(data: heroImage)
        }
        heroNameLabel.text = heroName
        heroFullNameLabel.text = heroFullName
    }

}
