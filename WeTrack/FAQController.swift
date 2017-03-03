//
//  FAQController.swift
//  WeTrack
//
//  Created by xuhelios on 3/1/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

class FAQController: UIViewController {
    
    var faqs = FAQ.FAQFromBundle()
    
    let moreInfoText = "Select For More Info >"
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title =
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange, object: .none, queue: OperationQueue.main) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
}

extension FAQController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count \(faqs.count)")
        return faqs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FAQTableViewCell
        
        let faq = faqs[indexPath.row]
        
        cell.questionLabel.text  = faq.question
        cell.answerTextView.text = faq.answer
        
        switch (indexPath.item){
        case 0:
            cell.backgroundColor = UIColor(red:0.85, green:0.93, blue:0.95, alpha:1.0)
            cell.questionLabel.textColor = UIColor(red:0.01, green:0.18, blue:0.25, alpha:1.0)
            //UIColor(red:0.00, green:0.34, blue:0.61, alpha:1.0)
            
        case 1:
            cell.backgroundColor = UIColor(red:0.58, green:0.86, blue:0.85, alpha:1.0)
            cell.questionLabel.textColor = UIColor(red:0.01, green:0.18, blue:0.25, alpha:1.0)
            //UIColor(red:0.01, green:0.47, blue:0.74, alpha:1.0)
            
        case 2:
            cell.backgroundColor = UIColor(red:0.10, green:0.65, blue:0.72, alpha:1.0)
            //UIColor(red:0.01, green:0.53, blue:0.82, alpha:1.0)
            cell.questionLabel.textColor = UIColor.white
        case 3:
            cell.backgroundColor = UIColor(red:0.01, green:0.18, blue:0.25, alpha:1.0)
            //UIColor(red:0.01, green:0.61, blue:0.90, alpha:1.0)
            cell.questionLabel.textColor = UIColor.white
        default:
            cell.backgroundColor = UIColor.white
            cell.questionLabel.textColor = UIColor.black
        }
        
        
        // cell.questionLabel.backgroundColor = UIColor(red: 1, green: 152/255, blue: 0, alpha: 1)
        cell.questionLabel.textAlignment = .center
        cell.questionLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cell.answerTextView.textColor = cell.questionLabel.textColor
        cell.answerTextView.backgroundColor = cell.backgroundColor
        cell.selectionStyle = .none
        
        cell.answerTextView.text = faq.isExpanded ? faq.answer : ""
        cell.answerTextView.textAlignment = faq.isExpanded ? .left : .center
        
        return cell
    }
}


extension FAQController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1
        guard let cell = tableView.cellForRow(at: indexPath) as? FAQTableViewCell else { return }
        
        var faq = faqs[indexPath.row]
        
        // 2
        faq.isExpanded = !faq.isExpanded
        faqs[indexPath.row] = faq
        
        // 3
        cell.answerTextView.text = faq.isExpanded ? faq.answer : ""
        cell.answerTextView.textAlignment = faq.isExpanded ? .left : .center
        print(cell.answerTextView.text)
        // 4
        tableView.beginUpdates()
        tableView.endUpdates()
        
        // 5
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
