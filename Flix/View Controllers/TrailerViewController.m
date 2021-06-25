//
//  TrailerViewController.m
//  Flix
//
//  Created by Sanjana Meduri on 6/25/21.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchVideo];
}

- (void)fetchVideo {
    //setting up network request
    NSString *base = @"https://api.themoviedb.org/3/movie/";
    NSString *base2 = @"/videos?api_key=a4d0f7643a9c6c54d0877de6065537ec&language=en-US";
    NSString *idpath = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
    NSLog([NSString stringWithFormat:@"%@", self.movie[@"id"]]);
    
    NSString *urlString1 = [base stringByAppendingString:idpath];
    NSString *urlString = [urlString1 stringByAppendingString:base2];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               //create an alert if there is no network connection
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Connection Failed" message:@"It looks like you are not connected to the Internet! Please check your connection and try again." preferredStyle:UIAlertControllerStyleAlert];
               
               //create a retry action
               UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
                   [self fetchVideo]; //retry getting the movies
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
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSString *keyString = (dataDictionary[@"results"])[0][@"key"];

               NSString *baseURLString = @"https://www.youtube.com/watch?v=";
               NSString *videoUrl = [baseURLString stringByAppendingString:keyString];
               
               NSLog(videoUrl);
               
               NSURL *url = [NSURL URLWithString:videoUrl];
               NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
               [self.webView loadRequest:request];

           }
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

@end
