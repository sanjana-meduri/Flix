//
//  MoviesViewController.m
//  Flix
//
//  Created by Sanjana Meduri on 6/23/21.
//

#import "MoviesViewController.h"
#import "MovieCell.h" //in order to use the protype cell outlets

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate> //<says this view controller is data source, tells us that this can be delegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *movies;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting up the Table View
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //setting up network request
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
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
               
               //Reload your table view data
               [self.tableView reloadData];
           }
       }];
    [task resume];
}

//required method for table view -- sets the number of rows in a table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

//required method for table view -- tells the table what to do with each cell (input indexPath has row and section properties)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // UITableViewCell *cell = [[UITableViewCell alloc] init]; //creating a cell
    
    NSLog(@"%@", [NSString stringWithFormat:(@"row: %d, section %d"), indexPath.row, indexPath.section]);
    
    //use prototype cell called "MovieCell"(identifier in the storyboard side panel) --> of type MovieCell, which is a TableViewCell class that we created and in the HEADER of that file, we put the outlets for the elements of the prototype cell
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    //set text of cell
    //cell.textLabel.text = [NSString stringWithFormat:(@"row: %d, section %d"), indexPath.row, indexPath.section];
    
    NSDictionary *movie = self.movies[indexPath.row];
    //cell.textLabel.text = movie[@"title"]; //this sets the text of the cell
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
