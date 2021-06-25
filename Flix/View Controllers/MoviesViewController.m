//
//  MoviesViewController.m
//  Flix
//
//  Created by Sanjana Meduri on 6/23/21.
//

#import "MoviesViewController.h"
#import "MovieCell.h" //in order to use the protype cell outlets
#import "DetailsViewController.h" //needed to link the two view controllers
#import "UIImageView+AFNetworking.h" //to add methods to ImageView

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> //<says this view controller is data source, tells us that this can be delegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//setting up global variables
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies; //for search bar
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating]; //start loading circle
    
    //setting up the Table View
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchBar.delegate = self;
    
    [self fetchMovies]; //network request
        
    self.refreshControl = [[UIRefreshControl alloc] init]; //initializing pull to refresh control
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged]; //call fetchMovies on self when UIControlEventValueChanged
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    // [self.tableView addSubview:self.refreshControl]; //adds refresh control view to the top of the table view
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
            
               NSLog(@"%@", dataDictionary);
               
               //Store the movies in a property to use elsewhere
               self.movies = dataDictionary[@"results"];
               for  (NSDictionary *movie in self.movies){
                   NSLog(@"%@", movie[@"title"]);
               }
               
               self.filteredMovies = self.movies;
               
               //Reload your table view data
               [self.tableView reloadData];
               
               [self.activityIndicator stopAnimating]; //stop loading circle
           }
        [self.refreshControl endRefreshing]; //stop refreshing (without this is will refresh forever)
       }];
    [task resume];
}

//required method for table view -- sets the number of rows in a table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredMovies.count;
}

//required method for table view -- tells the table what to do with each cell (input indexPath has row and section properties)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // UITableViewCell *cell = [[UITableViewCell alloc] init]; //creating a cell
    
    NSLog(@"%@", [NSString stringWithFormat:(@"row: %d, section %d"), indexPath.row, indexPath.section]);
    
    //use prototype cell called "MovieCell"(identifier in the storyboard side panel) --> of type MovieCell, which is a TableViewCell class that we created and in the HEADER of that file, we put the outlets for the elements of the prototype cell
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    //set text of cell
    //cell.textLabel.text = [NSString stringWithFormat:(@"row: %d, section %d"), indexPath.row, indexPath.section];
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    //cell.textLabel.text = movie[@"title"]; //this sets the text of the cell
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    //get path to image
    NSString *baseURLString= @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil; //clears out image from previous cell so that when it lags, the previous image doesn't show up
    [cell.posterView setImageWithURL:posterURL];
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length != 0){
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings){
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
    }
    
    else{
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    
    NSLog(@"Tapping on a movie!");
}


@end
