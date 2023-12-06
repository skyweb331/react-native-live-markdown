#import <react-native-markdown-text-input/RCTBaseTextInputView+Markdown.h>
#import <react-native-markdown-text-input/RCTMarkdownUtils.h>
#import <objc/message.h>

@implementation RCTBaseTextInputView (Markdown)

- (void)setMarkdownEnabled:(BOOL)markdownEnabled {
  NSNumber *markdownEnabledNumber = [NSNumber numberWithBool:markdownEnabled];
  objc_setAssociatedObject(self, @selector(isMarkdownEnabled), markdownEnabledNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isMarkdownEnabled {
  NSNumber *markdownEnabledNumber = objc_getAssociatedObject(self, @selector(isMarkdownEnabled));
  return [markdownEnabledNumber boolValue];
}

- (void)markdown_setAttributedText:(NSAttributedString *)attributedText
{
  if ([self isMarkdownEnabled] && attributedText != nil) {
    attributedText = [RCTMarkdownUtils parseMarkdown:attributedText.string];
  }

  // Call the original method
  [self markdown_setAttributedText:attributedText];
}

+ (void)load
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class cls = [self class];
    SEL originalSelector = @selector(setAttributedText:);
    SEL swizzledSelector = @selector(markdown_setAttributedText:);
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
  });
}

@end