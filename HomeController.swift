//
//  HomeController.swift
//  BioDesign Mail
//
//  Created by Khalid Mohamed on 2/17/17.
//  Copyright © 2017 Khalid Mohamed. All rights reserved.
//

import UIKit
import MessageUI

// called when cell is dequed
class HomeController :UICollectionViewController, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate {
   
    private let cellId = "cellId"
    //let headerId = "headerId"
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Inbox"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true // making the bounce when user pulls down app.
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
                setupData()
                setupNavBarButtons()
    
    }
    //setting up mail option
    func setupNavBarButtons() {
        let button1 = UIBarButtonItem(barButtonSystemItem: .compose,target: self, action: #selector(email))
        let button2 = UIBarButtonItem(barButtonSystemItem:.organize,target: self, action: #selector(showmenu))
        navigationItem.rightBarButtonItem = button1
        navigationItem.setLeftBarButtonItems([button2], animated: true)
    }
    //actual mail func
    func email() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([""])
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }    
    func showmenu() {
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as!
        MessageCell
        
        if let message = messages?[indexPath.item] {
            cell.message = message
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(3, 0, 0, 0)
    }
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = MessagesController(collectionViewLayout:layout )
        controller.friend = messages?[indexPath.item].friend
        navigationController?.pushViewController(controller, animated: true)
    }
}
class MessageCell: BaseCell {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red:0, green: 134/244, blue: 249/255 , alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            
            messageLabel.text = message?.text
              if let date = message?.date {
                let dateFormamatter = DateFormatter()
                dateFormamatter.dateFormat = "h:mm a"
                
                let elapsedTimeinSeconds  = NSDate().timeIntervalSince(date as Date)
                let secondinDays: TimeInterval =  60 * 60 * 24
                if elapsedTimeinSeconds > secondinDays {
                    dateFormamatter.dateFormat = "MM/dd/yy"
                } else if elapsedTimeinSeconds > secondinDays {
                    dateFormamatter.dateFormat = "EEE"
                }
            
             timeLabel.text = dateFormamatter.string(from: date as Date)
            }
        }
}
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
        }()
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
        // programming divider line
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "me, Billy Kiely"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "We should grab some dinner tonight"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:26 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.white
        addSubview(dividerLineView) // adding divider line with subview
       
        setupContainerView() //setting up containerView
        
        
        addConstraintsWithFormat(format: "H:|-5-[v0]|",view:dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(1)]", view: dividerLineView)
    }

    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
       addConstraintsWithFormat(format:"H:|-20-[v0]|", view: containerView)
        addConstraintsWithFormat(format:"V:|-10-[v0(50)]|", view: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        
        
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", view: nameLabel,timeLabel) //constraints for name label and timeLabel.
        containerView.addConstraintsWithFormat(format: "V:|-2-[v0][v1(24)]|",view: nameLabel, messageLabel)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-|",view: messageLabel) //contriants for message label
        containerView.addConstraintsWithFormat(format: "V:|-2-[v0(24)]|", view: timeLabel)
    
}
}
 extension UIView {
    func addConstraintsWithFormat(format: String, view: UIView...) {
        var viewsDictionary = [String: UIView]() 
        for (index,view) in view.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options:NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
class BaseCell: UICollectionViewCell {
   
    override  init(frame:CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
     }
    
    }




