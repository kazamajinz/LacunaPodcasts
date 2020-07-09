//
//  SwipeActionService.swift
//  LacunaPodcasts
//
//  Created by Priscilla Ip on 2020-07-09.
//  Copyright © 2020 Priscilla Ip. All rights reserved.
//

import UIKit

struct SwipeActionService {
    
    private static func createBasicSwipeAction(style: UIContextualAction.Style, title: String, image: UIImage?, backgroundColor: UIColor?, handler: @escaping UIContextualAction.Handler) -> UIContextualAction {
        
        let action = UIContextualAction(style: style, title: title, handler: handler)
        action.image = image
        action.backgroundColor = backgroundColor
        return action
    }
    
    static func createDeleteAction(handler: @escaping UIContextualAction.Handler) -> UIContextualAction {
        createBasicSwipeAction(style: .destructive, title: "Trash", image: UIImage(systemName: "trash"), backgroundColor: .systemRed, handler: handler)
    }
    
    static func createEditAction(handler: @escaping UIContextualAction.Handler) -> UIContextualAction {
        createBasicSwipeAction(style: .normal, title: "Edit", image: UIImage(systemName: "square.and.pencil"), backgroundColor: nil, handler: handler)
    }
    
    static func createPrioritizeAction(handler: @escaping UIContextualAction.Handler) -> UIContextualAction {
        createBasicSwipeAction(style: .normal, title: "Edit", image: UIImage(systemName: "star"), backgroundColor: .systemYellow, handler: handler)
    }

}
