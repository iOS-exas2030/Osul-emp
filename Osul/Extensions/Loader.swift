//
//  Loader.swift
//  
//
//  Created by Sayed Abdo on 9/13/20.
//

import UIKit

//protocol SpinnerView {
//    func ShowSpinner()
//    func HideSpinner()
//}
//
//class MSLoadingView: UIView {
//
//    let blackView: UIView = {
//        let bv = UIView()
//        bv.backgroundColor = UIColor.white
//        bv.cornerRadius = 15
//        //bv.setupDefaultShadow()
//        return bv
//    }()
//
//    let mainView: UIView = {
//        let mView = UIView()
//        return mView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//     //   backgroundColor = UIColor.middleColor.withAlphaComponent(0.4)//.clear
////        InsideColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
////        OutsideColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2643407534)
//        addSubview(blackView)
//        blackView.anchorSize(to: self, size: CGSize(width: 100, height: 100), center: true)
//
//        //        blackView.contentView.addSubview(activityIndicator)
//        //        activityIndicator.anchorSize(to: blackView.contentView, size: .zero, center: true)
//        addSubview(mainView)
//        mainView.anchor(top: blackView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), centerX: true, toView: blackView)
//    }
//
//}
//
//extension UIViewController {
//    public func StartLoading() {
//        DispatchQueue.main.async { [weak self] in
//            self?.showApplicationNetworkActivityIndicator()
//            guard let window = UIApplication.shared.keyWindow else { return }
//            let view = MSLoadingView(frame: window.frame)
//            window.addSubview(view)
//         //  view.activityIndicator.startAnimating()
//         //  Transition.transition(with: window)
//        }
//    }
//
//    public func StopLoading() {
//        DispatchQueue.main.async { [weak self] in
//            guard let window = UIApplication.shared.keyWindow else { return }
//            self?.hideApplicationNetworkActivityIndicator()
//            window.subviews.forEach {
//                if let msLoaderView = $0 as? MSLoadingView {
//            //    msLoaderView.activityIndicator.stopAnimating()
//                msLoaderView.removeFromSuperview()
//                }
//            }
//         //   Transition.transition(with: window)
//        }
//    }
//
//    // MARK: - Helpers
//    private func showApplicationNetworkActivityIndicator() {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    private func hideApplicationNetworkActivityIndicator() {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//
//}
//
//
//extension UIView {
//
//    public func fillSuperView(padding: UIEdgeInsets = .zero) {
//        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
//    }
//
//    public func anchorSize(to view: UIView, size: CGSize = .zero, center: Bool = false, xConstant: CGFloat = 0, yConstant: CGFloat = 0) {
//        translatesAutoresizingMaskIntoConstraints = false
//        widthAnchor.constraint(equalToConstant: size.width) .isActive = true
//        heightAnchor.constraint(equalToConstant: size.height).isActive = true
//        if center {
//            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConstant).isActive = true
//            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant).isActive = true
//        }
//    }
//
//    @discardableResult
//    public func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero, centerX: Bool = false, centerY: Bool = false, toView: UIView = UIView()) -> [NSLayoutConstraint?] {
//        translatesAutoresizingMaskIntoConstraints = false
//        var topanchor: NSLayoutConstraint?
//        var leadinganchor: NSLayoutConstraint?
//        var trailinganchor: NSLayoutConstraint?
//        var bottomanchor: NSLayoutConstraint?
//
//        var widthanchor: NSLayoutConstraint?
//        var heightanchor: NSLayoutConstraint?
//
//        if let top = top { topanchor = topAnchor.constraint(equalTo: top, constant: padding.top)
//            topanchor?.isActive = true }
//        if let leading = leading { leadinganchor = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
//            leadinganchor?.isActive = true }
//        if let bottom = bottom { bottomanchor = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
//            bottomanchor?.isActive = true }
//        if let trailing = trailing { trailinganchor = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
//            trailinganchor?.isActive = true }
//
//        if size.width != 0 { widthanchor = widthAnchor.constraint(equalToConstant: size.width)
//            widthanchor?.isActive = true }
//        if size.height != 0 { heightanchor = heightAnchor.constraint(equalToConstant: size.height)
//            heightanchor?.isActive = true }
//
//        if centerX { centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true }
//         if centerY { centerYAnchor.constraint(equalTo: toView.centerYAnchor).isActive = true }
//
//        return [topanchor, leadinganchor, bottomanchor, trailinganchor, widthanchor, heightanchor]
//    }
//
//    public func addConstraintsWithFormat(format: String, views: UIView...) {
//        var viewsDictionary = [String: UIView]()
//        for (index, view) in views.enumerated() {
//            let key = "v\(index)"
//            viewsDictionary[key] = view
//            view.translatesAutoresizingMaskIntoConstraints = false
//        }
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
//    }
//}

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
extension UIViewController {
    public func StartLoading() {
        DispatchQueue.main.async { [weak self] in
           
        }
    }

    public func StopLoading() {
        DispatchQueue.main.async { [weak self] in
            
        }
    }
}
