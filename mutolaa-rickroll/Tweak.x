#import <Foundation/Foundation.h>

static NSString *const MutolaaAdsHost = @"cdn-minio.mutolaa.com";
static NSString *const MutolaaAdsPathPrefix = @"/media/ads/";
static NSString *const RickrollURL =
    @"https://www.myinstants.com/media/sounds/rick-rolled-meme-aetrim1602054550919.mp3";

static BOOL IsMutolaaAudioAdURL(NSString *value) {
    if (value.length == 0) {
        return NO;
    }

    NSString *lowercaseValue = value.lowercaseString;
    NSString *expectedPrefix =
        [NSString stringWithFormat:@"https://%@%@", MutolaaAdsHost,
                                   MutolaaAdsPathPrefix];
    NSString *URLWithoutQuery =
        [lowercaseValue componentsSeparatedByCharactersInSet:
                            [NSCharacterSet
                                characterSetWithCharactersInString:@"?#"]]
            .firstObject;

    return [lowercaseValue hasPrefix:expectedPrefix] &&
           [URLWithoutQuery hasSuffix:@".mp3"];
}

static NSString *ReplaceMutolaaAudioAdURL(NSString *value) {
    if (!IsMutolaaAudioAdURL(value)) {
        return value;
    }

    NSLog(@"[MutolaaRickroll] Replacing %@ with %@", value, RickrollURL);
    return RickrollURL;
}

%hook NSURL

+ (instancetype)URLWithString:(NSString *)URLString {
    return %orig(ReplaceMutolaaAudioAdURL(URLString));
}

+ (instancetype)URLWithString:(NSString *)URLString
                relativeToURL:(NSURL *)baseURL {
    return %orig(ReplaceMutolaaAudioAdURL(URLString), baseURL);
}

%end
