//
//  ViewController.swift
//  FancyCars
//
//  Created by Michael Chung on 4/24/19.
//  Copyright © 2019 Michael Chung. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    @IBOutlet weak var filterButton: UIButton!

    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= cars.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    var serviceMockAPI:APIServiceMock = APIServiceMock()
    var fetchInProgress:Bool = false
    var currentPage:Int = 0
    var cars:[Car] = []
    
    // can use an enum here
    var filter:String = "Name"
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
     
        if indexPaths.contains(where: isLoadingCell) {
            self.fetchData()
        }
    }
    

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as? CarCell
        if isLoadingCell(for: indexPath) {
            cell?.isLoading()
        } else {
            let data = self.cars[indexPath.row]
            cell?.setData(data: data)
        }
        return cell!
    }
    
    func calculateReloadIndexPathes(from newCars:[Car]) -> [IndexPath] {
        let startIndex = self.cars.count - newCars.count
        let endIndex = startIndex + newCars.count
        let range = Array(startIndex..<endIndex)
        let result = range.map { IndexPath(row: $0, section: 0) }
        return result
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        self.tableView.tableFooterView = UIView()
        self.filterButton.addTarget(self, action: #selector(showActionSheet), for: .touchDown)
        self.fetchData()
    }
    
    @objc func showActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "Filter By", preferredStyle: .actionSheet)
        
        let name = UIAlertAction(title: "Name", style: .default, handler: { (action) in
            self.cars.sort(by: { (a, b) -> Bool in
                return a.name < b.name
            })
            self.filter = "Name"
            self.tableView.reloadData()
        })
        
        let avail = UIAlertAction(title: "Availibility", style: .default, handler: { (action) in
            self.cars.sort(by: { (a, b) -> Bool in
                return a.available! < b.available!
            })
            self.filter = "Availibility"
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(name)
        optionMenu.addAction(avail)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func fetchData() {
        if fetchInProgress == true {
            return
        }
        
        fetchInProgress = true
        // assume api doesn't return an error
        serviceMockAPI.getCarsPage(page: currentPage) { [weak self] (cars) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                
                strongSelf.fetchInProgress = false
                strongSelf.cars.append(contentsOf: cars)
                
                if strongSelf.currentPage > 1 {
                    let reload = strongSelf.calculateReloadIndexPathes(from: cars)
                    strongSelf.onFetchCompleted(with: reload)
                } else {
                    strongSelf.tableView.reloadData()
                }
                strongSelf.currentPage += 1
            }
            
        }
    }


    
}

