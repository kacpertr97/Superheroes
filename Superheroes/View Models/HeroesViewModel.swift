//
//  HeroesViewModel.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 18/03/2022.

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
                .subscribe(onNext: { result in
                    if case let .failure(error) = result, let err = error as? ErrorType {
                        self.status.performAction(with: .error(err.returnMessage))
                    } else if case let .success(hero) = result {
                        guard let fetchImg = Webservices.fetchImg(url: hero.image.url) else { return }
                        fetchImg
                            .observe(on: MainScheduler.instance)
                            .subscribe(onNext: { imgData in
                                var hero = hero
                                hero.imageData = imgData
                                self.heroList.accept(self.heroList.value + [hero])
                                let result = CoreDataServices.saveDataToCoreData(hero: hero)
                                if case let .failure(err) = result, let err = err as? ErrorType {
                                    self.status.error.onNext(err.returnMessage)
                                }
                            }, onError: { err in
                                self.status.performAction(with: .error(err.localizedDescription))
                            }) ~ self.disposeBag
                    }
                }, onError: { err in
                    self.status.performAction(with: .error(err.localizedDescription))
                }) ~ self.disposeBag
        }) ~ disposeBag

        moreBindings()
    }

    func moreBindings() {
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

        status.save.subscribe(onNext: { [weak self] hero in
            let result = CoreDataServices.saveDataToCoreData(hero: hero)
            if case let .failure(error) = result, let err = error as? ErrorType {
                self?.status.performAction(with: .error(err.returnMessage))
            }
        }) ~ disposeBag

        status.read.subscribe(onNext: {
            CoreDataServices.readDataFromCoreData().subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if case let .failure(err) = result, let error = err as? ErrorType {
                    print(error.returnMessage)
                } else if case let .success(heroes) = result {
                    self.heroList.accept(heroes)
                }
            }).disposed(by: self.disposeBag)
        }) ~ disposeBag
    }
}

struct Status {

    let clearAction = PublishSubject<Void>()
    let removeHero = PublishSubject<Int>()
    let save = PublishSubject<HeroModel>()
    let read = PublishSubject<Void>()
    let error = PublishSubject<String>()

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
        case .error(let err):
            error.onNext(err)
        }
    }
}

enum Action {
    case clearHeroes
    case removeHero(Int)
    case save(hero: HeroModel)
    case read
    case error(String)
}
