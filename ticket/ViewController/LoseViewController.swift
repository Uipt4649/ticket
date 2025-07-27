//
//  LoseViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/05/18.
//

import UIKit

class LoseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet var horizontalCollectionView: UICollectionView!
    
    var events: [EventModel] = []

    
    @IBAction func backBUttom() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let nib = UINib(nibName: "LoseCollectionViewCell", bundle: .main)
        horizontalCollectionView
            .register(nib, forCellWithReuseIdentifier: "cell")
        
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        
        Task {
            do {
                events = try await supabase.from("events").select().execute().value

                horizontalCollectionView.reloadData()
            } catch {
                dump(error)
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LoseCollectionViewCell
        
        let event = events[indexPath.row]
                cell.titlelabel.text = event.name
                cell.detailabel.text = event.detail
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 400, height: 300)
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10
       }
}
