//
//  MoviesViewController.h
//  Flix
//
//  Created by Sanjana Meduri on 6/23/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoviesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *synoposisLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
