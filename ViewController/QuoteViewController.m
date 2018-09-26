//
//  QuoteViewController.m
//  miniTest
//
//  Created by Kristian on 19/09/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import "QuoteViewController.h"
#import "QuoteModel.h"
//#import "AFHTTPSessionManager.h"
@interface QuoteViewController ()
@property (strong, nonatomic) IBOutlet UILabel *quoteLabel;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIImageView *quoteImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageToMove;
@property (strong, nonatomic) NSMutableArray *quoteArray;
@end

@implementation QuoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [NSURL URLWithString:@"https://quotes.rest/qod"];
    [self spinWithOptions:UIViewAnimationOptionRepeat];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data ,NSURLResponse * _Nullable response,NSError * _Nullable error){
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

        NSArray *quoteModelArray = [dict valueForKeyPath:@"contents.quotes"];
       
        NSMutableArray *quoteModelResultArray = [NSMutableArray array];
        
        for(NSDictionary *quoteModelDictionary in quoteModelArray) {
            QuoteModel *quoteModel = [QuoteModel new];
            quoteModel.imageString = [quoteModelDictionary objectForKey:@"background"];
            quoteModel.quoteString = [quoteModelDictionary objectForKey:@"quote"];
            [quoteModelResultArray addObject:quoteModel];
        }
        self.quoteArray = quoteModelResultArray;
        QuoteModel *quoteModel = [QuoteModel new];
        quoteModel = [self.quoteArray objectAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageToMove.alpha = 0.0f;
            self.quoteLabel.text =quoteModel.quoteString;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:quoteModel.imageString]]];
            self.quoteImage.image = image;
        });

    
    }]
     resume
     
    ];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeLeft) forKey:@"orientation"];
    
}
- (void)spinWithOptions:(UIViewAnimationOptions)options {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:options
                     animations:^{
                         self.imageToMove.transform = CGAffineTransformRotate(self.imageToMove.transform, M_PI);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonDidTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    
}
@end
