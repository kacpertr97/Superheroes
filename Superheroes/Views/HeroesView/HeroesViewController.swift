//
//  HeroesViewController.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 15/03/2022.
//  API: 6781182295287025

import UIKit
import RxSwift
import RxCocoa
import RxBinding

class HeroesViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    let disposeBag = DisposeBag()
    let heroesVM = HeroesViewModel()

    @IBOutlet weak var heroesTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        heroesVM.performBindings()
        bindTableView()
    }

    func setupNavBar() {
        self.title = "Heroes"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Heroes",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(goToAddHeroes))
        self.navigationItem.leftBarButtonItem?.tintColor = .darkGray
    }

    func bindTableView() {
        heroesTableView.register(UINib(nibName: "HeroesTableViewCell", bundle: nil), forCellReuseIdentifier: "HeroCell")
        heroesVM.heroList.bind(to: heroesTableView.rx.items(cellIdentifier: "HeroCell",
                                                            cellType: HeroesTableViewCell.self)) { _, element, cell in
            cell.cellSetup(heroImage: element.imageData,
                           heroName: element.name,
                           heroFullName: element.biography.fullName)
        } ~ disposeBag
    }

    @objc func goToAddHeroes() {
        coordinator?.eventOccured(with: .navigateToAddHeroes)
    }

}
