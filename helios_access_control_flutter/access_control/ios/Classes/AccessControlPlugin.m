#import "AccessControlPlugin.h"
#if __has_include(<access_control/access_control-Swift.h>)
#import <access_control/access_control-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "access_control-Swift.h"
#endif

@implementation AccessControlPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAccessControlPlugin registerWithRegistrar:registrar];
}
@end
