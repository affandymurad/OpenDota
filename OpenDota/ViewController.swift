//
//  ViewController.swift
//  OpenDota
//
//  Created by docotel on 24/09/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import UIKit
import CoreData

class HeroesCell: UICollectionViewCell {
    
    @IBOutlet weak var tvHeroes: UILabel!
    
    @IBOutlet weak var ivHeroes: UrlPhotoHandling!
    
    
    func setHero(hero: Hero){
        let img = "https://api.opendota.com\(hero.img ?? "")"
        let name = hero.localizedName
        tvHeroes.text = name
        ivHeroes.loadImageUsingUrlString(img, kata: name ?? "")
    }
}

class ViewController: BaseViewController<ViewPresenter>, MainDelegates, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var heroesList:[Hero] = []
    
    var sortedList:[Hero] = []
    
    var allList:[Hero] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var rolesField: DesignableUITextField!
    
    private var numberOfItemsInRow = 2

    private var minimumSpacing = 5

    private var edgeInsetPadding = 10
    
    let rolesList: [String] = ["All","Carry","Nuker","Initiator","Disabler","Durable","Escape","Support","Pusher","Jungler"]
    
    let pvRoles = UIPickerView()
    var idRoles = "All"
    
    func loadRolesList(roles: [DotaElement]) {
        DispatchQueue.main.async {
            self.taskDidFinish()
        }
        for x in roles{
            let y = Hero(context: context)
            y.localizedName = x.localizedName
            y.roles = x.roles.joined(separator: ", ")
            y.primaryAttr = x.primaryAttr
            y.attackType = x.attackType
            y.moveSpeed = Int64(x.moveSpeed)
            y.img = x.img
            y.id = Int64(x.id)
            y.baseMana = Int64(x.baseMana)
            y.baseHealth = Int64(x.baseHealth)
            y.baseAttackMin = Int64(x.baseAttackMin)
            y.baseAttackMax = Int64(x.baseAttackMax)
            y.baseArmor = x.baseArmor
        }
        ad.saveContext()
        loadHeroes()
    }
    
    func loadHeroes() {
        let fetchRequest:NSFetchRequest<Hero> = Hero.fetchRequest()
        do {
            heroesList = try context.fetch(fetchRequest)
             sortedList = heroesList
             allList = heroesList
            if (heroesList.count == 0) {
                presenter.getRolesList()
            } else {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(.zero, animated: true)
                }
            }
        } catch {
            showAlertAction(title: "Error", message: "cannot fetch from database")
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pvRoles:
            return self.rolesList.count
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pvRoles:
            return self.rolesList[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pvRoles:
            rolesField.text = self.rolesList[row]
            self.idRoles = self.rolesList[row]
            self.title = self.idRoles
            
            self.sortedList = self.allList
            DispatchQueue.main.async {
                if (self.idRoles == "All"){
                   self.heroesList = self.allList
                   self.collectionView.reloadData()
                   self.collectionView.setContentOffset(.zero, animated: true)
                } else {
                    self.heroesList = self.sortedList.filter{$0.roles!.contains(self.idRoles)}
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(.zero, animated: true)
                }
            }
        default:
            placeHolder()
        }
    }
    
    func placeHolder() {
        rolesField.tintColor = .clear
        rolesField.placeholder = "Select"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsMultipleSelection = false
  
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .jingga
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneTapped(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        pvRoles.dataSource = self
        pvRoles.delegate = self
        rolesField.inputView = pvRoles
        rolesField.inputAccessoryView = toolBar
        rolesField.tintColor = .clear
        
        let indexRoles = self.rolesList.firstIndex(where: {$0 == self.idRoles})
        pvRoles.selectRow(indexRoles!, inComponent: 0, animated: true)
        self.rolesField.text = self.rolesList[indexRoles!]
        
        self.title = self.idRoles
        
        presenter = ViewPresenter(view: self)
        loadHeroes()
    }
    
    @IBAction func refreshHero(_ sender: Any) {
        
        if (self.idRoles != "All") {
            taskDidError(txt: "Set roles as ALL first!")
        } else {
            if (self.heroesList.count != 0) {
                for z in self.heroesList {
                    context.delete(z)
                }
                self.heroesList.removeAll()
                self.collectionView.reloadData()
                self.collectionView.setContentOffset(.zero, animated: true)
                self.loadHeroes()
            }
        }
    }
    
    @objc func doneTapped(_ tap: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func taskDidBegin() {
        var indicatorView = self.navigationController?.view.viewWithTag(88) as? UIActivityIndicatorView
        if (indicatorView == nil) {
            indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
            indicatorView?.tag = 88
        }
        indicatorView?.frame = self.navigationController!.view.bounds
        indicatorView?.backgroundColor = UIColor.init(white: 0, alpha: 0.50)
        indicatorView?.startAnimating()
        indicatorView?.isHidden = false
        self.navigationController?.view.addSubview(indicatorView!)
        self.navigationController?.view.isUserInteractionEnabled = false
    }
    
    
    func taskDidFinish() {
        let indicatorView = self.navigationController?.view.viewWithTag(88) as? UIActivityIndicatorView
        if (indicatorView != nil) {
            indicatorView?.stopAnimating()
            indicatorView?.removeFromSuperview()
        }
        self.navigationController?.view.isUserInteractionEnabled = true
    }
    
    func taskDidError(txt: String) {
        DispatchQueue.main.async {
            self.taskDidFinish()
            self.showAlertAction(title: "Error", message: txt)
        }
    }
    
    // MARK: Menentukan jumlah item yang akan di tampilkan
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // MARK: Menghitung jumlah item array dataEmojies
        return heroesList.count
    }

    // MARK: mengatur view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heroes", for: indexPath) as! HeroesCell

        // set nilai ke view dalam cell
        cell.setHero(hero: heroesList[indexPath.row])
        if cell.isSelected {
            cell.backgroundColor = UIColor.gray
        }
        return cell
    }
    
    private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItem(at: indexPath as IndexPath)?.backgroundColor = UIColor.gray
    }

    private func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItem(at: indexPath as IndexPath)?.backgroundColor = UIColor.clear
    }

    // MARK: mengatur layout view cell
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let cellWidth = (width - 30) / 3 // compute your cell width
            return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let baris = heroesList[indexPath.row]
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : DetailViewController = storyboard.instantiateViewController(withIdentifier: "Details") as! DetailViewController

        let agi = self.heroesList.sorted(by: { $0.moveSpeed > $1.moveSpeed})
        let str = self.heroesList.sorted(by: { $0.baseAttackMax > $1.baseAttackMax})
        let int = self.heroesList.sorted(by: { $0.baseMana > $1.baseMana})
        

        vc.hero = baris
        switch baris.primaryAttr {
        case "agi":
            vc.rankList = agi
        case "str":
            vc.rankList = str
        case "int":
            vc.rankList = int
        default:
            vc.rankList = self.heroesList
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlertAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

