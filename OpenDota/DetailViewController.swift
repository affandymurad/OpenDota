//
//  DetailViewController.swift
//  OpenDota
//
//  Created by docotel on 25/09/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import Foundation
import UIKit

class tableCell: UITableViewCell{
    
    @IBOutlet weak var ivCell: UrlPhotoHandling!
    
    @IBOutlet weak var labelCell: UILabel!
    
    func setHero(hero: Hero){
        let img = "https://api.opendota.com\(hero.img ?? "")"
        let name = hero.localizedName
        labelCell.text = name
        ivCell.loadImageUsingUrlString(img, kata: name ?? "")
    }
    
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var hero = Hero(context: context)
    var rankList:[Hero] = []
    var rankResultList:[Hero] = []
    
    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var ivHero: UrlPhotoHandling!
    @IBOutlet weak var nameHero: UILabel!
    @IBOutlet weak var roleHero: UILabel!
    
    @IBOutlet weak var baseAttackHero: UILabel!
    
    @IBOutlet weak var baseArmorHero: UILabel!
    
    @IBOutlet weak var moveSpeedHero: UILabel!
    
    @IBOutlet weak var baseHealthHero: UILabel!

    @IBOutlet weak var baseManaHero: UILabel!
    @IBOutlet weak var primaryAttrHero: UILabel!
    
    @IBOutlet weak var attackTypeHero: UILabel!
    
    
    override func viewDidLoad() {
        self.title = "Hero"
        super.viewDidLoad()
        
        tabelView.delegate = self
        tabelView.dataSource = self

        tabelView.tableFooterView = UIView()
        tabelView.tableFooterView?.isHidden = true
        
        
        var rank1 = rankList[0]
        if (rankList[0].id == Int64(hero.id)) {
            rank1 = rankList[1]
        } else {
            rank1 = rankList[0]
        }
        
        var rank2 = rankList[1]
        if rankList[1].id == rank1.id || rankList[1].id == Int64(hero.id) {
            rank2 = rankList[2]
        } else {
            rank2 = rankList[1]
        }
        
        var rank3 = rankList[2]
        if rankList[2].id == rank1.id || rankList[2].id == rank2.id {
            rank3 = rankList[3]
        } else {
            rank3 = rankList[2]
        }
        
        self.rankResultList = [rank1, rank2, rank3]
        self.tabelView.reloadData()
        
        nameHero.text = hero.localizedName
        let img = "https://api.opendota.com\(hero.img ?? "")"
        ivHero.loadImageUsingUrlString(img, kata: hero.localizedName ?? "")
        roleHero.text = "🔑 Roles: \(hero.roles!)"
        baseAttackHero.text = "⚔️ Base Attack: \(hero.baseAttackMin) - \(hero.baseAttackMax)"
        baseArmorHero.text = "🛡️ Base Armor: \(hero.baseArmor)"
        moveSpeedHero.text = "🥾 Move Speed: \(hero.moveSpeed)"
        baseHealthHero.text = "🏥 Base Health: \(hero.baseHealth)"
        baseManaHero.text = "🍶 Base Mana: \(hero.baseMana)"
        primaryAttrHero.text = "⛓️ Primary Attribute: \(hero.primaryAttr!)"
        attackTypeHero.text = "🎯 Attack Type: \(hero.attackType!)"

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rankResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableCell
        cell.setHero(hero: rankResultList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    

}
