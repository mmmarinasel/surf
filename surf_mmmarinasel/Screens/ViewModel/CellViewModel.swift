import Foundation

class CellViewModel {
    public var title: String = ""
    public var pressState: ViewModel.PressedState? = nil
    
    public func initPressState(indexPath: IndexPath) {
        if self.pressState != nil {
            return
        }
        self.pressState = ViewModel.PressedState(indexPath: indexPath, pressed: false)
    }
}
