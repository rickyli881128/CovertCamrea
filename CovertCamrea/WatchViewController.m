//
//  WatchViewController.m
//  CovertCamrea
//
//  Created by LiChao Jun on 15/8/28.
//  Copyright (c) 2015年 LiChao Jun. All rights reserved.
//

#import "WatchViewController.h"
#import "VideoManager.h"
#import <MediaPlayer/MediaPlayer.h>

static NSString *kCellID = @"kCellID";

@interface WatchViewController () <UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation WatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView reloadData];
    
    if ([VideoManager sharedVideoManager].recordVideos.count == 0) {
        self.deleteAllButton.enabled = NO;
    }
}

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteAllAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"WARNING"
                                message:@"Do you really want to delete all?"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"OK", nil] show];
}

- (void)sendAction:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell*)sender.view];
        NSString *filePath = FILEPATH([VideoManager sharedVideoManager].recordVideos[indexPath.row]);
        [self openFileWithOtherApp:filePath];
    }
}

- (void)openFileWithOtherApp:(NSString*)filePath
{
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    self.documentController.delegate = self;
    self.documentController.UTI = @"public.movie";
    [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

#pragma mark - *UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [VideoManager sharedVideoManager].recordVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
        UILongPressGestureRecognizer *longGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sendAction:)];
        [cell addGestureRecognizer:longGr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [[VideoManager sharedVideoManager].recordVideos[indexPath.row] lastPathComponent];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *filePath = FILEPATH([VideoManager sharedVideoManager].recordVideos[indexPath.row]);
        [[VideoManager sharedVideoManager] deleteVideo:filePath];
    }
    [self.tableView reloadData];
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    [self dismissMoviePlayerViewControllerAnimated];
}

#pragma mark - *UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath = FILEPATH([VideoManager sharedVideoManager].recordVideos[indexPath.row]);
    
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:[playerViewController moviePlayer]];
    
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - *UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    self.documentController = nil;
}

#pragma mark - *UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        while ([VideoManager sharedVideoManager].recordVideos.count > 0) {
            NSString *filePath = FILEPATH([VideoManager sharedVideoManager].recordVideos[0]);
            [[VideoManager sharedVideoManager] deleteVideo:filePath];
        }
        [self.tableView reloadData];
    }
}

@end





