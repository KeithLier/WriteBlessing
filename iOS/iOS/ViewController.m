//
//  ViewController.m
//  iOS
//
//  Created by keith on 2022/1/28.
//

#import "ViewController.h"
#import "CanvasView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *colorSwitch;
@property (weak, nonatomic) IBOutlet CanvasView *canvasView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
}

// 撤销
- (IBAction)back:(id)sender {
    [self.canvasView revoke];
}

// 重写
- (IBAction)rewrite:(id)sender {
    [self.canvasView clearCanvas];
}

// 保存
- (IBAction)save:(id)sender {
    UIImage *image = [self.canvasView saveCanvas];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

// 切换颜色
- (IBAction)colorSelect:(UISwitch *)sender {
    if (sender.on) {
        self.canvasView.pathColor = [UIColor orangeColor];
    } else {
        self.canvasView.pathColor = [UIColor blackColor];
    }
    
}

@end
