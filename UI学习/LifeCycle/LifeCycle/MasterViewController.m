//
//  MasterViewController.m
//  LifeCycle
//
//  Created by WengHengcong on 3/3/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

#pragma mark - life cycle

- (void)loadView {
    
    [super loadView];
    NSLog(@"MasterVC loadView");
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"MasterVC init");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    NSLog(@"MasterVC viewDidLoad");

}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    NSLog(@"MasterVC viewWillAppear");

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    NSLog(@"MasterVC viewDidAppear");
    
}
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    NSLog(@"MasterVC viewWillLayoutSubviews");
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    NSLog(@"MasterVC viewDidLayoutSubviews");
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    NSLog(@"MasterVC viewWillDisappear");
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    NSLog(@"MasterVC viewDidDisappear");
    
}

- (void)viewWillUnload {
    
    [super viewWillUnload];
    NSLog(@"MasterVC viewWillUnload");
    
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    NSLog(@"MasterVC viewDidUnload");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"MasterVC didReceiveMemoryWarning");

}

#pragma mark - data

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

+ (void)wirteLogWithString:(NSString *)loginput
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"MessageLog.txt"];
    
    if (![fm fileExistsAtPath:fileName]) {
        NSString *str = @"消息中心打点测试\n";
        [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [fileHandle seekToEndOfFile];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    
    NSString *logDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *logLine = [NSString stringWithFormat:@"\n%@-%@",loginput,logDate];
    
    NSData *logData = [logLine dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:logData];
}

@end
