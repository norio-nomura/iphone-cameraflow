//
//  FlowView.h
//  CameraFlow
//

#import <UIKit/UIKit.h>
#import "UICoverFlowLayer.h"


@interface FlowView : UIView {
	UICoverFlowLayer	*cfLayer;
	UIImageView			*phimg;
}
- (FlowView *) initWithFrame: (CGRect) aFrame andCount: (int) aCount;
- (void) tick;
- (void) flipSelectedCover;

@property (nonatomic, retain)		UIImageView *phimg;
@property (nonatomic, retain)		UICoverFlowLayer *cfLayer;


@end

