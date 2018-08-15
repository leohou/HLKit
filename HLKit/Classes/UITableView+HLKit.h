//
//  UITableView+HLKit.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/15.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (HLKit)
- (void)updateWithBlock:(void (^)(UITableView *tableView))block;


- (void)scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;


- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;


- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;


- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;


- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;


- (void)clearSelectedRowsAnimated:(BOOL)animated;

@end
