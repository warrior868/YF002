//
//  YFDoneVC.m
//  YF002
//
//  Created by Mushroom on 10/5/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFDoneVC.h"
#import "AKPickerView.h"

@interface YFDoneVC () <AKPickerViewDataSource,AKPickerViewDelegate>{
    AKPickerView *pickerDrugView;
    AKPickerView *pickerNumberView;
    NSMutableArray *drugTitles;
    NSMutableArray *numberTitles;
}
@property (weak, nonatomic) IBOutlet UIView *doneStep1;
@property (weak, nonatomic) IBOutlet UIView *doneStep2;
@property (weak, nonatomic) IBOutlet UIButton *doneNextStep;
- (IBAction)nextStep:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *doneStep2Btn;
- (IBAction)doneStep2Btn:(id)sender;

//笑脸按钮
@property (weak, nonatomic) IBOutlet UIButton *before1Btn;
- (IBAction)before2Btn:(id)sender;
- (IBAction)before1Btn:(id)sender;
- (IBAction)before3Btn:(id)sender;
- (IBAction)after1Btn:(id)sender;
- (IBAction)after2Btn:(id)sender;
- (IBAction)after3Btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *beforeArrow;
@property (weak, nonatomic) IBOutlet UIImageView *afterArrow;

@end

@implementation YFDoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _doneNextStep.layer.cornerRadius = 5.0;
    _doneStep2Btn.layer.cornerRadius = 5.0;
    _doneStep1.layer.cornerRadius = 8.0;
    _doneStep2.layer.cornerRadius = 8.0;
    
    _doneStep1.layer.masksToBounds = YES;
    _doneStep2.layer.masksToBounds = YES;
    _doneStep1.hidden = NO;
    _doneStep2.hidden = YES;
   // self.navigationController.navigationBarHidden = YES;
    [self pickerViewInit];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)pickerViewInit{
//1.初始化pickDrugView
    pickerDrugView = [[AKPickerView alloc] initWithFrame:CGRectMake(5, 95, 190, 30)];
    pickerDrugView.delegate = self;
    pickerDrugView.dataSource = self;
    pickerDrugView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_doneStep2 addSubview:pickerDrugView];
    //  self.pickerView.scrollEnabled = NO;
    
    pickerDrugView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    pickerDrugView.textColor = [UIColor grayColor];
    pickerDrugView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:15];
    pickerDrugView.interitemSpacing = 8;
    //	self.pickerView.fisheyeFactor = 0.001;
    pickerDrugView.pickerViewStyle = AKPickerViewStyle3D;
    pickerDrugView.maskDisabled = true;
    
    drugTitles = [NSMutableArray arrayWithObjects:@"扶他林",@"布洛芬",@"无",@"保泰松",@"其他", nil];
    [pickerDrugView reloadData];
    [pickerDrugView selectItem:2 animated:NO];
//2.初始化pickNumberView
    pickerNumberView = [[AKPickerView alloc] initWithFrame:CGRectMake(5, 203, 190, 30)];
    pickerNumberView.delegate = self;
    pickerNumberView.dataSource = self;
    pickerNumberView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_doneStep2 addSubview:pickerNumberView];
    //  self.pickerView.scrollEnabled = NO;
    
    pickerNumberView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    pickerNumberView.textColor = [UIColor grayColor];
    pickerNumberView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:19];
    pickerNumberView.interitemSpacing = 8;
    //	self.pickerView.fisheyeFactor = 0.001;
    //	self.pickerView.pickerViewStyle = AKPickerViewStyle3D;
    pickerNumberView.maskDisabled = true;
    
    numberTitles = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    [pickerNumberView reloadData];
    [pickerNumberView selectItem:0 animated:NO];
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    if ([pickerView isEqual:pickerDrugView]) {
        return [drugTitles count];
    }else{
        return [numberTitles count];
    }
    
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    if ([pickerView isEqual:pickerDrugView]) {
        return drugTitles[item];
    }else{
        return numberTitles[item];
    }
   
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
	return [UIImage imageNamed:self.titles[item]];
 }
 */

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    if ([pickerView isEqual:pickerDrugView]) {
        NSLog(@"%@", drugTitles[item]);
    }else{
        NSLog(@"%@", numberTitles[item]);
    }
   
}


/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */

/*
 - (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
 {
	label.textColor = [UIColor lightGrayColor];
	label.highlightedTextColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titles.count
 saturation:1.0
 brightness:1.0
 alpha:1.0];
 }
 */

/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
 {
	return CGSizeMake(20, 20);
 }
 */

- (IBAction)nextStep:(id)sender {
    _doneStep1.hidden = YES;
    _doneStep2.hidden = NO;
}
- (IBAction)doneStep2Btn:(id)sender {
     [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)before2Btn:(id)sender {
    _beforeArrow.transform = CGAffineTransformMakeTranslation(0, 45);
}

- (IBAction)before1Btn:(id)sender {
     _beforeArrow.transform = CGAffineTransformMakeTranslation(0, 0);
}

- (IBAction)before3Btn:(id)sender {
     _beforeArrow.transform = CGAffineTransformMakeTranslation(0, 90);
}

- (IBAction)after1Btn:(id)sender {
     _afterArrow.transform = CGAffineTransformMakeTranslation(0, 0);
}

- (IBAction)after2Btn:(id)sender {
      _afterArrow.transform = CGAffineTransformMakeTranslation(0, 45);
}

- (IBAction)after3Btn:(id)sender {
      _afterArrow.transform = CGAffineTransformMakeTranslation(0, 90);
}
@end
