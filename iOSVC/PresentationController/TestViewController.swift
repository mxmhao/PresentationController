//
//  TestViewController.swift
//  iOSVC
//
//  Created by min on 2017/6/11.
//  Copyright © 2017年 min. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        //自定义呈现，这两个操作必须放在init方法中
        modalPresentationStyle = .custom  //这个很重要
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("TestViewController -- 释放")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 10    //只设置这一个，自己会有剪切，子视图不会被剪切
//        view.clipsToBounds = true     //剪切超过的子视图
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = XMAlertPresentationController(presentedViewController: presented, presenting: presenting)
//        pc.delegate = pc as UIAdaptivePresentationControllerDelegate    //某种情况下需要调整呈现形式，这个代理就很有用 .fullScreen
        return pc
    }
    
    
    /*
     //这两个是设置转场动画
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    
    //这两个是给上面的设置的转场动画添加交互控制
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    */
}

//present or dismiss 两个过程实现
class XMAlertPresentationController: UIPresentationController {
    //UIAlertController也用到了两个view
    var view: UIView?       //此试图包含一个点击手势
    var bgView: UIView?     //不能交互的视图
    
    deinit {
        print("XMAlertSheetPresentationController -- 释放")
    }
    
    //呈现动画将要开始
    override func presentationTransitionWillBegin() {
        //
        view = UIView(frame: (containerView?.bounds)!)
        view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAction)))//给一个点击退出手势，仿UIAlertController
        view?.backgroundColor = UIColor(white: 0, alpha: 0)    //这个一定要的，不然下面的动画就没效果了
        containerView?.addSubview(view!)
        
        bgView = UIView(frame: (containerView?.bounds)!)
        bgView?.isUserInteractionEnabled = false
        containerView?.addSubview(bgView!)
        
        //通过使用「负责呈现」的 controller 的 UIViewControllerTransitionCoordinator，我们可以确保我们的动画与其他动画一道儿播放。
        //背景色变动画，使用present or dismiss默认的动画实现
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            return
        }
        transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in//动画0.4秒
            self.view?.backgroundColor = UIColor(white: 0, alpha: 0.4)
        })
    }
    
    //呈现动画已结束
    override func presentationTransitionDidEnd(_ completed: Bool) {
        // 如果呈现没有完成，那就移除背景 View，没有完成就是出了错误
        if !completed {
            view?.removeFromSuperview()
            bgView?.removeFromSuperview()
        }
    }
    
    //消失动画将要开始
    override func dismissalTransitionWillBegin() {
        //背景色变动画，使用present or dismiss默认的动画实现
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            return
        }
        transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.view?.backgroundColor = UIColor(white: 0, alpha: 0.0)
        })
    }
    
    //消失动画已结束
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            view?.removeFromSuperview()
            bgView?.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let size = containerView!.bounds.size
        if presentedViewController.preferredInterfaceOrientationForPresentation.isLandscape {//竖屏
            let width = size.height - 20
            return CGRect(x: (size.width - width)/2.0, y: size.height - 270, width: width, height: 260)
        }
        return CGRect(x: 10, y: size.height - 270, width: size.width - 20, height: 260)
    }
    
    //当前横竖屏变换时调用，调整自己写的视图，presentedView == presentedViewController.view
    open override func containerViewWillLayoutSubviews() {
        view?.frame = containerView!.frame
        bgView?.frame = containerView!.frame
        //当屏幕旋转后presentedView的frame需要自己调整，所以下面一行是必须的
        presentedView?.frame = frameOfPresentedViewInContainerView  //这行是必须的
    }

    func dismissAction() {
        presentedViewController.dismiss(animated: true)
    }
}
