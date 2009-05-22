//
//  FlowViewController.m
//  CameraFlow
//

#import "FlowViewController.h"
#import "CameraFlowAppDelegate.h"


@interface UIView (extended)
- (void) startHeartbeat: (SEL) aSelector inRunLoopMode: (id) mode;
- (void) stopHeartbeat: (SEL) aSelector;
@end


@implementation FlowViewController
@synthesize cfView;


- (void) dealloc {
	[self.cfView  release];
	[super dealloc];
}


- (FlowViewController *) init {
	if (self = [super init]) {
		self.cfView = [[FlowView alloc] initWithFrame:[[UIScreen mainScreen] bounds] andCount:10];
		[self.cfView setUserInteractionEnabled:YES];
		[self.cfView.cfLayer selectCoverAtIndex:0];
		[self.cfView.cfLayer setDelegate:self];
	}
	return self;
}	


#pragma mark Coverflow delegate methods


- (void) coverFlow:(UICoverFlowLayer *)coverFlow selectionDidChange: (int) index {
}

- (void) coverFlow:(UICoverFlowLayer *)coverFlow transitionDidEnd: (unsigned int)fp12 {
}

- (void) coverFlowFlipDidEnd:(UICoverFlowLayer *)coverFlow {
}


#pragma mark Coverflow datasource methods


- (void) coverFlow:(UICoverFlowLayer *)coverFlow requestImageAtIndex:(int)index quality: (int)quality {
	CameraFlowAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[coverFlow setImage:[[[appDelegate.cameraController previewView] layer] contents] atIndex:index type:quality];
}


- (id) coverFlow:(UICoverFlowLayer *)coverFlow requestFlipLayerAtIndex:(int) index {
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 140.0f)] autorelease];
	[view setBackgroundColor:[UIColor clearColor]];
	
	return [view layer];
}


#pragma mark Utility methods


- (void) start {
	[self.cfView startHeartbeat: @selector(tick) inRunLoopMode: (id)kCFRunLoopDefaultMode];
	[self.cfView.cfLayer transitionIn:0];
}


- (void) stop {
	[self.cfView stopHeartbeat: @selector(tick)];
}


- (void) loadView {
	[super loadView];
	self.view = self.cfView;
	[self start];
}


@end
