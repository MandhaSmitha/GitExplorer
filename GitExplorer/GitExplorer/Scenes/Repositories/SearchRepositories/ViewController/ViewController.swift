//
//  ViewController.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 27/02/2021.
//

import UIKit

class ViewController: UIViewController, Storyboarded {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var viewModel: GitSearchReposViewModel?
    var coordinator: GitSearchReposCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView() {
        self.title = NSLocalizedString("RepoListScreenTitle", comment: "Repository list screen title")
        tableView.register(headerFooterViewType: GItRepoListHeaderView.self)
        searchBar.setShowsCancelButton(false, animated: false)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.didUpdateSearch(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(inSection: section) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GitRepoTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let model = viewModel?.cellViewModel(forRow: indexPath.row,
                                                inSection: indexPath.section) as? GitRepoCellViewModel {
            cell.bindData(model: model)
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: GItRepoListHeaderView = tableView.dequeueReusableHeaderFooterView()
        view.bindData(title: viewModel?.titleForHeader(inSection: section))
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailModel = viewModel?.getRepoDetailCellViewModel(row: indexPath.row, section: indexPath.section)
        coordinator?.navigateToDetail(detailModel: detailModel)
    }
}

extension ViewController: GitRepoViewDelegate {
    func refreshView() {
        tableView.reloadData()
    }
}
