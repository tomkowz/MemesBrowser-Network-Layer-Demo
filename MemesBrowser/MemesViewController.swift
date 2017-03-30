import UIKit

final class MemesViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var spinner: UIActivityIndicatorView!
    
    private let dataSource = MemesDataSource()
    private let interactor = MemesInteractor()
    private var router: MemesRouter!
    
    private let CellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRouter()
        registerCells()
        fetchData()
    }
}

extension MemesViewController {
    
    private func setupRouter() {
        router = MemesRouter(sourceVC: self)
    }
    
    private func registerCells() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
    }
    
    private func fetchData() {
        spinner.startAnimating()
        interactor.getMemes() { [unowned self] items in
            dispatch_async(dispatch_get_main_queue()) {
                self.dataSource.items = []
                self.tableView.reloadData()

                self.dataSource.items = items
                // Add fake item for demo
                if items.count > 0 {
                    self.dataSource.items.append(MemeInfoItem(fileName: "404.jpg"))
                }
                
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}

extension MemesViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = dataSource.items[indexPath.row].fileName
        return cell
    }
}

extension MemesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let info = dataSource.items[indexPath.row]
        self.router.presentPreview(info.fileName, title: info.fileName)
    }
}
