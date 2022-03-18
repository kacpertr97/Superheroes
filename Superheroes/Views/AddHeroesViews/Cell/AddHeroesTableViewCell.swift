//
//  AddHeroesTableViewCell.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 17/03/2022.
//

import UIKit

class AddHeroesTableViewCell: UITableViewCell {

    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var checkmark: UIImageView!

    var heroIsSelected: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(heroName: String) {
        heroNameLabel.text = heroName
    }

    func setSelected(heroes: [(Int, String)]) {
        guard let heroName = heroNameLabel.text else { return }
        if heroes.contains(where: { _, name in
            name == heroName
        }) {
            heroIsSelected = true
        } else {
            heroIsSelected = false
        }
        showCheckmark()
    }

    func showCheckmark() {
        if heroIsSelected {
            checkmark.isHidden = false
        } else {
            checkmark.isHidden = true
        }
    }
}
