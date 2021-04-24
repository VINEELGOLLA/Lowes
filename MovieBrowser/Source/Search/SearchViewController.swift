//
//  SearchViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/19/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, LoadingScreen, Alerter {
    var loadingView: LoadingView!
    @IBOutlet weak var searchBar: UISearchBar!
    let networkManager = Network()
    private var pageNumber: Int = 1
    private var searchBarText: String?
    private var movielist: MovieDataModel? {
        didSet {
            DispatchQueue.main.async {
                self.MovieListTableView.isHidden =  !(self.movielist?.results.count ?? 0 >= 1)
            }
        }
    }

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var Go: UIButton!
    @IBOutlet weak var MovieListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        title = Constants.navBarTitle
        searchBar.delegate = self
        self.MovieListTableView.isHidden = true
        MovieListTableView.tableFooterView = UIView()
        MovieListTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defalultCellIdentifier)
        Go.addTarget(self, action: #selector(goButton), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapView(_:)))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func goButton() {
        searchBarSearchButtonClicked(searchBar)
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = self.searchBar.text,
              !text.isEmpty,
              let searchText = text.removeWhiteSpaces(query: text),
              !searchText.isEmpty else {
            self.alert(error: MbError.EmptySearchBar)
            searchBar.text = nil
            self.movielist = nil
            self.MovieListTableView.reloadData()
            return
        }
        searchBar.resignFirstResponder()
        self.showLoadingScreen()
        self.searchBarText = searchText
                
        networkManager.fetchDataWith(query: searchText, andPage: "1") { [weak self] result in
            self?.pageNumber = 1
            switch result {
            case .success(let movieData):
                DispatchQueue.main.async {
                    self?.movielist = movieData
                    self?.hideLoadingScreen()
                    self?.MovieListTableView.reloadData()
                    if movieData.results.count > 1 {
                        self?.MovieListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    } else {
                        self?.alert(error: MbError.NoResult)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.hideLoadingScreen()
                    self?.alert(error: error)
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movielist?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath) as?  SearchViewTableViewCell,
               let result = movielist?.results[indexPath.row] else {
                   return UITableViewCell(style: .default, reuseIdentifier: Constants.defalultCellIdentifier)
                }
            cell.movieName.text = result.originalTitle ?? "N/A"
            cell.movieDate.text = result.releaseDate ?? "N/A"
            cell.movieRating.text = String(result.voteAverage ?? 0.0)
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = movielist?.results[indexPath.row] {
            performSegue(withIdentifier: "detail", sender: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        guard  let searchBarText = self.searchBarText, let movieListCount = movielist?.results.count, let totalPages = movielist?.totalPages else { return }
        if indexPath.row == movieListCount - 1 {
            if self.pageNumber < totalPages {

                self.MovieListTableView.tableFooterView = spinnerFooter()
                self.MovieListTableView.tableFooterView?.isHidden = false
                
                self.pageNumber = self.pageNumber + 1
                networkManager.fetchDataWith(query: searchBarText, andPage: String(self.pageNumber)) { [weak self] result in
                    switch result {
                    case .success(let movieData):
                        self?.movielist?.results.append(contentsOf: movieData.results)
                        DispatchQueue.main.async {
                            self?.MovieListTableView.tableFooterView?.isHidden = true
                            self?.MovieListTableView.reloadData()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.MovieListTableView.tableFooterView?.isHidden = true
                            self?.alert(error: error)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if segue.destination.isKind(of: MovieDetailViewController.self),
               let detailVC = segue.destination as? MovieDetailViewController,
               let indexPath = sender as? IndexPath {
                if let results = movielist?.results, results.count > indexPath.row {
                    detailVC.movie = results[indexPath.row]
                }
            }
        }
    }
    
    func spinnerFooter() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.main.bounds.width, height: CGFloat(44))
        return spinner
    }
}

