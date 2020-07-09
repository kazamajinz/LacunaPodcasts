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
    
    static func createDownloadAction(handler: @escaping UIContextualAction.Handler) -> UIContextualAction {
        createBasicSwipeAction(style: .normal, title: "Download", image: UIImage(systemName: "square.and.arrow.down"), backgroundColor: nil, handler: handler)
    }

}
