//
//  TEDVideoTableViewController.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDVideoTableViewController.h"
#import "TEDVideoPreviewCell.h"
#import "TEDDetailedInfoController.h"
#import "TEDItem.h"
#import "TEDItemService.h"

@interface TEDVideoTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) NSMutableArray<TEDItem *> *filteredDataSource;
@property (assign, nonatomic) BOOL isFiltered;
@property (assign, nonatomic) CGFloat lastContentOffset;

@end

@implementation TEDVideoTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:TEDVideoPreviewCell.class forCellReuseIdentifier:@"TEDVideoPreviewCellId"];
    
//    self.navigationItem.hidesSearchBarWhenScrolling = NO;
//    [self.navigationController setHidesBarsOnSwipe:YES];
    
    self.view.backgroundColor = [UIColor colorNamed:@"background_color"];
    [self setupSearchController];
    self.isFiltered = NO;
}

#pragma mark - Images loading

- (void)loadImageForIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
     
    if (self.isFiltered) {
        if ([self isSafeFilteredDataSourceIndex:indexPath.row]) {
            TEDItem *item = self.filteredDataSource[indexPath.row];
            [self.itemService loadImageForURL:item.imageURL completion:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([weakSelf isSafeFilteredDataSourceIndex:indexPath.row]) {
                        weakSelf.filteredDataSource[indexPath.row].image = image;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                });
            }];
        }
    } else {
        TEDItem *item = self.dataSource[indexPath.row];
        [self.itemService loadImageForURL:item.imageURL completion:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dataSource[indexPath.row].image = image;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            });
        }];
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.lastContentOffset < scrollView.contentOffset.y && self.navigationItem.searchController.isActive) {
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        }];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.y;
}

#pragma mark - Section header configuration

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 0, 0)];
    
    [label setFont:[UIFont systemFontOfSize:23 weight:UIFontWeightBold]];
    [label setTextColor:[UIColor colorNamed:@"title_color"]];
    [label setText:[NSString stringWithFormat:@"All videos"]];
    [label sizeToFit];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorNamed:@"background_color"]];

    return view;
}

#pragma mark - SearchController configuration

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length != 0) {
        self.isFiltered = NO;
        [self.tableView reloadData];
    }
}

- (void)setDataSource:(NSArray<TEDItem *> *)dataSource {
    _dataSource = dataSource;

    if (self.isFiltered) {
        [self searchBar:self.navigationItem.searchController.searchBar textDidChange:self.navigationItem.searchController.searchBar.text];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isFiltered = NO;
        [self.tableView reloadData];
    }
    else {
        self.isFiltered = YES;
        
        if (self.dataSource.count > 0) {
            self.filteredDataSource = [NSMutableArray new];
            
            for (TEDItem *item in self.dataSource) {
                [self.itemService cancelDownloadingForUrl:item.imageURL];
                
                NSRange titleRange = [item.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
                NSRange speakerRange = [item.speaker rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleRange.location != NSNotFound || speakerRange.location != NSNotFound) {
                    [self.filteredDataSource addObject:item];
                }
            }
            
            [self.tableView reloadData];
        }
    }
}

- (void)setupSearchController {
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.obscuresBackgroundDuringPresentation = NO;
//    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.searchBar.placeholder = @"Search";
    searchController.searchBar.delegate = self;
    searchController.delegate = self;
    self.definesPresentationContext = true;
    searchController.searchBar.backgroundColor = [UIColor colorNamed:@"background_color"];
    self.navigationItem.searchController = searchController;
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}

#pragma mark - StatusBar configuration

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isFiltered ? self.filteredDataSource.count : self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 148;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDVideoPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TEDVideoPreviewCellId" forIndexPath:indexPath];
    
    UIView *customColorView = [[UIView alloc] init];
       customColorView.backgroundColor = [UIColor colorNamed:@"baritem_color"];
    cell.selectedBackgroundView =  customColorView;
    
    TEDItem *item;
    if (self.isFiltered && [self isSafeFilteredDataSourceIndex:indexPath.row]) {
            item = self.filteredDataSource[indexPath.row];
    } else {
        item = self.dataSource[indexPath.row];
    }
    
    if (item != nil) {
        if (!item.image) {
            [self loadImageForIndexPath:indexPath];
        }
        [cell setupCellWithItem:item];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isFiltered) {
        TEDItem *item = self.dataSource[indexPath.row];
        [self.itemService cancelDownloadingForUrl:item.imageURL];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TEDDetailedInfoController *detailedVC = [[TEDDetailedInfoController alloc] initWithItem:self.dataSource[indexPath.row]];
    [self.navigationController pushViewController:detailedVC animated:YES];
}



- (BOOL)isSafeFilteredDataSourceIndex:(NSInteger)index {
    return self.filteredDataSource.count > index;
}

@end

