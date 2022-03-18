//
//  AddHeroViewModel.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 15/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxBinding

class AddHeroViewModel {
    let heroList = BehaviorRelay<[(Int, String)]>(value: FullHeroList.fullHeroList)
    let searchString = PublishSubject<String?>()
    let disposeBag = DisposeBag()
    var selectedHeroes: [(Int, String)] = [(Int, String)]()
}

extension AddHeroViewModel {

    func performVmBindings() {
        searchString.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            guard let text = value else { return }
            self.heroList.accept(self.filterheroList(text: text))
        }) ~ disposeBag
    }
}

extension AddHeroViewModel {

    func filterheroList(text: String) -> [(Int, String)] {
        if text == "" {
            return FullHeroList.fullHeroList
        } else {
            let filteredList = FullHeroList.fullHeroList.filter { _, heroName in
                heroName.lowercased().contains(text.lowercased())
            }
            return filteredList
        }
    }
}
