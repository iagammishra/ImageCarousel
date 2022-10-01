//
//  CarouselViewController.swift
//  Carousel
//
//  Created by Agam Mishra on 01/10/22.
//

import UIKit

class CarouselViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsSelection = false
            tableView.keyboardDismissMode = .interactive
            tableView.showsVerticalScrollIndicator = false
        }
    }
    lazy var searchBar: UISearchBar = {
          let searchBar = UISearchBar(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 44)))
        searchBar.backgroundColor = .white
        searchBar.showsCancelButton = false
        searchBar.delegate = self
          return searchBar
       }()
    var viewModel = CarouselViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ImageListViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.register(UINib(nibName: "CarouselView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CarouselHeader")
        self.createTableHeader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getAllImages()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
        self.tableView.reloadData()
    }

    //MARK: Theme
    func setTheme() {
        self.navigationItem.title = "Images"
    }

    //MARK: Custom methods
    func createTableHeader() {
        let header = CarouselView(frame: CGRect(origin: .zero, size: CGSize(width: self.tableView.frame.width, height: 300)))
        header.delegate = self
        self.tableView.tableHeaderView = header
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            header.configureView(with: self.viewModel.model.carouselData)
        }


    }

    //Data methods
    func getAllImages() {
        self.viewModel.fetchAllImages { success, message in
            if success {
                if self.viewModel.model.carouselData.count > 0 {
                    self.viewModel.model.imageList = self.viewModel.model.carouselData[0].images ?? [ImageData]()
                    self.viewModel.model.arrayList = self.viewModel.model.imageList
                }
                print("Images \(self.viewModel.model.imageList)")
                self.tableView.reloadData()
            }
            else {
                AMUtility.showAlert(title: "Error", message: message ?? "Unable to get images", controller: self)
            }
        }
    }
}

extension CarouselViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.model.arrayList.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ImageListViewCell else {
            return UITableViewCell()
        }
        let imageData = self.viewModel.model.arrayList[indexPath.row]
        cell.descriptionLBL.text = imageData.description
        if let url = URL(string: imageData.imageUrl ?? "") {
            DispatchQueue.main.async {
                cell.imgView.loadImageWithUrl(url)
            }
        }
        return cell
    }


}

extension CarouselViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if !searchText.isEmpty {
            self.viewModel.filterData(text: searchText)
        } else {
            self.viewModel.model.arrayList = self.viewModel.model.imageList
        }
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.view.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        self.viewModel.model.arrayList = self.viewModel.model.imageList
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

extension CarouselViewController: CarouselViewProtocol {
    func carouselChanged(index: Int) {
        self.searchBar.text = nil
        self.view.endEditing(true)
        self.searchBar.setShowsCancelButton(false, animated: true)
        if 0..<self.viewModel.model.carouselData.count ~= index {
            self.viewModel.model.imageList = self.viewModel.model.carouselData[index].images ?? [ImageData]()
            self.viewModel.model.arrayList = self.viewModel.model.imageList
            self.tableView.reloadData()
        }
    }


}
