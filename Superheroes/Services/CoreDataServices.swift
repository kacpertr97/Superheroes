//
//  CoreDataServices.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 21/03/2022.
//  swiftlint:disable all

import Foundation
import CoreData
import UIKit
import RxSwift

enum CoreDataServices {

    static func saveDataToCoreData(hero: HeroModel) -> Result<Void> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return Result.failure(ErrorType.errorSavingData) }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HeroCoreData",
                                                in: managedContext)!

        let heroObject = NSManagedObject(entity: entity, insertInto: managedContext)

        heroObject.setValue(hero.appearance.weight.first, forKey: "weight")
        heroObject.setValue(hero.powerstats.intelligence, forKey: "intStat")
        heroObject.setValue(hero.powerstats.strength, forKey: "strStat")
        heroObject.setValue(hero.powerstats.speed, forKey: "spdStat")
        heroObject.setValue(hero.connections.relatives, forKey: "relatives")
        heroObject.setValue(hero.appearance.race, forKey: "race")
        heroObject.setValue(hero.powerstats.power, forKey: "pwrStat")
        heroObject.setValue(hero.biography.publisher, forKey: "publisher")
        heroObject.setValue(hero.biography.placeOfBirth, forKey: "placeOfBirth")
        heroObject.setValue(hero.work.occupation, forKey: "occupation")
        heroObject.setValue(hero.image.url, forKey: "imgUrl")
        heroObject.setValue(hero.imageData, forKey: "imgData")
        heroObject.setValue(hero.name, forKey: "heroName")
        heroObject.setValue(hero.id, forKey: "heroID")
        heroObject.setValue(hero.biography.fullName, forKey: "heroFullName")
        heroObject.setValue(hero.appearance.height.first, forKey: "height")
        heroObject.setValue(hero.appearance.hairColor, forKey: "hairColor")
        heroObject.setValue(hero.connections.groupAffiliation, forKey: "groupAffiliation")
        heroObject.setValue(hero.appearance.gender, forKey: "gender")
        heroObject.setValue(hero.biography.firstAppearance, forKey: "firstAppearance")
        heroObject.setValue(hero.appearance.eyeColor, forKey: "eyeColor")
        heroObject.setValue(hero.powerstats.durability, forKey: "drbStat")
        heroObject.setValue(hero.powerstats.combat, forKey: "cmtStat")
        heroObject.setValue(hero.work.base, forKey: "base")
        heroObject.setValue(hero.biography.alterEgos, forKey: "alterEgos")
        heroObject.setValue(hero.biography.alignment, forKey: "alignment")
        heroObject.setValue(hero.biography.aliases.joined(separator: ", "), forKey: "aliases")
        do {
            try managedContext.save()
        } catch {
            return Result.failure(ErrorType.errorSavingData)
        }

        return Result.success(())
    }

    static func readDataFromCoreData() -> Observable<Result<[HeroModel]>> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return Observable.just(Result.failure(ErrorType.errorFetchingData))}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HeroCoreData")
        var heroesToReturn = [HeroModel]()
        do {
            let heroes = try managedContext.fetch(fetchRequest)
            heroes.forEach({ hero in
                let aliases = hero.value(forKey: "aliases") as! String
                let aliasesArray = aliases.components(separatedBy: ", ")
                let height = hero.value(forKey: "height") as! String
                let heightArray = [height]
                let weight = hero.value(forKey: "weight") as! String
                let weightArray = [weight]
                let heroToAppend = HeroModel(response: "From core data",
                                             id: hero.value(forKey: "heroID") as! String,
                                             name: hero.value(forKey: "heroName") as! String,
                                             powerstats: Powerstats(intelligence: hero.value(forKey: "intStat") as! String,
                                                                    strength: hero.value(forKey: "strStat") as! String,
                                                                    speed: hero.value(forKey: "spdStat") as! String,
                                                                    durability: hero.value(forKey: "drbStat") as! String,
                                                                    power: hero.value(forKey: "pwrStat") as! String,
                                                                    combat: hero.value(forKey: "cmtStat") as! String),
                                             biography: Biography(fullName: hero.value(forKey: "heroFullName") as! String,
                                                                  alterEgos: hero.value(forKey: "alterEgos") as! String,
                                                                  aliases: aliasesArray ,
                                                                  placeOfBirth: hero.value(forKey: "placeOfBirth") as! String,
                                                                  firstAppearance: hero.value(forKey: "firstAppearance") as! String,
                                                                  publisher: hero.value(forKey: "publisher") as! String,
                                                                  alignment: hero.value(forKey: "alignment") as! String),
                                             appearance: Appearance(gender: hero.value(forKey: "gender") as! String,
                                                                    race: hero.value(forKey: "race") as! String,
                                                                    height: heightArray,
                                                                    weight: weightArray,
                                                                    eyeColor: hero.value(forKey: "eyeColor") as! String,
                                                                    hairColor: hero.value(forKey: "hairColor") as! String),
                                             work: Work(occupation: hero.value(forKey: "occupation") as! String,
                                                        base: hero.value(forKey: "base") as! String),
                                             connections: Connections(groupAffiliation: hero.value(forKey: "groupAffiliation") as! String,
                                                                      relatives: hero.value(forKey: "relatives") as! String),
                                             image: Image(url: hero.value(forKey: "imgUrl") as! String),
                                             imageData: hero.value(forKey: "imgData") as? Data)
                heroesToReturn.append(heroToAppend)
            })
        } catch {
           return Observable.just(Result.failure(ErrorType.errorFetchingData))
        }
        return Observable.just(Result.success(heroesToReturn))
    }

    static func clearCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HeroCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    static func removeSingleHero(heroName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<HeroCoreData>(entityName: "HeroCoreData")
        do {
            let heroes = try managedContext.fetch(fetchRequest)
            for hero in heroes where hero.value(forKey: "heroName") as! String == heroName {
                managedContext.delete(hero)
            }
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

}
