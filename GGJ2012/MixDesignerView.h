//
//  MixDesignerView.h
//  GGJ2012
//
//  Created by Jan Ilavsky on 1/28/12.
//  Copyright (c) 2012 Hyperbolic Magnetism. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalPickerView;

@interface MixDesignerView : UIView

@property (nonatomic, strong) IBOutlet HorizontalPickerView *pickerL0;
@property (nonatomic, strong) IBOutlet HorizontalPickerView *pickerL1;
@property (nonatomic, strong) IBOutlet HorizontalPickerView *pickerL2;

@property (nonatomic, strong) IBOutlet HorizontalPickerView *pickerR0;
@property (nonatomic, strong) IBOutlet HorizontalPickerView *pickerR1;
@property (nonatomic, strong) IBOutlet HorizontalPickerView *pickerR2;

@end
