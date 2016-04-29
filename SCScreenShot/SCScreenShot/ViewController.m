//
//  ViewController.m
//  SCScreenShot
//
//  Created by ZhangSC on 16/4/29.
//  Copyright © 2016年 ZSC. All rights reserved.
//

#import "ViewController.h"
#import "SCScreenShotView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *iv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)tap:(UIButton *)sender {
    
    SCScreenShotView *shotView = [[SCScreenShotView alloc] init];
    [shotView screenShotWithImage:^(UIImage *image) {
        self.iv.image = image;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
