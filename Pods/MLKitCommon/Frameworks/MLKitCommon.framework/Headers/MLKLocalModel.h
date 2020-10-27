#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** A model stored locally on the device. */
NS_SWIFT_NAME(LocalModel)
@interface MLKLocalModel : NSObject

/** An absolute path to a model file stored locally on the device. */
@property(nonatomic, copy, readonly) NSString *path;

/**
 * Creates a new instance with the given model file path.
 *
 * @param path Absolute path to a model file stored locally on the device.
 * @return A new `LocalModel` instance.
 */
- (instancetype)initWithPath:(NSString *)path;

/** Unavailable. */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
