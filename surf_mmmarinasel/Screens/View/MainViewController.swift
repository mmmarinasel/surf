import UIKit

class MainViewController: UIViewController {
//    typealias CustomView = MainView
    var mainView: MainView = MainView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .purple
        self.view.addSubview(self.mainView)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.mainView.build(self.view)
    }
}
