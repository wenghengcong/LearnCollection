//
//  ViewController.m
//  VoiceMessage
//
//  Created by WengHengcong on 16/2/15.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "DOUAudioStreamer.h"
#import "Track.h"
#import "Track+Provider.h"

#define kAudioFilePath @"test.m4a"

@interface ViewController ()
{
    DOUAudioStreamer *_streamer;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //
    // Setup the AVAudioSession. EZMicrophone will not work properly on iOS
    // if you don't do this!
    //
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }

    
    
    // Create an instance of the microphone and tell it to use this view controller instance as the delegate
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    self.player = [EZAudioPlayer audioPlayerWithDelegate:self];
    
    //
    // Override the output to the speaker. Do this after creating the EZAudioPlayer
    // to make sure the EZAudioDevice does not reset this.
    //
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if (error)
    {
        NSLog(@"Error overriding output to the speaker: %@", error.localizedDescription);
    }
    
    //
    // Setup notifications
    //
    [self setupNotifications];
    
    //
    // Log out where the file is being written to within the app's documents directory
    //
    NSLog(@"File written to application sandbox's documents directory: %@",[self filePathURL]);
    
    //
    // Start the microphone
    //
    [self.microphone startFetchingAudio];
    
    
    self.tracks  = [Track remoteTracks];
    Track *track = [self.tracks objectAtIndex:0];
    
    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEndOfFile:)
                                                 name:EZAudioPlayerDidReachEndOfFileNotification
                                               object:self.player];
}

//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)playerDidChangePlayState:(NSNotification *)notification
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        EZAudioPlayer *player = [notification object];
        BOOL isPlaying = [player isPlaying];
        if (isPlaying)
        {
            weakSelf.recorder.delegate = nil;
        }

    });
}

//------------------------------------------------------------------------------

- (void)playerDidReachEndOfFile:(NSNotification *)notification
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.stateLabel.text = @"playing end";
        [weakSelf.playBtn setTitle:@"Start Play" forState:UIControlStateNormal];
    });
}


- (IBAction)microphoneAction:(id)sender {
    
    [self.player pause];
    
    BOOL isOn = [(UISwitch*)sender isOn];
    if (!isOn)
    {
        [self.microphone stopFetchingAudio];
        self.stateLabel.text = @"microphone is closed";
    }
    else
    {
        [self.microphone startFetchingAudio];
    }
}

- (IBAction)reacordAction:(id)sender {
    
    //microphone is closed,alert user
    if (!self.microSwitch.isOn) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"open microphone first" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertV show];
        return;
    }
    
    UIButton *btn = (UIButton *)sender;
    
    [self.player pause];
    if ([self.microSwitch isOn])
    {
        
        if ([btn.currentTitle isEqualToString:@"Start Record"]) {
            [btn setTitle:@"Stop Record" forState:UIControlStateNormal];
            //
            // Create the recorder
            //
            [self.microphone startFetchingAudio];
            self.recorder = [EZRecorder recorderWithURL:[self filePathURL]
                                           clientFormat:[self.microphone audioStreamBasicDescription]
                                               fileType:EZRecorderFileTypeM4A
                                               delegate:self];
            self.isRecording = YES;
            self.stateLabel.text = @"begin recording";
            self.playBtn.enabled = YES;
            
        }else if ([btn.currentTitle isEqualToString:@"Stop Record"]){
            [btn setTitle:@"Start Record" forState:UIControlStateNormal];
            if (self.recorder) {
                [self.microphone stopFetchingAudio];
                self.stateLabel.text = @"recording end";
            }
            
        }

    }
    
}

- (IBAction)playAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;

    //
    // Update microphone state
    //
    [self.microphone stopFetchingAudio];
    
    //
    // Update recording state
    //
    self.isRecording = NO;

    if ([btn.currentTitle isEqualToString:@"Start Play"]) {
        [btn setTitle:@"Stop Play" forState:UIControlStateNormal];
        //
        // Close the audio file
        //
        if (self.recorder)
        {
            [self.recorder closeAudioFile];
        }
        
//        EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:[self filePathURL]];
        NSURL *onlineUrl = [NSURL URLWithString:@"http://data10.5sing.kgimg.com/T1TcdnB4AT1R47IVrK.mp3"];
        EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:onlineUrl];
        
        [self.player playAudioFile:audioFile];
        
    }else if ([btn.currentTitle isEqualToString:@"Stop Play"]){
        [btn setTitle:@"Start Play" forState:UIControlStateNormal];
        if (self.player) {
            [self.player pause];
        }
        
    }
    
}

