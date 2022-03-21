//
//  HeroDetailViewController.swift
//  Superheroes
//
//  Created by Kacper Trębacz on 18/03/2022.
//

import UIKit

class HeroDetailViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var heroImg: UIImageView!
    // stats:
    @IBOutlet weak var intStat: UILabel!
    @IBOutlet weak var strStat: UILabel!
    @IBOutlet weak var spdStat: UILabel!
    @IBOutlet weak var drbStat: UILabel!
    @IBOutlet weak var pwrStat: UILabel!
    @IBOutlet weak var cmtStat: UILabel!
    // appearance:
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    // biography:
    @IBOutlet weak var alterEgosLabel: UILabel!
    @IBOutlet weak var aliasesLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var firstAppearanceLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var alignmentLabel: UILabel!
    // connections
    @IBOutlet weak var grupAffiliationLabel: UILabel!
    @IBOutlet weak var relativesLabel: UILabel!
    // work
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var baseLabel: UILabel!

    var hero: HeroModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        self.title = hero?.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                                 target: self,
                                                                 action: #selector(deleteHero))
        self.navigationItem.rightBarButtonItem?.tintColor = .darkGray
        setImgAndFullName()
        setupStats()
        setupAppearance()
        setupBiography()
        setupConnections()
        setupWork()
    }

    private func setImgAndFullName() {
        fullNameLabel.text = hero?.biography.fullName
        guard let imgData = hero?.imageData else { return }
        heroImg.image = UIImage(data: imgData)
        heroImg.layer.cornerRadius = 25
    }

    private func setupStats() {
        intStat.text = hero?.powerstats.intelligence ?? "0"
        strStat.text = hero?.powerstats.strength ?? "0"
        spdStat.text = hero?.powerstats.speed ?? "0"
        drbStat.text = hero?.powerstats.durability ?? "0"
        pwrStat.text = hero?.powerstats.power ?? "0"
        cmtStat.text = hero?.powerstats.combat ?? "0"
    }

    private func setupAppearance() {
        genderLabel.text = "Gender:     \(hero?.appearance.gender ?? "No data")"
        raceLabel.text = "Race:     \(hero?.appearance.race ?? "No data")"
        heightLabel.text = "Height:     \(hero?.appearance.height.first ?? "No data")"
        weightLabel.text = "Weight:     \(hero?.appearance.weight.first ?? "No data")"
        eyeColorLabel.text = "Eye Color:    \(hero?.appearance.eyeColor ?? "No data")"
        hairColorLabel.text = "Hair Color:      \(hero?.appearance.hairColor ?? "No data")"
    }

    private func setupBiography() {
        alterEgosLabel.text = "Alter Egos:     \(hero?.biography.alterEgos ?? "No data")"
        aliasesLabel.text = "Aliases:     \(hero?.biography.aliases.joined(separator: ", ") ?? "No data")"
        placeOfBirthLabel.text = "Place of Birth:     \(hero?.biography.placeOfBirth ?? "No data")"
        firstAppearanceLabel.text = "First Appearance:     \(hero?.biography.firstAppearance ?? "No data")"
        publisherLabel.text = "Publisher:    \(hero?.biography.publisher ?? "No data")"
        alignmentLabel.text = "Alignment:      \(hero?.biography.alignment ?? "No data")"
    }

    private func setupConnections() {
        grupAffiliationLabel.text = "Group Affiliation:     \(hero?.connections.groupAffiliation ?? "No data")"
        relativesLabel.text = "Relatives:     \(hero?.connections.relatives ?? "No data")"
    }

    private func setupWork() {
        occupationLabel.text = "Occupation:     \(hero?.work.occupation ?? "No data")"
        baseLabel.text = "Base:     \(hero?.work.base ?? "No data")"
    }

    @objc func deleteHero() {
        coordinator?.eventOccured(with: .goToHeroAndDeleteHero)
    }
}
