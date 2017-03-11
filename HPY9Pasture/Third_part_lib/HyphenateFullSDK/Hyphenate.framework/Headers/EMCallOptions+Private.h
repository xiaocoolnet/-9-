//
//  EMCallOptions+Private.h
//  HyphenateSDK
//
//  Created by XieYajie on 8/5/16.
//  Copyright © 2016 easemob.com. All rights reserved.
//

#import "EMCallOptions.h"

#include "call/emcallmanagerconfigs.h"

@interface EMCallOptions (Private)

- (void)setCoreConfigs:(easemob::EMCallConfigsPtr)configs;

- (easemob::EMCallConfigsPtr)getCoreConfigs;

@end
