//
//  HeroesViewModel.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 18/03/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxBinding

class HeroesViewModel {
    let disposeBag = DisposeBag()
    let heroesToAdd = PublishSubject<Int>()
    let heroList = BehaviorRelay<[HeroModel]>(value: [])

}

extension HeroesViewModel {

    func performBindings() {
        heroesToAdd.subscribe(onNext: { [weak self] heroID in
            guard let self = self else { return }
            guard let url = URL(string: "https://www.superheroapi.com/api.php/6781182295287025/\(heroID)")
            else { return }
            let resource = Resource<HeroModel>(url: url)
            Webservices.fetchData(resource: resource).subscribe(onNext: { hero in
                guard let fetchImg = Webservices.fetchImg(url: hero.image.url) else { return }
                fetchImg.subscribe(onNext: { imgData in
                    var hero = hero
                    hero.imageData = imgData
                    self.heroList.accept(self.heroList.value + [hero])
                }) ~ self.disposeBag
            }) ~ self.disposeBag
        }) ~ disposeBag
    }
}
