//
//  ProcessorViewController.m
//  BlurProcessorExample
//
//  Created by Yu Sugawara on 8/12/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "ProcessorViewController.h"
#import "UIImageView+YSBlurProcessor.h"

@interface ProcessorViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UISlider *blurRadiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *blurRadiusLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *tintColorControl;
@property (nonatomic) UIColor *tintColor;

@property (weak, nonatomic) IBOutlet UISlider *saturationDeltaFactorSlider;
@property (weak, nonatomic) IBOutlet UILabel *saturationDeltaFactorLabel;

@property (weak, nonatomic) IBOutlet UISwitch *maskImageSwitch;
@property (nonatomic) UIImage *maskImage;

@end

@implementation ProcessorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.image = self.imageView.image;
    self.maskImage = [UIImage imageNamed:@"mask"];
    
    [self updateBlurRadiusLabel];
    [self updateSaturationDeltaFactorLabel];
    [self updateBluredImage];
}

- (void)updateBluredImage
{
    [self.imageView ys_setImage:self.image
                   withBlurInfo:[[YSBlurInfo alloc] initWithBlurRadius:self.blurRadiusSlider.value
                                                             tintColor:self.tintColor
                                                 saturationDeltaFactor:self.saturationDeltaFactorSlider.value
                                                             maskImage:self.maskImageSwitch.on ? self.maskImage : nil]
                     completion:^(BOOL nextBlurProcessing)
     {
         NSLog(@"Completion, nextBlurProcessing(%@)", nextBlurProcessing ? @"YES" : @"NO");
     }];
}

- (void)updateBlurRadiusLabel
{
    self.blurRadiusLabel.text = [NSString stringWithFormat:@"%.f", self.blurRadiusSlider.value];
}

- (void)updateSaturationDeltaFactorLabel
{
    self.saturationDeltaFactorLabel.text = [NSString stringWithFormat:@"%.1f", self.saturationDeltaFactorSlider.value];
}

- (IBAction)blurRadiusSliderChanged:(UISlider *)sender
{
    [self updateBlurRadiusLabel];
    [self updateBluredImage];
}

- (IBAction)tintColorControlChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.tintColor = nil;
            break;
        case 1:
            self.tintColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
            break;
        case 2:
            self.tintColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
            break;
        case 3:
            self.tintColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
            break;
        default:
            abort();
            break;
    }
    [self updateBluredImage];
}

- (IBAction)saturationDeltaFactorSliderChanged:(UISlider *)sender
{
    [self updateSaturationDeltaFactorLabel];
    [self updateBluredImage];
}

- (IBAction)maskImageSwitchChanged:(UISwitch *)sender
{
    [self updateBluredImage];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 240.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

@end
