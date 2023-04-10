//
//  ReceivingViewController.swift
//  PassDataUsingNotification
//
//  Created by JeongminKim on 2023/04/10.
//

import UIKit

// Notification의 이름을 상수로 정의합니다.
extension Notification.Name {
    static let dataNotification = Notification.Name("DataNotification")
}

class ReceivingViewController: UIViewController {
    
    private lazy var dataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.text = "NO DATA"
        return label
    }()
    
    private lazy var popupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Popup SendingVC", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPopupButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ReceivingViewController"
        view.backgroundColor = .green
        setLayout()
        setObserver()
    }
    
    // 데이터를 전달받는 UIViewController가 화면에서 사라질 때 Notification을 해제합니다.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setLayout() {
        view.addSubview(dataLabel)
        view.addSubview(popupButton)
        
        NSLayoutConstraint.activate([
            dataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            popupButton.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 25),
            popupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupButton.widthAnchor.constraint(equalToConstant: 200),
            popupButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // 데이터를 전달받는 UIViewController에서 Notification을 추가합니다.
    private func setObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveData),
            name: .dataNotification,
            object: nil
        )
    }
    
    @objc private func didTapPopupButton() {
        let sendingVC = SendingViewController()
        sendingVC.modalPresentationStyle = .pageSheet
        sendingVC.sheetPresentationController?.detents = [.medium()]
        sendingVC.sheetPresentationController?.prefersGrabberVisible = true
        present(sendingVC, animated: true)
    }
    
    // 데이터를 전달받는 UIViewController에서 Notification을 받습니다.
    @objc func didReceiveData(_ notification: Notification) {
        if let data = notification.userInfo?["data"] as? String {
            dataLabel.text = "Received data: \(data)"
        }
    }
    
}
