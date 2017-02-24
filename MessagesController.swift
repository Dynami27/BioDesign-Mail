//
//  MessagesController.swift
//  BioDesign Mail
//
//  Created by Khalid Mohamed on 2/23/17.
//  Copyright © 2017 Khalid Mohamed. All rights reserved.
//

import UIKit

class MessagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    
    var friend : Friend? {
    
    didSet {
        navigationItem.title = friend?.name
        let button3 = UIBarButtonItem(barButtonSystemItem:.trash,target: self, action: Selector("action"))
        navigationItem.rightBarButtonItem = button3
        
        
        messages = friend?.messages?.allObjects as? [Message]
        messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})}
    }
    var messages: [Message]?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count{
        return count
    }
    return 0
}
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.messageTextView.text = messages?[indexPath.item].text
        
        if let messageText = messages?[indexPath.item].text{ //let profileImageName = messages?[indexPath.item].friend?.profileImageName {
            
       // cell.profileImageView.image = UIImage(named: profileImageName)
            
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        
        cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
        cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let messageText = messages?[indexPath.item].text{
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
    
        return CGSize(width: view.frame.width, height: 100)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }


    class ChatMessageCell: BaseCell {
      let messageTextView: UITextView = {
            let textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 18)
            textView.text = "Sample Message"
            textView.backgroundColor = UIColor.clear
            return textView
        }()
        let textBubbleView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white:0.95, alpha: 1 )
            
            return view
        }()
        let profileImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
            
         return imageView
        }()
        
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]" , view: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|" , view: profileImageView)
        profileImageView.backgroundColor = UIColor.red
        }
}
}
