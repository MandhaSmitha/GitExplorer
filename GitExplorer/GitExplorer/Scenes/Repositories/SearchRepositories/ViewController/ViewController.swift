//
//  ViewController.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 27/02/2021.
//

import UIKit

struct SearchBarConstants {
    static let height: CGFloat = 46.0
    static let margin: CGFloat = 20.0
    static let radius: Int = 6
}

class ViewController: UIViewController, Storyboarded {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var viewModel: GitSearchReposViewModel?
    var coordinator: GitSearchReposCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchBar()
    }
    func setupView() {
        titleLabel.text = NSLocalizedString("RepoListScreenTitle", comment: "Repository list screen title")
        tableView.register(headerFooterViewType: GItRepoListHeaderView.self)
        tableView.keyboardDismissMode = .onDrag
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    /// SearchBar customization:
    /// Custom search background
    /// Icon left padding = 15, textField left padding = 15, Default padding = 5, custom padding = 10
    func setupSearchBar() {
        searchBar.placeholder = NSLocalizedString("SearchPlaceHolder", comment: "Search repo placeholder")
        searchBar.setImage(UIImage(named: "SearchIcon"), for: .search, state: .normal)
        let color = UIColor(red: 0.922, green: 0.929, blue: 0.953, alpha: 1)
        let size = CGSize(width: searchBar.frame.width - (SearchBarConstants.margin * 2),
                          height: SearchBarConstants.height)
        let image = UIImage.imageWithColor(color: color, size: size)
        let roundedImage = UIImage.roundedImage(image: image, cornerRadius: SearchBarConstants.radius)
        searchBar.setSearchFieldBackgroundImage(roundedImage, for: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10.0, vertical: 0.0), for: .search)
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 10.0, vertical: 0.0)
        hideSearchBarClearButton()
    }
    /// SearchBar customization:
    /// Hide clear button when text is entered.
    private func hideSearchBarClearButton() {
        var searchTextField: UITextField?
        if #available(iOS 13.0, *) {
            searchTextField = searchBar.searchTextField
        } else {
            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                searchTextField = searchField
            }
        }
        searchTextField?.clearButtonMode = .never
        searchTextField?.textColor = UIColor(red: 0.201, green: 0.234, blue: 0.321, alpha: 1)
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
        guard let listViewModel = viewModel else {
            return
        }
        let detailModel = listViewModel.getRepoDetailCellViewModel(row: indexPath.row, section: indexPath.section)
        let parameterModel = listViewModel.getRepoDetailParameterModel(row: indexPath.row, section: indexPath.section)
        coordinator?.navigateToDetail(detailModel: detailModel,
                                      parameterModel: parameterModel)
    }
    /// Call for the next set of reults once the end of the current page is reached.
    /// - Parameter scrollView: `TableView`in this case.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > (contentHeight - scrollView.frame.height) {
            viewModel?.didReachEndOfPage()
        }
    }
}

extension ViewController: GitRepoViewDelegate {
    func refreshView() {
        tableView.reloadData()
    }
}
