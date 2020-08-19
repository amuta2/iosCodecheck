//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ShowRepositoriesDetailViewController: UIViewController {
    
    @IBOutlet weak var ImgView: UIImageView!
    
    @IBOutlet weak var TtlLbl: UILabel!
    
    @IBOutlet weak var LangLbl: UILabel!
    
    @IBOutlet weak var StrsLbl: UILabel!
    @IBOutlet weak var WchsLbl: UILabel!
    @IBOutlet weak var FrksLbl: UILabel!
    @IBOutlet weak var IsssLbl: UILabel!
    
    var searchRepositoriesVC: SearchRepositoriesViewController!
    let getRepositoriesImageManager = GetRepositoriesImageManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedIndex = searchRepositoriesVC.idx else { return }
        let repo = searchRepositoriesVC.repo[selectedIndex]
        
        TtlLbl.text = "\(repo["full_name"] as? String ?? "")"
        LangLbl.text = "Written in \(repo["language"] as? String ?? "")"
        StrsLbl.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        WchsLbl.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        FrksLbl.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        IsssLbl.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getRepositoriesImageManager.getImage(searchRepositoriesVC: searchRepositoriesVC, showRepositoriesDetailVC: self)
    }

}