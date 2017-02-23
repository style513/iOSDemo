//
//  YJHttpGetViewController.m
//  NSURLSessionDemo
//
//  Created by zhengyj on 17/2/23.
//  Copyright © 2017年 zhengyj. All rights reserved.
//

#import "YJHttpGetViewController.h"

@interface YJHttpGetViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation YJHttpGetViewController

- (IBAction)buttonAction:(id)sender {
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://httpbin.org/get?name=zhengyj"]];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *task = [urlSession dataTaskWithRequest:urlRequest];
    
//    NSURLSessionTask *task = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSString *string  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.textView.text = string;
//        });
//        
//    }];
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
