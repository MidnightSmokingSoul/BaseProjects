//
//  Refresh.swift
//  MJRefresh刷新
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit
import MJRefresh

struct Refresh {
    
    static let shaer = Refresh()
    
    func setupRefresh(scrollView: UIScrollView, refreshingHeader refreshingHeaderBlock: @escaping () -> (), refreshingFooter refreshingFooterBlock: @escaping () -> ()) {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            refreshingHeaderBlock()
        })
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        scrollView.mj_header = header
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            refreshingFooterBlock()
        })
        footer.setTitle("到底啦~", for: .noMoreData)
        scrollView.mj_footer = footer
    }
    
    func endRefreshing(scrollView: UIScrollView){
        scrollView.mj_header?.endRefreshing()
        scrollView.mj_footer?.endRefreshing()
    }
    
    func endRefreshingWithNoMoreData(scrollView: UIScrollView) {
        scrollView.mj_footer?.endRefreshingWithNoMoreData()
    }
    
}

@objcMembers
class RefreshClass {
    
    static let shaer = Refresh()
    
    func setupRefresh(scrollView: UIScrollView, refreshingHeader refreshingHeaderBlock: @escaping () -> (), refreshingFooter refreshingFooterBlock: @escaping () -> ()) {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            refreshingHeaderBlock()
        })
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        scrollView.mj_header = header
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            refreshingFooterBlock()
        })
        footer.setTitle("到底啦~", for: .noMoreData)
        scrollView.mj_footer = footer
    }
    
    func endRefreshing(scrollView: UIScrollView){
        scrollView.mj_header?.endRefreshing()
        scrollView.mj_footer?.endRefreshing()
    }
    
    func endRefreshingWithNoMoreData(scrollView: UIScrollView) {
        scrollView.mj_footer?.endRefreshingWithNoMoreData()
    }
    
}
