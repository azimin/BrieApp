//
//  AZTabBarController.swift
//  TabBarWithView
//
//  Created by Alex Zimin on 27/07/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//

import UIKit

class AZTabBarItemView: UIView {
  var heightValue: CGFloat?
  var preferedHeight: CGFloat {
    return heightValue ?? _preferedHeight
  }
  
  private var _preferedHeight: CGFloat = 49
  
  private(set) var index: Int = 0
  private(set) var isSelected: Bool = false 
  
  func setSelected(selected: Bool, animated: Bool) { }
}

class AZTabBarItem: UITabBarItem {
  private var containerView: AZTabBarItemView!
  
  var index: Int {
    return containerView.index
  }
  
  private(set) var isSelected: Bool = false {
    didSet {
      containerView.isSelected = isSelected
    }
  }
  
  private func setSelected(selected: Bool, animated: Bool) { 
    isSelected = selected
    containerView.setSelected(selected, animated: animated)
  }
}

class AZTabBar: UITabBar {
  @IBInspectable var preferedHeight: CGFloat = 49
  
  override func sizeThatFits(size: CGSize) -> CGSize {
    var size = super.sizeThatFits(size)
    size.height = preferedHeight
    return size
  }
}

extension UIViewController {
  func az_tabBarItemContentView() -> AZTabBarItemView {
    fatalError("Must be implemented in subclass")
  }
  
  var az_tabBarController: AZTabBarController? {
    return self.tabBarController as? AZTabBarController
  }
}

class AZTabBarController: UITabBarController {
  
  var az_items: [AZTabBarItem] {
    return tabBar.items as? [AZTabBarItem] ?? []
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createViewContainers()
  }
  
  private var maxHeight: CGFloat = 0
  // MARK: - Setup
  
  func createViewContainers() {
    var containersDict = [String: UIView]()
    let itemsCount: Int = az_items.count - 1
    
    for (index, item) in az_items.enumerate() {
      let viewContainer = setupViewOnItem(item, index: index)
      viewContainer.index = index
      containersDict["container\(index)"] = viewContainer
    }
    
    var formatString = "H:|-(0)-[container0]"
    for index in 1..<itemsCount + 1 {
      formatString += "-(0)-[container\(index)(==container0)]"
    }
    formatString += "-(0)-|"
    
    let constranints = NSLayoutConstraint.constraintsWithVisualFormat(formatString,
      options:NSLayoutFormatOptions.DirectionLeftToRight,
      metrics: nil,
      views: containersDict)
    view.addConstraints(constranints)
    
    self.tabBar.alpha = 0.0
  }
  
  func setupViewOnItem(item: AZTabBarItem, index: Int) -> AZTabBarItemView {
    let viewContainer = tabBarItemForViewController(self.viewControllers![index])
    viewContainer._preferedHeight = (self.tabBar as? AZTabBar)?.preferedHeight ?? 49
    
    viewContainer.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(viewContainer)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AZTabBarController.tapHandler(_:)))
    tapGesture.numberOfTouchesRequired = 1
    viewContainer.addGestureRecognizer(tapGesture)
    
    let constY = NSLayoutConstraint(item: viewContainer,
      attribute: NSLayoutAttribute.Bottom,
      relatedBy: NSLayoutRelation.Equal,
      toItem: view,
      attribute: NSLayoutAttribute.Bottom,
      multiplier: 1,
      constant: 0)
    
    view.addConstraint(constY)

    let constH = NSLayoutConstraint(item: viewContainer,
      attribute: NSLayoutAttribute.Height,
      relatedBy: NSLayoutRelation.Equal,
      toItem: nil,
      attribute: NSLayoutAttribute.NotAnAttribute,
      multiplier: 1,
      constant: viewContainer.preferedHeight)
    viewContainer.addConstraint(constH)
    
    item.containerView = viewContainer
    
    if index == 0 {
      item.setSelected(true, animated: false)
    } else {
      item.setSelected(false, animated: false)
    }
    
    maxHeight = max(maxHeight, viewContainer.preferedHeight)
    return viewContainer
  }
  
  func tabBarItemForViewController(viewController: UIViewController) -> AZTabBarItemView {
    if let navigationController = viewController as? UINavigationController {
      return navigationController.viewControllers.first?.az_tabBarItemContentView() ?? viewController.az_tabBarItemContentView()
    }
    return viewController.az_tabBarItemContentView()
  }
  
  private(set) var isHidden: Bool = false
  
  func setHidden(hidden: Bool, animated: Bool) {
    self.isHidden = hidden
    
    for contraint in view.constraints {
      if contraint.firstAttribute == NSLayoutAttribute.Bottom, let item = contraint.firstItem as? AZTabBarItemView {
        contraint.constant = hidden ? item.preferedHeight : 0
      }
    }
    
    UIView.animateWithDuration(animated ? 0.35 : 0) { () -> Void in
      self.view.layoutIfNeeded()
    }
  }
  
  func setHiddenProgress(value: CGFloat) {
    for contraint in view.constraints {
      if contraint.firstAttribute == NSLayoutAttribute.Bottom, let item = contraint.firstItem as? AZTabBarItemView {
        contraint.constant = item.preferedHeight * (1 - value)
      }
    }
  }
  
  // MARK: - Action
  
  func tapHandler(gesture: UIGestureRecognizer) {
    let currentIndex = (gesture.view as! AZTabBarItemView).index
    az_setSelectedIndex(currentIndex)
  }
  
  func az_setSelectedIndex(currentIndex: Int) {
    if selectedIndex != currentIndex {
      let selectedItem: AZTabBarItem = az_items[currentIndex]
      selectedItem.setSelected(true, animated: true)
      
      let deselectedItem = az_items[selectedIndex]
      deselectedItem.setSelected(false, animated: true)
      
      selectedIndex = currentIndex
    }
  }
}


