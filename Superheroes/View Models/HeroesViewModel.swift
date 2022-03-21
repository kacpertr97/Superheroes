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
    private let disposeBag = DisposeBag()
    let heroesToAdd = PublishSubject<Int>()
    let heroList = BehaviorRelay<[HeroModel]>(value: [])
    let status = Status()
    var lastSelectedCell: Int?
}

extension HeroesViewModel {

    func performBindings() {
        heroesToAdd.subscribe(onNext: { [weak self] heroID in
            guard let self = self else { return }
            guard let url = URL(string: "https://www.superheroapi.com/api.php/6781182295287025/\(heroID)")
            else { return }
            let resource = Resource<HeroModel>(url: url)
            Webservices.fetchData(resource: resource)
                .subscribe(onNext: { hero in
                guard let fetchImg = Webservices.fetchImg(url: hero.image.url) else { return }
                fetchImg
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { imgData in
                    var hero = hero
                    hero.imageData = imgData
                    self.heroList.accept(self.heroList.value + [hero])
                    self.status.performAction(with: .save(hero: hero))
                }) ~ self.disposeBag
            }) ~ self.disposeBag
        }) ~ disposeBag

        status.clearAction
            .subscribe(onNext: { [weak self] _ in
                self?.heroList.accept([])
                CoreDataServices.clearCoreData()
            }) ~ disposeBag

        status.removeHero.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            var heroes = self.heroList.value
            CoreDataServices.removeSingleHero(heroName: heroes[index].name)
            heroes.remove(at: index)
            self.heroList.accept(heroes)
        }) ~ disposeBag

        status.save.subscribe(onNext: { hero in
            CoreDataServices.saveDataToCoreData(hero: hero)
        }) ~ disposeBag

        status.read.subscribe(onNext: {
            CoreDataServices.readDataFromCoreData()?.subscribe(onNext: { [weak self] heroes in
                guard let self = self else { return }
                self.heroList.accept(heroes)
            }).disposed(by: self.disposeBag)
        }) ~ disposeBag

    }
}

struct Status {

    let clearAction = PublishSubject<Void>()
    let removeHero = PublishSubject<Int>()
    let save = PublishSubject<HeroModel>()
    let read = PublishSubject<Void>()

    func performAction(with action: Action) {
        switch action {
        case .clearHeroes:
            clearAction.onNext(())
        case .removeHero(let index):
            removeHero.onNext(index)
        case .save(let hero):
            save.onNext((hero))
        case .read:
            read.onNext(())
        }
    }
}

enum Action {
    case clearHeroes
    case removeHero(Int)
    case save(hero: HeroModel)
    case read
}
