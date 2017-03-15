#include "GodotAppodeal.h"
#import <Appodeal/Appodeal.h>

#include "core/globals.h"
#include "core/variant.h"
#include "core/message_queue.h"
#include "core/hash_map.h"

#import "app_delegate.h"

GodotAppodeal* instance = nil;

HashMap<String, String> m_callback_funcs;

@interface GodotAppodealDelegateBridge: NSObject<AppodealInterstitialDelegate, AppodealNonSkippableVideoDelegate>
@end

static GodotAppodealDelegateBridge* s_p_delegate = nil;

void GodotAppodeal::run_callback(const String& str_func)
{      
    if(initialized && m_callback_funcs.has(str_func))
	    MessageQueue::get_singleton()->push_call(instance_id, m_callback_funcs[str_func]);
};

void GodotAppodeal::init(int new_instance_id, const String& str_key, const String& str_type, bool b_is_testing)
{
    if(!initialized)
    {
	instance_id = new_instance_id;
	is_testing = b_is_testing;
	if(is_testing)
		[Appodeal setTestingEnabled: YES];
	else
		[Appodeal setTestingEnabled: NO];
	

	NSString *nsAppodealKey = [NSString stringWithCString:str_key.utf8().get_data() encoding:NSUTF8StringEncoding];

        s_p_delegate = [[GodotAppodealDelegateBridge alloc] init];

        [Appodeal setInterstitialDelegate:s_p_delegate];
        [Appodeal setNonSkippableVideoDelegate:s_p_delegate];
        
        [Appodeal setLocationTracking:NO];
       
	[Appodeal setAutocache: NO types:AppodealAdTypeBanner];
	[Appodeal setAutocache: NO types:AppodealAdTypeInterstitial];
	[Appodeal setAutocache: NO types:AppodealAdTypeSkippableVideo];
	[Appodeal setAutocache: NO types:AppodealAdTypeRewardedVideo];
	[Appodeal setAutocache: NO types:AppodealAdTypeNonSkippableVideo];
        	
        AppodealAdType type_ad = (AppodealAdType)0;
	if(str_type == "banner")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeBanner);
	} else if(str_type == "banner/video")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeSkippableVideo | AppodealAdTypeBanner);
	} else if(str_type == "banner/rewardedvideo")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeBanner | AppodealAdTypeRewardedVideo);
	} else if(str_type == "banner/interstitial")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeInterstitial | AppodealAdTypeRewardedVideo);
	} else if(str_type == "video")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeSkippableVideo);
	} else if(str_type == "interstitial")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeInterstitial);
	} else if(str_type == "interstitial/video")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeInterstitial | AppodealAdTypeSkippableVideo);
	} else if(str_type == "nonSkipVideo")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeNonSkippableVideo);
	} else if(str_type == "rewardedvideo")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeRewardedVideo);
	} else if(str_type == "rewarded/interstitial")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeRewardedVideo|AppodealAdTypeInterstitial);
	} else if(str_type == "interstitial/nonSkipVideo")
	{
		type_ad = (AppodealAdType)(AppodealAdTypeNonSkippableVideo|AppodealAdTypeInterstitial);
	}

        [Appodeal initializeWithApiKey:nsAppodealKey
                    types:(AppodealAdType)type_ad];

        initialized = true;
    }
};

void GodotAppodeal::_bind_methods()
{
    ObjectTypeDB::bind_method(_MD("init"),                  	&GodotAppodeal::init);
    ObjectTypeDB::bind_method(_MD("registerCallback"),   	&GodotAppodeal::registerCallback);
    ObjectTypeDB::bind_method(_MD("unregisterCallback"),   	&GodotAppodeal::unregisterCallback);


    ObjectTypeDB::bind_method(_MD("showInterstitialAd"),   	&GodotAppodeal::showInterstitialAd);
    ObjectTypeDB::bind_method(_MD("loadInterstitialVideoAd"),   &GodotAppodeal::loadInterstitialVideoAd);
    ObjectTypeDB::bind_method(_MD("isInterstitialLoaded"),   	&GodotAppodeal::isInterstitialLoaded);


    ObjectTypeDB::bind_method(_MD("showNonSkipVideoAd"),   	&GodotAppodeal::showNonSkipVideoAd);
    ObjectTypeDB::bind_method(_MD("loadNonSkipVideoAd"),  	&GodotAppodeal::loadNonSkipVideoAd);
    ObjectTypeDB::bind_method(_MD("isNonSkipVideoLoaded"),   	&GodotAppodeal::isNonSkipVideoLoaded);
};

