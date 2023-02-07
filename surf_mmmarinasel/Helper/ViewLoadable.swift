import UIKit

protocol ViewLoadable {
    associatedtype CustomView: UIView
}

extension ViewLoadable where Self: UIViewController {
    func view() -> CustomView {
        guard let view = self.view as? CustomView else { return CustomView() }
        return view
    }
}
