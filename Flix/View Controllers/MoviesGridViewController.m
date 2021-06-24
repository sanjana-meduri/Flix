//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Sanjana Meduri on 6/24/21.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h" //need this to use cell template from storyboard -- MUST SET ID AND NAME TO THIS
#import "UIImageView+AFNetworking.h" //to add methods to ImageView


@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
}

- (void)fetchMovies {
    //setting up network request
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               //create an alert if there is no network connection
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Connection Failed" message:@"It looks like you are not connected to the Internet! Please check your connection and try again." preferredStyle:UIAlertControllerStyleAlert];
               
               //create a retry action
               UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
                   [self fetchMovies]; //retry getting the movies
               }];
               
               //create a retry button
               [alert addAction:retryAction];
               
               //create a cancel action
               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
                        // doing nothing in these brackets just dismisses the view
               }];
               
               //create a cancel button
               [alert addAction:cancelAction];
               
               //actually show the alert
               [self presentViewController:alert animated:YES completion:^{
                   //putting code in here would be for what happens after controller is done
               }];
           }
           else {
               //Get the array of movies
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                           
               //Store the movies in a property to use elsewhere
               self.movies = dataDictionary[@"results"];
               
               //Reload your table view data
               [self.collectionView reloadData];
               
               //[self.activityIndicator stopAnimating]; //stop loading circle
           }
        //[self.refreshControl endRefreshing]; //stop reloading data into table (without this is will refresh forever)
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //create a movie collection cell
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    //get path to image
    NSString *baseURLString= @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil; //clears out image from previous cell so that when it lags, the previous image doesn't show up
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.movies.count;
}

@end
