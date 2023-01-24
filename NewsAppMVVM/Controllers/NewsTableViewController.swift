//
//  NewsTableViewController.swift
//  NewsAppMVVM
//
//  Created by Oscar David Myerston Vega on 24/01/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupAppearance()
        
        populateNews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM == nil ? 0: self.articleListVM.articlesVM.count
    }
    
    private func populateNews() {
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=3ad904d51d564017850befd9e575d2d9")!)
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                let articles = articleResponse.articles
                self.articleListVM = ArticleListViewModel(articles)
            }).disposed(by: disposeBag)
    }
    
    private func setupAppearance() {
          let appearance = UINavigationBarAppearance()
          appearance.configureWithOpaqueBackground()
          appearance.backgroundColor = UIColor(displayP3Red: 142/255, green: 68/255, blue: 173/255, alpha: 1)
          appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
          appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
          navigationItem.standardAppearance = appearance
          navigationItem.scrollEdgeAppearance = appearance
          navigationItem.compactAppearance = appearance
       
          navigationController?.navigationBar.prefersLargeTitles = true
      }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleTableViewCell is not found")
        }
        
        let articleVM = self.articleListVM.articleAt(indexPath.row)
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        let articleVM = self.articleListVM.articleAt(indexPath.row)
        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        return cell
    }
}
