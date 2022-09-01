
#import <objc/message.h>
#import <ZFPlayer/ZFPlayerController.h>

BOOL zf_isFullscreenOfFixSafeArea = NO;
API_AVAILABLE(ios(13.0)) @protocol _UIViewControllerPrivateMethodsProtocol <NSObject>
- (void)_setContentOverlayInsets:(UIEdgeInsets)insets andLeftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin;
@end

@implementation UIViewController (ZFPlayerFixSafeArea)
- (void)zf_setContentOverlayInsets:(UIEdgeInsets)insets andLeftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin {
    if (zf_isFullscreenOfFixSafeArea == NO) {
        [self zf_setContentOverlayInsets:insets andLeftMargin:leftMargin rightMargin:rightMargin];
    }
}
@end

API_AVAILABLE(ios(13.0)) @implementation ZFOrientationObserver (ZFPlayerFixSafeArea)
+ (void)initialize {
    if ( @available(iOS 13.0, *) ) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class cls = UIViewController.class;
            SEL originalSelector = @selector(_setContentOverlayInsets:andLeftMargin:rightMargin:);
            SEL swizzledSelector = @selector(zf_setContentOverlayInsets:andLeftMargin:rightMargin:);
            
            Method originalMethod = class_getInstanceMethod(cls, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
            
            Class pc_class = ZFPlayerController.class;
            SEL pc_originalSelector = @selector(enterFullScreen:animated:completion:);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            SEL pc_swizzledSelector = @selector(zf_enterFullScreen:animated:completion:);
#pragma clang diagnostic pop
            Method pc_originalMethod = class_getInstanceMethod(pc_class, pc_originalSelector);
            Method pc_swizzledMethod = class_getInstanceMethod(pc_class, pc_swizzledSelector);
            method_exchangeImplementations(pc_originalMethod, pc_swizzledMethod);
        });
    }
}
@end

API_AVAILABLE(ios(13.0)) @implementation ZFPlayerController (ZFPlayerFixSafeArea)
- (void)zf_enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion {
    zf_isFullscreenOfFixSafeArea = fullScreen;
    [self zf_enterFullScreen:fullScreen animated:animated completion:completion];
}
@end


