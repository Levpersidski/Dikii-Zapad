//
//  UIImage + Extension.swift
//  Dikii Zapad
//
//  Created by mac on 21.01.2024.
////
//
//import Foundation
//import Kingfisher
//
//extension UIImageView {
//    @discardableResult
//    public func kfSetImage(
//        with resource: Resource?,
//        placeholder: Placeholder? = nil,
//        options: KingfisherOptionsInfo? = nil,
//        progressBlock: DownloadProgressBlock? = nil,
//        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask?
//    {
//        var newOptions = WLURLSession.getRetryOptions(resource, options)
//        newOptions.append(.diskCacheAccessExtendingExpiration(.none))
//        
////        var newResource = resource
////        switch DataStore.shared.testRetryStartegyMode {
////        case .newDomain:
////            newResource = WLURLSession.getRetryURL(resource?.downloadURL) ?? resource
////        case .forceRetry:
////            if let url = resource?.downloadURL {
////                newResource = url.badCopy()
////            }
////        case .noHttpRequests:
////            if let url = resource?.downloadURL {
////                newResource = url.badCopy()
////            }
////            newOptions = options ?? []
////        default:
////            break
////        }
//        
//        return self.kf.setImage(with: resource,
//                                placeholder: placeholder,
//                                options: newOptions,
//                                progressBlock: progressBlock,
//                                completionHandler: completionHandler)
//    }
//}
