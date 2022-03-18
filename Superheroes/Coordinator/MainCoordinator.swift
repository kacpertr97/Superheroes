//
//  mainCoordinator.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 15/03/2022.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {

    var navigationController: UINavigationController?

    func eventOccured(with type: Event) {
        switch type {
        case .navigateToAddHeroes:
            navigateToAddHeroes()
        case .goToHeroesAndAddHeroes(let heroIDs):
            navigateToHeroesWithNewHeroes(heroIDs: heroIDs)
        }
    }

    func start() {
        var viewController: UIViewController & Coordinating = HeroesViewController()
        viewController.coordinator = self
        navigationController?.setViewControllers([viewController], animated: false)
    }

    func navigateToAddHeroes() {
        var viewController: UIViewController & Coordinating = AddHeroesViewController()
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    func navigateToHeroesWithNewHeroes(heroIDs: [Int]) {
        guard let viewController = navigationController?.viewControllers.first as? HeroesViewController else { return }
        for heroID in heroIDs {
            viewController.heroesVM.heroesToAdd.onNext(heroID)
        }
        viewController.coordinator = self
        navigationController?.popToViewController(viewController, animated: true)
    }
}
