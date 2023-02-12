import UIKit

class MainViewController: UIViewController {
    private var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var draggableView: MainView = MainView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.draggableView.delegate = self
        self.view.backgroundColor = .purple
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.draggableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupImgView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.draggableView.build(self.view)
        self.draggableView.setupConstraints()
    }
    
    private func setupImgView() {
        let constraints = [
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        self.imageView.contentMode = .scaleToFill
        self.imageView.image = UIImage(named: "bgImage")
    }
}

extension MainViewController: MainViewDelegate {
    func handleSend() {
        let alert = UIAlertController(title: "Поздравляем!",
                                      message: "Ваша заявка успешно отправлена!",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Закрыть",
                                     style: .cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}
