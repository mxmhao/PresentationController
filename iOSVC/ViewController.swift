//
//  ViewController.swift
//  iOSVC
//
//  Created by min on 2017/6/11.
//  Copyright © 2017年 min. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var rightItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func popAction(_ sender: Any) {
        /*//方式一：
        let vc = UIAlertController(title: "测试UIAlertController", message: nil, preferredStyle: .actionSheet)
        
        vc.addAction(UIAlertAction(title: "default", style: .default))
        vc.addAction(UIAlertAction(title: "cancel", style: .cancel))
        vc.addAction(UIAlertAction(title: "destructive", style: .destructive))
        //actionSheet方式 这个在iPhone上没效果，在iPad是气泡效果
        vc.popoverPresentationController?.barButtonItem = rightItem
        //这个和上面的相同，这两个必须同时使用？
//        vc.popoverPresentationController?.sourceRect = //
//        vc.popoverPresentationController?.sourceView =
        */
        
        
        let vc = UIViewController()
        vc.modalPresentationStyle = .popover    //这个
        vc.popoverPresentationController?.barButtonItem = rightItem
        present(vc, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "自定义 UIPresentationController"
        case 1:
            cell.textLabel?.text = "系统 UIAlertController -- actionsheet"
        case 2:
            cell.textLabel?.text = "系统 UIAlertController -- alert"
        default: break
            //
        }
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.row {
        case 0:
            testUIPresentationController()
        case 1:
            testActionSheet()
        case 2:
            testAlert()
        default: break
            //
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func testUIPresentationController() {
        //
        let vc = TestViewController();
        self.present(vc, animated: true)
    }
    
    func testActionSheet() {
        let vc = UIAlertController(title: "测试UIAlertController", message: nil, preferredStyle: .actionSheet);
        
        vc.addAction(UIAlertAction(title: "default", style: .default))
        vc.addAction(UIAlertAction(title: "cancel", style: .cancel))
        vc.addAction(UIAlertAction(title: "destructive", style: .destructive))
        print("--> \(vc.modalPresentationStyle == .custom) -- \(UIModalPresentationStyle.custom.rawValue)")
        
        self.present(vc, animated: true)
        print("modalPresentationStyle: \(vc.modalPresentationStyle.rawValue)\nmodalTransitionStyle: \(vc.modalTransitionStyle.rawValue)")
        
        vc.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            print(#line, UIViewControllerTransitionCoordinatorContext.transitionDuration)//0.404秒
        })
        
        vc.presentationController!.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            print(#line, UIViewControllerTransitionCoordinatorContext.transitionDuration)
        })
    }
    
    func testAlert() {
        let vc = UIAlertController(title: "测试UIAlertController", message: nil, preferredStyle: .alert);
        
        vc.addAction(UIAlertAction(title: "default", style: .default))
        vc.addAction(UIAlertAction(title: "cancel", style: .cancel))
        vc.addAction(UIAlertAction(title: "destructive", style: .destructive))
        print("--> \(vc.modalPresentationStyle == .custom) -- \(UIModalPresentationStyle.custom.rawValue)")
        
        let time = CFAbsoluteTimeGetCurrent()
        self.present(vc, animated: true) {
            print(CFAbsoluteTimeGetCurrent() - time)
        }
        
        print(vc.presentationController!)
        print(vc.presentationController!.presentingViewController)
        vc.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            print(#line, UIViewControllerTransitionCoordinatorContext.transitionDuration)
        })
        vc.presentationController!.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            print(#line, UIViewControllerTransitionCoordinatorContext.transitionDuration)
        })
    }
}

