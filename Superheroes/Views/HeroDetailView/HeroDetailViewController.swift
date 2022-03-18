//
//  HeroDetailViewController.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 18/03/2022.
//

import UIKit

class HeroDetailViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?

    var hero: HeroModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = hero?.name
    }
}
