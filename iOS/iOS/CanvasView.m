//
//  CanvasView.m
//  iOS
//
//  Created by keith on 2022/1/29.
//

#import "CanvasView.h"

@interface CanvasView ()

@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) NSMutableArray *pathArray;
@property (nonatomic) CGPoint previousPoint;

@end

@implementation CanvasView


- (instancetype)init {
    self = [super init];
    if(self) {
        [self initCanvas];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initCanvas];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initCanvas];
}

- (void)initCanvas {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    // 初始化画笔
    self.path = [UIBezierPath bezierPath];
    self.lineWidth = 20.0;
    self.pathColor = [UIColor blackColor];
    self.path.lineJoinStyle = kCGLineJoinRound;
}

- (NSMutableArray *)pathArray {
    if(!_pathArray) {
        _pathArray = [NSMutableArray array];
    }
    return  _pathArray;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
}

- (void)setPathColor:(UIColor *)pathColor {
    _pathColor = pathColor;
}

#pragma mark - methods

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint currentPoint = [pan locationInView:self];
    CGPoint midPoint = [self getMidPoint:self.previousPoint withP2:currentPoint];
    if(pan.state == UIGestureRecognizerStateBegan) {
        self.path = [UIBezierPath bezierPath];
        self.path.lineWidth = self.lineWidth;
        [self.path moveToPoint:currentPoint];
        [self.pathArray addObject:self.path];
    }
    if(pan.state == UIGestureRecognizerStateChanged) {
        [self.path addQuadCurveToPoint:midPoint controlPoint:self.previousPoint];
    }
    self.previousPoint = currentPoint;
    [self setNeedsDisplay];
}

- (CGPoint)getMidPoint:(CGPoint)p1 withP2:(CGPoint)p2{
    return CGPointMake((p1.x + p2.x)/2, (p1.y + p2.y)/2);
}

- (void)clearCanvas {
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)revoke {
    [self.pathArray removeLastObject];
    [self setNeedsDisplay];
}


- (UIImage *)saveCanvas {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  [[UIImage alloc] initWithData: UIImageJPEGRepresentation(image, 0.8)];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    for (UIBezierPath *path in self.pathArray) {
        [self.pathColor set];
        [path stroke];
    }
}



@end
