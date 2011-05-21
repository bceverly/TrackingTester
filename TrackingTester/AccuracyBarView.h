//
//  AccuracyBarView.h
//  iOSGPSTester
//
//  Created by Bryan Everly on 5/16/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccuracyBarView : UIView {
    NSNumber *_currentAccuracy;
    NSNumber *_bestAccuracy;
}

@property (nonatomic, retain) NSNumber *currentAccuracy;
@property (nonatomic, retain) NSNumber *bestAccuracy;

@end
