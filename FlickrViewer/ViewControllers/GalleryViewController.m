//
//  GalleryViewController.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "GalleryViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "SearchService.h"
#import "Photo.h"
#import "GalleryDataSource.h"

@interface GalleryViewController () <UICollectionViewDelegate, CLLocationManagerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) GalleryDataSource *galleryDataSource;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSTimer *searchTimer;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UILabel *loadingMessageLabel;
@property (nonatomic, weak) IBOutlet UIView *locationPermissionView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)requestLocationPermission;

- (void)showError:(NSString *)errorMessage;
- (void)showLoadingWithMessage:(NSString *)message;
- (void)hideLoading;
- (void)searchTimerFired;
- (void)updateSearchRequest:(CLLocation *)location searchTerm:(NSString *)searchTerm;

@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.galleryDataSource = [[GalleryDataSource alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.showsCancelButton = NO;
    self.searchController.searchBar.tintColor = [UIColor redColor];
    self.searchController.searchBar.placeholder = @"Keyword search";
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.collectionView.dataSource = self.galleryDataSource;
    self.navigationItem.titleView = self.searchController.searchBar;
    
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

- (void)searchTimerFired
{
    [self updateSearchRequest:self.locationManager.location searchTerm:self.searchController.searchBar.text];
}

- (void)updateSearchRequest:(CLLocation *)location searchTerm:(NSString *)searchTerm
{
    [self showLoadingWithMessage:@"Loading photos"];
    [self.galleryDataSource refreshPhotosWithLocation:location searchTerm:searchTerm completion:^(BOOL success, NSError *error) {
        NSLog(@"refresh response");
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
