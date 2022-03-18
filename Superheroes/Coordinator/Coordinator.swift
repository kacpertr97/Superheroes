//
//  Coordinator.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 15/03/2022.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }

    func eventOccured(with type: Event)
    func start()
}

enum Event {
    case navigateToAddHeroes
    case goToHeroesAndAddHeroes([Int])
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
