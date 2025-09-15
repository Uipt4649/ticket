//
//  ViewController.swift
//  ticket
//
//  Created by 渡邉羽唯 on 2025/02/16.
//

import UIKit

class EventListViewController: UIViewController {
    var events: [EventModel] = []
    private var childVC: NFViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await loadEvents()
        }
    }
    private func loadEvents() async {
        do {
            events = try await supabase
                .from("events")
                .select()
                .execute().value
            setupChildVC()
        } catch {
            dump(error)
        }
    }
    private func setupChildVC() {
        let childVC = NFViewController(
            nfHeroHeaderItem: events.map { event in
                NFHeroHeaderItem(title: event.name, image: getImageByUrl(url: event.image_url))
            },
            nfCollectionItem: events.map { event in
                NFCollectionItem(title: event.name, description: event.detail, image: getImageByUrl(url: event.image_url))
            },
            nfSectionTitle: "出し物一覧"
            ,
            onSelectItem: { [weak self] item in
                guard let self = self else { return }
                if let event = self.events.first(where: { $0.name == item.title }) {
                    self.performSegue(withIdentifier: "toLotteryView", sender: event)
                }
            }
        )
        self.childVC?.willMove(toParent: nil)
        self.childVC?.view.removeFromSuperview()
        self.childVC?.removeFromParent()
        self.childVC = childVC
        self.addChild(childVC)
        self.view.addSubview(childVC.view)
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            childVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        childVC.didMove(toParent: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLotteryView",
           let event = sender as? EventModel,
           let vc = segue.destination as? LotteryViewController {
            vc.event = event
        }
    }
}
