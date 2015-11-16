//
//  ViewController.h
//  QRCode
//
//  Created by hanyazhou on 15/5/13.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UILabel *statuesLabel;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIBarButtonItem *starBarButtonItem;
@property (nonatomic, strong) UIImageView *lineImageView;

@end

