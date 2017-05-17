//
//  FilterTagsViewController.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 17/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "FilterTagsViewController.h"

#import "FilterTagCell.h"

@interface FilterTagsViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, copy) FilterTagsSelectionBlock completionBlock;
@property (nonatomic, strong) NSMutableArray *selectedTags;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;

- (BOOL)tagIsSelected:(NSString *)tag;

- (IBAction)doneFiltering:(id)sender;
- (IBAction)cancelFiltering:(id)sender;

@end

@interface FilterTagsPresentationController : UIPresentationController

@property (nonatomic, strong) UIView *dimmingView;

@end

@implementation FilterTagsViewController

- (instancetype)init
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ((self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])]))
    {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        _selectedTags = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)initWithAvailableTags:(NSArray<NSString *> *)availableTags completion:(FilterTagsSelectionBlock)completionBlock
{
    if ((self = [self init]))
    {
        _availableTags = [NSArray arrayWithArray:availableTags];
        _completionBlock = [completionBlock copy];
    }
    
    return self;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.availableTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTagCell *cell = [tableView dequeueReusableCellWithIdentifier:[FilterTagCell cellIdentifier] forIndexPath:indexPath];
    NSString *tag = self.availableTags[indexPath.row];
    [cell populateWithTag:tag selected:[self tagIsSelected:tag]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tag = self.availableTags[indexPath.row];
    BOOL selected = [self tagIsSelected:tag];
    
    selected ? [self.selectedTags removeObject:tag] : [self.selectedTags addObject:tag];
    FilterTagCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setTagSelected:!selected];
}

#pragma mark - Button actions

- (IBAction)doneFiltering:(id)sender
{
    if (self.completionBlock)
    {
        self.completionBlock(self.selectedTags);
    }
}

- (IBAction)cancelFiltering:(id)sender
{
    if (self.completionBlock)
    {
        self.completionBlock(nil);
    }
}

#pragma mark - Private

- (BOOL)tagIsSelected:(NSString *)tag
{
    return [self.selectedTags containsObject:tag];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[FilterTagsPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@implementation FilterTagsPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    if ((self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]))
    {
        _dimmingView = [[UIView alloc] initWithFrame:self.presentingViewController.view.bounds];
        _dimmingView.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)presentationTransitionWillBegin
{
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0.0;
    
    [self.containerView insertSubview:self.dimmingView atIndex:0];
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.6;
    } completion:nil];
}

- (void)dismissalTransitionWillBegin
{
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.0;
    } completion:nil];
}

- (void)containerViewWillLayoutSubviews
{
    self.dimmingView.frame = self.containerView.frame;
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}

- (CGRect)frameOfPresentedViewInContainerView
{
    return CGRectMake(0.0, self.containerView.bounds.size.height/2, self.containerView.bounds.size.width, self.containerView.bounds.size.height/2);
}

@end

