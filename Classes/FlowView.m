//
//  FlowViewController.m
//  CameraFlow
//

#import <QuartzCore/QuartzCore.h>
#import "FlowView.h"

@implementation FlowView
@synthesize phimg;
@synthesize cfLayer;


- (void) dealloc {
	[self.phimg release];
	[self.cfLayer release];
	[super dealloc];
}


- (FlowView *) initWithFrame: (CGRect) aRect andCount: (int) count {
	self = [super initWithFrame:aRect];
	self.cfLayer = [[UICoverFlowLayer alloc] initWithFrame:[[UIScreen mainScreen] bounds] numberOfCovers:count numberOfPlaceholders:1];
	[[self layer] addSublayer:(CALayer *)self.cfLayer];

	CGRect phrect = CGRectMake(0.0f, 0.0f, 200.0f, 200.0f);
	self.phimg = [[UIImageView alloc] initWithFrame:phrect];
	[self.cfLayer setPlaceholderImage: [self.phimg layer] atPlaceholderIndex:0];
	
	return self;
}


- (id<CAAction>)actionForLayer:(CALayer *)layer forKey :(NSString *)key {
	NSLog(@"key:%@\nlayer:%@",key,layer);
	if ([key isEqualToString:@"hidden"]) {
		if (layer.hidden) {
			CABasicAnimation *orderInTransformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
			orderInTransformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)];
			orderInTransformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
			orderInTransformAnimation.duration = 0.5;
			
			CABasicAnimation *orderInTransitionAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			orderInTransitionAnimation.fromValue = [NSNumber numberWithFloat:0.0];
			orderInTransitionAnimation.toValue = [NSNumber numberWithFloat:1.0];
			orderInTransitionAnimation.duration = 0.5;
			
			CAAnimationGroup *orderInAnimation = [CAAnimationGroup animation];
			orderInAnimation.duration = 0.5;
			orderInAnimation.animations = [NSArray arrayWithObjects:orderInTransformAnimation, orderInTransitionAnimation, nil];
			
			return orderInAnimation;
		} else {
			// this scope does not work.
			
			CABasicAnimation *orderOutTransformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
			orderOutTransformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
			orderOutTransformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)];
			orderOutTransformAnimation.duration = 0.5;
			
			CABasicAnimation *orderOutTransitionAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			orderOutTransitionAnimation.fromValue = [NSNumber numberWithFloat:1.0];
			orderOutTransitionAnimation.toValue = [NSNumber numberWithFloat:0.0];
			orderOutTransitionAnimation.duration = 0.5;
			
			CAAnimationGroup *orderOutAnimation = [CAAnimationGroup animation];
			orderOutAnimation.duration = 0.5;
			orderOutAnimation.animations = [NSArray arrayWithObjects:orderOutTransformAnimation, orderOutTransitionAnimation, nil];
			
			return orderOutAnimation;
		}
	}
	return nil;
}


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	[self.cfLayer dragFlow:0 atPoint:[[touches anyObject] locationInView:self]];
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	[self.cfLayer dragFlow:1 atPoint:[[touches anyObject] locationInView:self]];
}


- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	[self.cfLayer dragFlow:2 atPoint:[[touches anyObject] locationInView:self]];
}


- (void) flipSelectedCover {
	[self.cfLayer flipSelectedCover];
}


- (void) tick {
	[self.cfLayer displayTick];
}


@end