- (IBAction)resetAction:(id)sender {
    
    self.microSwitch.on = YES;
    [self.recordBtn setTitle:@"Start Record" forState:UIControlStateNormal];
    [self.playBtn setTitle:@"Start Play" forState:UIControlStateNormal];
    self.timeLabel.text = @"00:00";
    self.stateLabel.text = @"default";
    [self removeAudioFile];
    
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"All settings have been reset!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertV show];
    
}

- (IBAction)uploadAction:(id)sender {
    
    
}

- (IBAction)playStreamAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;

    if ([btn.currentTitle isEqualToString:@"Start Paly Stream"]) {

        [_streamer play];
        [btn setTitle:@"Stop Paly Stream" forState:UIControlStateNormal];

    }else{
        
        [_streamer pause];
        [btn setTitle:@"Start Paly Stream" forState:UIControlStateNormal];
    }
}

//------------------------------------------------------------------------------
#pragma mark - EZMicrophoneDelegate
//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone changedPlayingState:(BOOL)isPlaying
{
    NSLog(@"%d",isPlaying);
    
    if (isPlaying) {
        
    }
}

//------------------------------------------------------------------------------

#warning Thread Safety
//
// Note that any callback that provides streamed audio data (like streaming
// microphone input) happens on a separate audio thread that should not be
// blocked. When we feed audio data into any of the UI components we need to
// explicity create a GCD block on the main thread to properly get the UI to
// work.
- (void)   microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    // Getting audio data as an array of float buffer arrays. What does that
    // mean? Because the audio is coming in as a stereo signal the data is split
    // into a left and right channel. So buffer[0] corresponds to the float* data
    // for the left channel while buffer[1] corresponds to the float* data for
    // the right channel.
    
    //
    // See the Thread Safety warning above, but in a nutshell these callbacks
    // happen on a separate audio thread. We wrap any UI updating in a GCD block
    // on the main thread to avoid blocking that audio flow.
    //
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        // All the audio plot needs is the buffer data (float*) and the size.
        // Internally the audio plot will handle all the drawing related code,
        // history management, and freeing its own resources. Hence, one badass
        // line of code gets you a pretty plot :)
        //

    });
}

//------------------------------------------------------------------------------

- (void)   microphone:(EZMicrophone *)microphone
        hasBufferList:(AudioBufferList *)bufferList
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    //
    // Getting audio data as a buffer list that can be directly fed into the
    // EZRecorder. This is happening on the audio thread - any UI updating needs
    // a GCD main queue block. This will keep appending data to the tail of the
    // audio file.
    //
    if (self.isRecording)
    {
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
}

//------------------------------------------------------------------------------
#pragma mark - EZRecorderDelegate
//------------------------------------------------------------------------------

- (void)recorderDidClose:(EZRecorder *)recorder
{
    [self.recordBtn setTitle:@"Start Record" forState:UIControlStateNormal];
    recorder.delegate = nil;
    self.stateLabel.text = @"recording end";
}

//------------------------------------------------------------------------------

- (void)recorderUpdatedCurrentTime:(EZRecorder *)recorder
{
    __weak typeof (self) weakSelf = self;
    NSString *formattedCurrentTime = [recorder formattedCurrentTime];
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.timeLabel.text = formattedCurrentTime;
        weakSelf.stateLabel.text = @"recording......";
    });
}

//------------------------------------------------------------------------------
#pragma mark - EZAudioPlayerDelegate
//------------------------------------------------------------------------------

- (void) audioPlayer:(EZAudioPlayer *)audioPlayer
         playedAudio:(float **)buffer
      withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels
         inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

//------------------------------------------------------------------------------

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
    updatedPosition:(SInt64)framePosition
        inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.timeLabel.text = [audioPlayer formattedCurrentTime];
        weakSelf.stateLabel.text = @"playing......";
    });
}

//------------------------------------------------------------------------------
#pragma mark - Utility
//------------------------------------------------------------------------------

- (NSArray *)applicationDocuments
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
}

//------------------------------------------------------------------------------

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSURL *)filePathURL
{
    return [NSURL fileURLWithPath:[self filePath]];
}

- (NSString *)filePath {
    
    return [NSString stringWithFormat:@"%@/%@",
            [self applicationDocumentsDirectory],
            kAudioFilePath];
}

- (void)removeAudioFile {
    
    NSFileManager *fileM = [NSFileManager defaultManager];
    
    BOOL hasFile = [fileM fileExistsAtPath:[self filePath]];
    
    if (hasFile) {
        [fileM removeItemAtPath:[self filePath] error:nil];
    }else {
        
    }
    
}

@end
