//
//  ViewController.m
//  NSURLSessionDemo
//
//  Created by zhengyj on 17/2/23.
//  Copyright © 2017年 zhengyj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDelegate> {
    NSLock *lock;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic,strong) NSMutableArray *datas;


@end

@implementation ViewController

//- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
//    NSLog(@"didBecomeInvalidWithError");
//}
//
///* If implemented, when a connection level authentication challenge
// * has occurred, this delegate will be given the opportunity to
// * provide authentication credentials to the underlying
// * connection. Some types of authentication will apply to more than
// * one request on a given connection to a server (SSL Server Trust
// * challenges).  If this delegate message is not implemented, the
// * behavior will be to use the default handling, which may involve user
// * interaction.
// */
//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
// completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//    NSLog(@"didReceiveChallenge");
//}
//
///* If an application has received an
// * -application:handleEventsForBackgroundURLSession:completionHandler:
// * message, the session delegate will receive this message to indicate
// * that all messages previously enqueued for this session have been
// * delivered.  At this time it is safe to invoke the previously stored
// * completion handler, or to begin any internal updates that will
// * result in invoking the completion handler.
// */
//- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session NS_AVAILABLE_IOS(7_0) {
//    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
//}

#pragma mark - NSURLSessionDownloadDelegate
/**
 *  1.下载完成后被调用的方法（iOS7和iOS8都必须实现）
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成");
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    [self.datas addObject:data];
    dispatch_async(dispatch_get_main_queue(), ^{
    if (self.datas.count == 1) {
        self.imageView1.image = [UIImage imageWithData:[self.datas lastObject]];
    }
    else if ([self.datas count] == 2) {
        self.imageView2.image = [UIImage imageWithData:[self.datas lastObject]];
    }
    else if (self.datas.count == 3) {
        self.imageView3.image = [UIImage imageWithData:[self.datas lastObject]];
    }
    });
//    dispatch_async(dispatch_get_main_queue(), ^{
//    self.imageView1.image = [UIImage imageWithData:data];
//        self.imageView2.image = [UIImage imageWithData:data];
//        
//    
    
}

/**
 *  2.下载进度变化的时候被调用。多次调用。（iOS8可以不实现）
 *
 *  @param bytesWritten              本次写入的字节数
 *  @param totalBytesWritten         已经写入的字节数
 *  @param totalBytesExpectedToWrite 总的下载字节数
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [lock lock];
    
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"downloadTask:%@ %f",downloadTask, progress);
    
    [lock unlock];
//    self.progressView.progress = progress;
}

/**
 *  3.断点续传的时候被调用的方法。(一般上面都不用写，iOS8可以不实现)
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (IBAction)buttonAction:(id)sender {
    [self.datas removeAllObjects];
    [self downloadImage:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487858315438&di=c840d3b51186dc984ff0166d40dbf66a&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2F9902a50f4bfbfbed5fb93ff378f0f736adc31f83.jpg"];
    [self downloadImage:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487860514291&di=6970171cff939bf00f61aeabdcc1acbb&imgtype=0&src=http%3A%2F%2Fimgstore.cdn.sogou.com%2Fapp%2Fa%2F100540002%2F435825.jpg"];
    
}

- (IBAction)cleanButtonAction:(id)sender {
    
    self.imageView1.image = nil;
    self.imageView2.image = nil;
    self.imageView3.image = nil;
    
}

- (void)downloadImage:(NSString *)str {
//    NSString *str = url;
    
    
    
    NSURL *url = [NSURL URLWithString:str];
    
    //2.实例化一个session对象
    //NSURLSessionConfiguration可以配置全局访问的参数
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //3.指定回调方法工作的线程
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    //4.发起并且继续任务
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url];
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.datas = [NSMutableArray arrayWithCapacity:3];
    lock = [[NSLock alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
