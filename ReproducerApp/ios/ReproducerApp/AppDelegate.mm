#import "AppDelegate.h"
#import "ReproducerApp-Swift.h"

#import <React/RCTBundleURLProvider.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  ViewController *viewController = [[ViewController alloc] init];
  
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
  
  self.window.rootViewController = navController;
  
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
