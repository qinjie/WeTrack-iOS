//
//  FAQ.swift
//  WeTrack
//
//  Created by xuhelios on 3/1/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

struct FAQ {
    let question: String
    let answer: String
    var isExpanded: Bool
    
    init(question: String, answer: String, isExpanded: Bool) {
        self.question = question
        self.answer = answer
        self.isExpanded = isExpanded
    }
    
    static func FAQFromBundle() -> [FAQ] {
        
        var faqs = [FAQ]()
        
        guard let url = Bundle.main.url(forResource: "faqs", withExtension: "json") else {
            return faqs
        }
        
        do {
            let data = try Data(contentsOf: url)
            guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]  else {
                return faqs
            }
            
            guard let faqObjects = rootObject["faqs"] as? [[String: AnyObject]] else {
                return faqs
            }
            
            for faqObject in faqObjects {
                if let question = faqObject["question"] as? String,
                    let answer = faqObject["answer"]  as? String{
                    
                    let faq = FAQ(question: question, answer: answer, isExpanded: false)
                    faqs.append(faq)
                }
                
            }
            
        } catch {
            return faqs
        }
        
        return faqs
    }
    
}
