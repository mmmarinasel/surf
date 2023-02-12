import Foundation

class ViewModel {
    public struct PressedState {
        var indexPath: IndexPath
        var pressed: Bool
    }
    
    private var model = DataModel()
    private var cellViewModels: [CellViewModel] = []
    private var cellPagingViewModels: [CellViewModel] = []
    private var headerViewModels: [HeaderViewModel] = []
    
    private var pressStates: [PressedState] = []
    
    public var items: [String] {
        get {
            return self.model.directions
        }
    }
    
    public var itemsPaging: [String] {
        get {
            return self.model.directions
        }
    }
    
    public init() {
        self.setCellVMs()
        self.setCellPagingVMs()
        self.setHeaderVMs()
    }
    
    public func getCellViewModel(_ indexPath: IndexPath) -> CellViewModel? {
        guard !self.cellViewModels.isEmpty else { return nil }
        return self.cellViewModels[indexPath.row]
    }
    
    public func getCellPagingViewModel(_ indexPath: IndexPath) -> CellViewModel? {
        guard !self.cellPagingViewModels.isEmpty else { return nil }
        return self.cellPagingViewModels[indexPath.row]
    }
    
    public func getHeaderViewModel(_ indexPath: IndexPath) -> HeaderViewModel? {
        guard !self.headerViewModels.isEmpty else { return nil }
        return self.headerViewModels[indexPath.section]
    }
    
    private func setCellVMs() {
        var vms = [CellViewModel]()
        
        for direction in self.model.directions {
            vms.append(createCellViewModel(title: direction))
        }
        
        self.cellViewModels = vms
        
    }
    
    private func setCellPagingVMs() {
        var vms = [CellViewModel]()
        
        for direction in self.model.directions {
            vms.append(createCellViewModel(title: direction))
        }
        
        self.cellPagingViewModels = vms
        
    }
    
    private func setHeaderVMs() {
        var vms = [HeaderViewModel]()
        for descr in self.model.descriptions {
            vms.append(createHeaderViewModel(descr: descr))
        }
        self.headerViewModels = vms
    }
    
    private func createCellViewModel(title: String) -> CellViewModel {
        let cellVM = CellViewModel()
        cellVM.title = title
        return cellVM
    }
    
    private func createHeaderViewModel(descr: String) -> HeaderViewModel {
        return HeaderViewModel(text: descr)
    }
}
