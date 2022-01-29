//
//  CanvasView.h
//  iOS
//
//  Created by keith on 2022/1/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CanvasView : UIView

@property (strong, nonatomic) UIColor *pathColor;
@property (nonatomic) CGFloat lineWidth;

// 重写
- (void)clearCanvas;

// 获取图片
- (UIImage *)saveCanvas;

// 撤销
- (void)revoke;

@end

NS_ASSUME_NONNULL_END
