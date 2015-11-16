//
//  ViewController.m
//  QRCode
//
//  Created by hanyazhou on 15/5/13.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) BOOL   isReading;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) int  a;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isReading = NO;
    _a = 74;

    self.view.backgroundColor = [UIColor blackColor];
    
    _backView = [[UIView alloc] init];
    _backView.frame = CGRectMake(20, 74, 280, 350);
    _backView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5.5, -7, 291, 364)];
    imageView.image = [UIImage imageNamed:@"qrBg.png"];
    [_backView addSubview:imageView];
    
    
    _lineImageView = [[UIImageView alloc] init];
    _lineImageView.bounds = CGRectMake(0, 0, 280, 10);
    _lineImageView.center = CGPointMake(160, 74);
    _lineImageView.image = [UIImage imageNamed:@"qrLine.png"];
    _lineImageView.hidden = YES;
    [self.view addSubview:_lineImageView];
    
    
    UILabel *alertLable = [[UILabel alloc] initWithFrame:CGRectMake(17, 164, 247, 21)];
    alertLable.textColor = [UIColor whiteColor];
    alertLable.text = @"To on Start ! to read a QR Code";
    [_backView addSubview:alertLable];
    
    
    _statuesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 448, 280, 21)];
    _statuesLabel.backgroundColor = [UIColor blackColor];
    _statuesLabel.textColor = [UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0/255.0 alpha:1.0];
    _statuesLabel.text = @"To on Start ! to read a QR Code";
    [self.view addSubview:_statuesLabel];
    
    
    _starBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(start:)];
    UIBarButtonItem *flexbleButtonItemLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *flexbleButtonItemRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    
    UIToolbar *myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 524, 320, 44)];
    myToolBar.items = @[flexbleButtonItemLeft,_starBarButtonItem,flexbleButtonItemRight];
    [self.view addSubview:myToolBar];
    
}

- (void)animation:(NSTimer *)timer {
    _a = _a + 5;
    if (_a >= 74+350) {
        _a = 74;
    }
    _lineImageView.center = CGPointMake(160, _a);
}

- (void)start:(UIBarButtonItem *)sender {
    if (!_isReading) {
        [self startReading];
        _timer = [NSTimer scheduledTimerWithTimeInterval: 0.02 target: self selector: @selector(animation:) userInfo: nil repeats: YES];
        _lineImageView.hidden = NO;
        [_starBarButtonItem setTitle:@"Stop"];
    }else {
        [self stopReading];
        [_starBarButtonItem setTitle:@"Start"];
        [_timer invalidate];
        _lineImageView.hidden = YES;
        _a = 74;
        _timer = nil;
    }
    _isReading = !_isReading;
}

- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@",[error localizedDescription]);
        return NO;
    }else {
        
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession addInput:input];
        
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_captureSession addOutput:captureMetadataOutput];
        
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("myQueue", NULL);
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:_backView.layer.bounds];
        [_backView.layer addSublayer:_videoPreviewLayer];
        
        [_captureSession startRunning];
        
        return YES;
    }
}


-(void)stopReading{
    _lineImageView.hidden = YES;
    [_timer invalidate];
    _a = 74;
    _timer = nil;
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_statuesLabel performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_starBarButtonItem performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            _isReading = NO;
        }
    }
}

- (void)setTitle:(NSString *)title {
    [_starBarButtonItem setTitle:title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
