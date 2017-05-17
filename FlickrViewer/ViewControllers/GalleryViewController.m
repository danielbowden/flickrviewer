//
//  GalleryViewController.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "GalleryViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "Photo.h"
#import "GalleryDataSource.h"
#import "PhotoViewController.h"
#import "UIImage+FlickrViewer.h"
#import "FilterTagsViewController.h"

@interface GalleryViewController () <UICollectionViewDelegate, CLLocationManagerDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) GalleryDataSource *galleryDataSource;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSTimer *searchTimer;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *searchContainer;
@property (nonatomic, weak) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UILabel *loadingMessageLabel;
@property (nonatomic, weak) IBOutlet UIView *locationPermissionView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)requestLocationPermission;

- (void)configureSearchController;
- (void)showError:(NSString *)errorMessage;
- (void)showLoadingWithMessage:(NSString *)message;
- (void)hideLoading;
- (void)searchTimerFired;
- (void)updateSearchRequest:(CLLocation *)location searchTerm:(NSString *)searchTerm;
- (void)filterByTags;

@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.galleryDataSource = [[GalleryDataSource alloc] init];
    self.collectionView.dataSource = self.galleryDataSource;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterByTags)];
    
    [self configureSearchController];
    
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self showLoadingWithMessage:@"Locating"];
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        self.locationPermissionView.hidden = NO;
        self.collectionView.alpha = 0.0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchController.active = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.searchTimer)
    {
        [self.searchTimer invalidate];
    }
}

#pragma mark - LocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [manager stopUpdatingLocation];
    manager.delegate = nil;

    [self updateSearchRequest:locations.lastObject searchTerm:self.searchController.searchBar.text];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    [self showError:@"Unable to determine location. You can either manually search for a photo or retry."];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self showLoadingWithMessage:@"Locating"];
        [manager startUpdatingLocation];
    }
}

#pragma mark - UISearchResultsUpdating delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //Debounce the search bar input
    if (self.searchTimer)
    {
        [self.searchTimer invalidate];
    }
    
    if (searchController.searchBar.text.length)
    {
        self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(searchTimerFired) userInfo:nil repeats:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.searchController.active = NO;
}

#pragma mark - UISearchControllerDelegate

- (void)didDismissSearchController:(UISearchController *)searchController
{
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    searchBarFrame.size.width = self.view.frame.size.width;
    self.searchController.searchBar.frame = searchBarFrame;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    searchBar.placeholder = selectedScope == GallerySearchScopeKeyword ? @"Keyword search" : @"Tag search";
    searchBar.text = @"";
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchController.active = NO;
    Photo *photo = [self.galleryDataSource photoAtIndex:indexPath.row];
    PhotoViewController *viewController = [[PhotoViewController alloc] initWithPhoto:photo];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Button actions

- (IBAction)requestLocationPermission
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else
    {
        NSString *message = @"Location services unavailable, you can either manually search for a photo or to see nearby photos please enable Location Services in Settings";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Private methods

- (void)configureSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.showsCancelButton = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.tintColor = [UIColor redColor];
    self.searchController.searchBar.placeholder = @"Keyword search";
    self.searchController.searchBar.scopeButtonTitles = @[GallerySearchScopeTitle[0], GallerySearchScopeTitle[1]];
    
    self.searchController.searchBar.scopeBarBackgroundImage = [UIImage imageWithColor:[UIColor greenColor]];
    self.searchController.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor greenColor]];
    
    [self.searchContainer addSubview:self.searchController.searchBar];
}

- (void)searchTimerFired
{
    [self updateSearchRequest:self.locationManager.location searchTerm:self.searchController.searchBar.text];
}

- (void)updateSearchRequest:(CLLocation *)location searchTerm:(NSString *)searchTerm
{
    [self showLoadingWithMessage:@"Loading photos"];
    [self.galleryDataSource searchPhotosWithLocation:location searchText:searchTerm scope:self.searchController.searchBar.selectedScopeButtonIndex completion:^(BOOL success, NSError *error) {
        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf hideLoading];
            
            if (success)
            {
                [weakSelf.collectionView setContentOffset:CGPointZero animated:NO];
                [weakSelf.collectionView reloadData];
            }
            else
            {
                [self showError:error.localizedDescription];
            }
        });
    }];
}

- (void)filterByTags
{
    self.searchController.active = NO;
    __weak typeof(self)weakSelf = self;
    FilterTagsViewController *filterViewController = [[FilterTagsViewController alloc] initWithAvailableTags:[self.galleryDataSource availableTags] completion:^(NSArray<NSString *> *selectedTags) {
        
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                
                if (selectedTags.count)
                {
                    [weakSelf.galleryDataSource filterByTags:selectedTags completion:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.collectionView setContentOffset:CGPointZero animated:NO];
                            [weakSelf.collectionView reloadData];
                        });
                    }];
                }
                
            }];
    }];
    
    [self presentViewController:filterViewController animated:YES completion:nil];
}

- (void)showLoadingWithMessage:(NSString *)message
{
    self.locationPermissionView.hidden = YES;
    self.collectionView.alpha = 0.0;
    self.loadingMessageLabel.text = message;
    self.loadingView.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)hideLoading
{
    self.locationPermissionView.hidden = YES;
    self.collectionView.alpha = 1.0;
    self.loadingView.hidden = YES;
    [self.activityIndicator stopAnimating];
}

- (void)showError:(NSString *)errorMessage
{
    if (!self.presentedViewController)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.locationManager startUpdatingLocation];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self hideLoading];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//Handle search bar in orientation/rotation change
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGRect searchBarFrame = self.searchController.searchBar.frame;
        searchBarFrame.size.width = self.view.frame.size.width;
        self.searchController.searchBar.frame = searchBarFrame;
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
