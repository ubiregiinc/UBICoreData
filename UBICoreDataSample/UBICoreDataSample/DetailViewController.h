//
//  DetailViewController.h
//  UBICoreDataSample
//
//  Created by Yuki Yasoshima on 2015/11/30.
//  Copyright © 2015年 Yuki Yasoshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

