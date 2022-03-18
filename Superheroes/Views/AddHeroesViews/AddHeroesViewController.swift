//
//  AddHeroesViewController.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 15/03/2022.
//  swiftlint:disable line_length

import UIKit
import RxSwift
import RxCocoa
import RxBinding

class AddHeroesViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?

    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var addHeroesTableView: UITableView!

    let addHeroesVM = AddHeroViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        bindTableView()
        bindSearchBar()
        addHeroesVM.performVmBindings()
    }

    func setupNavBar() {
        self.title = "Add Heroes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(goToHeroesAndAddHeroes))
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }

    func bindTableView() {
        addHeroesTableView.register(UINib(nibName: "AddHeroesTableViewCell", bundle: nil),
                                    forCellReuseIdentifier: "AddHeroesCell")
        addHeroesVM.heroList.bind(to: addHeroesTableView.rx.items(cellIdentifier: "AddHeroesCell",
                                                                cellType: AddHeroesTableViewCell.self)) { _, element, cell in
            cell.setupCell(heroName: element.1)
            cell.setSelected(heroes: self.addHeroesVM.selectedHeroes)
        } ~ disposeBag
        cellSelection()
    }

    func cellSelection() {
        addHeroesTableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            guard let cell = self.addHeroesTableView.cellForRow(at: index) as? AddHeroesTableViewCell
            else { return }
            if cell.heroIsSelected {
                self.addHeroesVM.selectedHeroes.removeAll { _, heroName in
                    if let name = cell.heroNameLabel.text {
                        if heroName == name { return true }
                    }
                    return false
                }
            } else {
                self.addHeroesVM.selectedHeroes.append(self.addHeroesVM.heroList.value[index.row])
            }
            cell.setSelected(heroes: self.addHeroesVM.selectedHeroes)
        }) ~ disposeBag
    }

    func bindSearchBar() {
        searchField.rx.text ~> addHeroesVM.searchString ~ disposeBag
    }

    @objc func goToHeroesAndAddHeroes() {
        let idList: [Int] = addHeroesVM.selectedHeroes.map { heroID, _ in
            return heroID
        }
        coordinator?.eventOccured(with: .goToHeroesAndAddHeroes(idList))
    }
}
