#import "Log.h"
#import "IRNewSignalScene1ViewController.h"
#import "IRSignal.h"
#import "IRConst.h"
#import "IRViewCustomizer.h"
#import "IRSignalNameEditViewController.h"
#import "IRHTTPClient.h"
#import "IRKit.h"

@interface IRNewSignalScene1ViewController ()

@end

@implementation IRNewSignalScene1ViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    LOG_CURRENT_METHOD;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    LOG_CURRENT_METHOD;
}

- (void)viewDidLoad {
    LOG_CURRENT_METHOD;
    [super viewDidLoad];

    self.title = @"Waiting for Signal ...";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(cancelButtonPressed:)];

    [IRViewCustomizer sharedInstance].viewDidLoad(self);
}

- (void) viewWillAppear:(BOOL)animated {
    LOG_CURRENT_METHOD;
    [super viewWillAppear:animated];

    [[IRKit sharedInstance].peripherals waitForSignalWithCompletion:^(IRSignal *signal, NSError *error) {
        if (signal) {
            [self didReceiveSignal:signal];
        }
        else {
            // TODO alert error
            [self cancelButtonPressed:nil];
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    LOG_CURRENT_METHOD;
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    LOG_CURRENT_METHOD;
    [super viewWillDisappear:animated];

    [[IRKit sharedInstance].peripherals stopWaitingForSignal];
}

- (void) didReceiveSignal: (IRSignal*)signal {
    LOG_CURRENT_METHOD;

    IRSignalNameEditViewController *c = [[IRSignalNameEditViewController alloc] initWithNibName:@"IRSignalNameEditViewController"
                                                                                         bundle:[IRHelper resources]];
    c.delegate = (id<IRSignalNameEditViewControllerDelegate>)self.delegate;
    c.signal   = signal;
    [self.navigationController pushViewController:c
                                         animated:YES];

}

#pragma mark - UI events

- (void)didReceiveMemoryWarning
{
    LOG_CURRENT_METHOD;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonPressed:(id)sender {
    LOG_CURRENT_METHOD;

    [self.delegate scene1ViewController:self
                      didFinishWithInfo:@{
           IRViewControllerResultType: IRViewControllerResultTypeCancelled
     }];
}

@end
