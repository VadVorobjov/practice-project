////
////  TaskInitiationCollectionView.swift
////  ThriveApp
////
////  Created by Vadims Vorobjovs on 21/03/2023.
////
//
//import UIKit
//import SwiftUI
//
//protocol TaskInitiationData: Hashable {
//    var name: String { get }
//    var text: String { get }
//}
//
//enum TaskInitiationType: String {
//    case name = "Name"
//    case description = "Description"
//}
//
//final class TaskInitiationCollectionView {
//
//    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCollectionViewLayout())
//    var dataSource: UICollectionViewDiffableDataSource<TaskInitiationType, AnyHashable>
//
//    private init() {
////        setupCollectionViewDataSource()
//    }
//
//    private func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
//        let layout = UICollectionViewCompositionalLayout { _, environment -> NSCollectionLayoutSection? in
//
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .fractionalWidth(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: .absolute(60))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                           subitems: [item])
//
//            let section = NSCollectionLayoutSection(group: group)
//
//            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
//
//            // TODO: Do we need it?
//            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
//                                                                            elementKind: UICollectionView.elementKindSectionHeader,
//                                                                            alignment: .top)
//            sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 0)
//            section.boundarySupplementaryItems = [sectionHeader]
//
//            return section
//        }
//
//        return layout
//    }
//
//    private func setupCollectionViewDataSource() {
//        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, TaskInitiationData> { cell, indexPath, item in
//            // TODO: depending on section type
//            cell.contentConfiguration = UIHostingConfiguration {
////                TaskNameInitiationCell(data: nil)
//            }
//        }
//
//
//    }
//}
//
//
////private func setupCollectionViewDataSource() {
////let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, ToDoListItem> { cell, indexPath, item in
////          cell.contentConfiguration = UIHostingConfiguration {
////              CellView(toDoListItem: item)
////          }
////      }
////
////    /// Create a datasource and connect it to  collection view `collectionView`
////    dataSource = UICollectionViewDiffableDataSource<ToDoListItemType, ToDoListItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: ToDoListItem) -> UICollectionViewCell? in
////
////        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
////
////        return cell
////    }
////}
