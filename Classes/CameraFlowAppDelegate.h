//
//  CameraFlowAppDelegate.h
//  CameraFlow
//

#import <UIKit/UIKit.h>
#import "FlowViewController.h"

@interface CameraFlowAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	id cameraController;
	FlowViewController *flowViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) id cameraController;
@property (nonatomic, retain) FlowViewController *flowViewController;

@end

