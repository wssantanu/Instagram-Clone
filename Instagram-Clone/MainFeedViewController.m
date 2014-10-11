//
//  MainFeedViewController.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 4/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "MainFeedViewController.h"
#import "InstaClient.h"
#import "InstaMedia.h"
#import "CustomHeaderViewCell.h"
#import "CustomFooterViewCell.h"

@interface MainFeedViewController ()
{
    NSArray *feedArray;
    InstaClient *client;
    InstaMedia  *media;
    InstaMedia *mediaHeader;
    InstaMedia *mediaFooter;
    
  
    IBOutlet UILabel *likesLabel;
}
@end

@implementation MainFeedViewController

- (void)viewDidLoad
{
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(downloadFinished)
                                              name:@"downloadFinished" object:nil];
    
    [super viewDidLoad];
    client = [InstaClient sharedClient];
    [client startConnection];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"headerCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"footerCell" bundle:nil] forCellReuseIdentifier:@"footerCell"];
   // [client startPersonalFeed];
  //  [client addObserver:self forKeyPath:@"personalImagesArray" options:0 context:NULL];
   
    
    
    dispatch_queue_t backGroundQue = dispatch_queue_create("instaqueue", NULL);
    
    dispatch_sync(backGroundQue, ^{
        
        [client startPersonalFeed];

        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)downloadFinished
{
    feedArray = client.personalImagesArray;
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    //KVO checken per property & juiste actie nemen
    if ([keyPath isEqual:@"personalImagesArray"])
    {
        NSLog(@"Keypath is: %@", keyPath);
        NSLog(@"[VKViewController]personalImagesArray called");
     //   feedArray = [[NSMutableArray alloc]init];
        feedArray = client.personalImagesArray;
        NSLog(@"FeedArray: %@", feedArray);
        [self.tableView reloadData];
    }
   
}
*/


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (feedArray)
    {
        return [feedArray count];
    }
    else
    {
        return 10;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
 
        return 1 ;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    mediaFooter = [feedArray objectAtIndex:section];
    
    
    CustomFooterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"footerCell"];
    if (cell==nil) {
        cell = [[CustomFooterViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footerCell"];
    //    NSLog(@"Footercell is nil");
    }
  //  NSLog(@"We zijn er mee bezig! -- FooterCell");

    return cell;
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    mediaHeader = [feedArray objectAtIndex:section];
    
    CustomHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    if (cell==nil) {
        cell = [[CustomHeaderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        //NSLog(@"Cell is nil");
    }
  //  NSLog(@"We zijn er mee bezig!");
    cell.username.text = mediaHeader.username;//@"user_name";
    cell.profileImage.image = mediaHeader.profileImage;
//
   
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH"];
   cell.time.text = [df stringFromDate:mediaHeader.created_time];
    NSLog(@"Date: %@", mediaHeader.created_time);
    
    cell.profileImage.clipsToBounds = YES;
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2;
    cell.profileImage.layer.borderWidth = 2.0f;
    cell.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    return cell;
 
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell" forIndexPath:indexPath];
    
    UIImageView *cellImageView = (UIImageView *) [cell viewWithTag:200];
    if (feedArray)
    {
        NSLog(@"[[MFViewC]IndexPath-mainCells: %ld", (long)indexPath.section );
        media = [feedArray objectAtIndex:indexPath.section];
        NSLog(@"[MFViewController]media.InstaIMageUrl: %@", media.images);
        NSDictionary *tiet = [media.images objectForKey:@"standard_resolution"];
        NSLog(@"FDSLKFJD : %@", tiet);
        
         NSURL *url = [NSURL URLWithString:[tiet objectForKey:@"url"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        NSLog(@"[MFVC]media.images: %@", media.images);
        
        cellImageView.image = image;
        //  NSData *imageData = [NSData dataWithContentsOfURL:[imagesArray objectAtIndex:indexPath.row]];
       /* if (media.instaImage)
        {
            cellImageView.image = media.instaImage; //[UIImage imageWithData:imageData];
            likesLabel.text = [NSString stringWithFormat:@"%ld",(long)media.likes];
            
            // NSLog(@"[VKViewController]met url");
        }
        else
        {
            cellImageView.image = [UIImage imageNamed:@"buf.png"];
            // NSLog(@"[VKViewController]Buf geladen!");
        }
*/
        
    }
    
    
       return cell;
}






/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