GodotAppodeal::GodotAppodeal()
{
    ERR_FAIL_COND(instance != NULL);
    instance = this;
    initialized = false;
};

GodotAppodeal::~GodotAppodeal()
{
};

void GodotAppodeal::registerCallback(const String& callback_type, const String& callback_function)
{
	m_callback_funcs[callback_type] = callback_function;
};

void GodotAppodeal::unregisterCallback(const String& callback_type)
{
	m_callback_funcs.erase(callback_type);
};

//
// Interstitial
//
bool GodotAppodeal::isInterstitialLoaded() 
{
	
	if(!initialized)
		return false;
	return [Appodeal isReadyForShowWithStyle: AppodealShowStyleInterstitial];
};

void GodotAppodeal::loadInterstitialVideoAd()
{
	if(!initialized)
		return;
	[Appodeal cacheAd:AppodealAdTypeInterstitial];
};

void GodotAppodeal::showInterstitialAd(const String& str_placement)
{
	if(!initialized)
		return;
	NSString *stri_placement = [NSString stringWithCString:str_placement.utf8().get_data() encoding:NSUTF8StringEncoding];
	[Appodeal showAd:AppodealShowStyleInterstitial forPlacement:stri_placement rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
};

//
// NonSkippible
//
bool GodotAppodeal::isNonSkipVideoLoaded()
{
	if(!initialized)
		return false;
	return [Appodeal isReadyForShowWithStyle: AppodealShowStyleNonSkippableVideo];

};

void GodotAppodeal::showNonSkipVideoAd(const String& str_placement)
{
	if(!initialized)
		return;
       	NSString *stri_placement = [NSString stringWithCString:str_placement.utf8().get_data() encoding:NSUTF8StringEncoding];
	[Appodeal showAd:AppodealShowStyleNonSkippableVideo forPlacement:stri_placement rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
};

void GodotAppodeal::loadNonSkipVideoAd()
{
	if(!initialized)
		return;
	[Appodeal cacheAd:AppodealAdTypeNonSkippableVideo];
};

// delegates
@implementation GodotAppodealDelegateBridge

// Interstitial
- (void)interstitialDidLoadAdisPrecache:(BOOL)precache {
    if (instance)
	instance->run_callback("onInterstitialLoaded");
}

- (void)interstitialDidFailToLoadAd {
    if (instance)
	instance->run_callback("onInterstitialFailedToLoad");
}

- (void)interstitialWillPresent {
    if (instance)
	instance->run_callback("onInterstitialShown");
}

- (void)interstitialDidClick {
    if (instance)
	instance->run_callback("onInterstitialClicked");
}

- (void)interstitialDidDismiss {
    if (instance)
	instance->run_callback("onInterstitialClosed");
}

// NONSKIP
- (void)nonSkippableVideoDidLoadAd
{
    if (instance)
	instance->run_callback("onNonSkippableVideoLoaded");
}

- (void)nonSkippableVideoDidFailToLoadAd
{
    if (instance)
	instance->run_callback("onNonSkippableVideoFailedToLoad");
}

- (void)nonSkippableVideoDidPresent
{
    if (instance)
	instance->run_callback("onNonSkippableVideoShown");
}

- (void)nonSkippableVideoWillDismiss
{
    if (instance)
	instance->run_callback("onNonSkippableVideoClosed");
}

- (void)nonSkippableVideoDidFinish
{
    if (instance)
	instance->run_callback("onNonSkippableVideoFinished");
}

- (void)nonSkippableVideoDidClick
{
    if (instance)
	instance->run_callback("onNonSkippableVideoClicked");
}

@end
