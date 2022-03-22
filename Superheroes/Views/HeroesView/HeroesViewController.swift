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
        heroesVM.status.performAction(with: .read)
        bindTableView()
        bindError()
    }

    private func setupNavBar() {
        self.title = "Heroes"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Heroes",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(goToAddHeroes))
        self.navigationItem.leftBarButtonItem?.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                                 target: self,
                                                                 action: #selector(deleteHeroes))
        self.navigationItem.rightBarButtonItem?.tintColor = .darkGray
    }

    private func bindTableView() {
        heroesTableView.delegate = self
        heroesTableView.register(UINib(nibName: "HeroesTableViewCell", bundle: nil), forCellReuseIdentifier: "HeroCell")
        heroesVM.heroList.bind(to: heroesTableView.rx.items(cellIdentifier: "HeroCell",
                                                            cellType: HeroesTableViewCell.self)) { _, element, cell in
            cell.cellSetup(heroImage: element.imageData,
                           heroName: element.name,
                           heroFullName: element.biography.fullName)
        } ~ disposeBag

        heroesTableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.heroesVM.lastSelectedCell = index.row
            self.coordinator?.eventOccured(with: .navigateToHeroDetail(self.heroesVM.heroList.value[index.row]))
        }) ~ disposeBag
    }

    @objc func goToAddHeroes() {
        coordinator?.eventOccured(with: .navigateToAddHeroes)
    }

    @objc func deleteHeroes() {
        let alert = UIAlertController(title: "Are you sure you want to delete all heroes?",
                                      message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            self?.heroesVM.status.performAction(with: .clearHeroes)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default))
        self.present(alert, animated: true)
    }

    func bindError() {
        heroesVM.status.error.subscribe(onNext: { err in
            let alert = UIAlertController(title: "Oops!", message: err, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }) ~ disposeBag
    }

}

extension HeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, _ in
            self?.heroesVM.status.performAction(with: .removeHero(indexPath.row))
        }
        action.backgroundColor = .systemBackground
        action.image = UIImage(systemName: "trash")?.colored(in: .red)
        let swipe = UISwipeActionsConfiguration(actions: [action])
        return swipe
    }
}
