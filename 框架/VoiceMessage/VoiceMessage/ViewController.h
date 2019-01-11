//
//  ViewController.h
//  VoiceMessage
//
//  Created by WengHengcong on 16/2/15.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudio.h>

@interface ViewController : UIViewController <EZAudioPlayerDelegate, EZMicrophoneDelegate, EZRecorderDelegate>


@property (nonatomic, copy) NSArray *tracks;

//
// The microphone component
//
@property (nonatomic, strong) EZMicrophone *microphone;

//
// The audio player that will play the recorded file
//
@property (nonatomic, strong) EZAudioPlayer *player;
//
// The recorder component
//
@property (nonatomic, strong) EZRecorder *recorder;

@property (nonatomic, assign) BOOL isRecording;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UISwitch *microSwitch;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *playStreamBtn;



- (IBAction)microphoneAction:(id)sender;

- (IBAction)reacordAction:(id)sender;

- (IBAction)playAction:(id)sender;

- (IBAction)resetAction:(id)sender;

- (IBAction)uploadAction:(id)sender;

- (IBAction)playStreamAction:(id)sender;

@end

