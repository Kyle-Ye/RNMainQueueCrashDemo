//
//  ViewController.swift
//  ReproducerApp
//
//  Created by Kyle on 2024/11/16.
//

import UIKit
import React


@objc(ViewController)
class ViewController: UIViewController {
  private var dataSource: UICollectionViewDiffableDataSource<Int, String>! = nil

  
  override func viewDidLoad() {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    view.addSubview(collectionView)
    // Make view and collectionView edges equal constraint
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    let cellRegistration = UICollectionView.CellRegistration<Cell, String> { cell, indexPath, item in
      cell.backgroundColor = .red
    }
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
    
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([0])
    dataSource.apply(snapshot, animatingDifferences: true)
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    var snapshot = dataSource.snapshot()
    snapshot.appendItems(["1", "2", "3"], toSection: 0)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

class Cell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var rnView: UIView!
  
  private func setupUI() {
    let url = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
    rnView = RCTRootView(
      bundleURL: url!,
      moduleName: "ReproducerApp",
      initialProperties: [:]
    )
    contentView.addSubview(rnView)
    
    // Uncomment to use onMainQueue to workaround the assert or cycle sync crash issue in ReactNative code
//    DispatchQueue.onMainQueue { [self] in
//      rnView = RCTRootView(
//        bundleURL: url!,
//        moduleName: "ReproducerApp",
//        initialProperties: [:]
//      )
//      contentView.addSubview(rnView)
//    }
  }
}


extension DispatchQueue {
    /// Run the action immediately if it's on the main thread, otherwise dispatch it to the main thread asynchronously.
    public static func onMainThread(_ action: @escaping () -> Void) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.async {
                action()
            }
        }
    }
    
    /// Run the action immediately if it's on the main queue, otherwise dispatch it to the main queue asynchronously.
    public static func onMainQueue(_ action: @escaping () -> Void) {
        if Thread.isMainThread && DispatchQueue.currentQueueLabel == DispatchQueue.main.label {
            action()
        } else {
            DispatchQueue.main.async {
                action()
            }
        }
    }
    
    private static var currentQueueLabel: String {
        let label = __dispatch_queue_get_label(nil)
        return String(cString: label)
    }
}
