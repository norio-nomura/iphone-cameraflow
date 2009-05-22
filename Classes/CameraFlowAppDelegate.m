//
//  CameraFlowAppDelegate.m
//  CameraFlow
//

#import "CameraFlowAppDelegate.h"
#import "FlowViewController.h"

@implementation CameraFlowAppDelegate

@synthesize window;
@synthesize cameraController;
@synthesize flowViewController;


- (void)dealloc {
    [window release];
	[cameraController release];
	[flowViewController release];
    [super dealloc];
}


#pragma mark UIApplicationDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	application.statusBarHidden = YES;
	self.cameraController = [(id)objc_getClass("PLCameraController") performSelector:@selector(sharedInstance)];
	[cameraController setDelegate:self];
	UIView *previewView = [cameraController performSelector:@selector(previewView)];
	[cameraController performSelector:@selector(startPreview)];
	[window addSubview:previewView];
	
	self.flowViewController = [[FlowViewController alloc] init];
	self.flowViewController.view.hidden = YES;
	[window addSubview:self.flowViewController.view];
	
    [window makeKeyAndVisible];
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


#pragma mark FlowCoverView


- (void)orientationChanged:(NSNotification *)note {
	UIApplication *application = [UIApplication sharedApplication];
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	if (UIDeviceOrientationIsLandscape(deviceOrientation) && application.statusBarOrientation != deviceOrientation) {
		//		[application setStatusBarHidden:YES];
		
		FlowView *cfView = self.flowViewController.cfView;
		if (cfView.hidden) {
			cfView.hidden = NO;
		} else {
			[cfView.cfLayer setDisplayedOrientation:deviceOrientation animate:YES];
		}
		[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
		[application setStatusBarOrientation:deviceOrientation];
		
	} else if (UIDeviceOrientationPortrait == deviceOrientation && application.statusBarOrientation != deviceOrientation) {
		//		[application setStatusBarHidden:YES];
		
		FlowView *cfView = self.flowViewController.cfView;
		cfView.hidden = YES;
		
		[application setStatusBarStyle:UIStatusBarStyleDefault];
		[application setStatusBarOrientation:UIDeviceOrientationPortrait];
	}
}


#pragma mark PLCameraControllerDelegate


-(void)cameraController:(id)sender tookPicture:(UIImage*)picture withPreview:(UIImage*)preview jpegData:(NSData*)jpeg imageProperties:(NSDictionary *)exif {
	NSLog(@"you can get UIImage here. rotate is needed.");
	NSLog(@"picture.size:%f,%f",picture.size.width,picture.size.height);
	NSLog(@"preview.size:%f,%f",preview.size.width,preview.size.height);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathToDefault = [documentsDirectory stringByAppendingPathComponent:@"Default.png"];
	
	NSData *data = UIImagePNGRepresentation(preview);
	[data writeToFile:pathToDefault atomically:NO];
}


- (void)cameraControllerReadyStateChanged:(id)fp8{
}


@end
