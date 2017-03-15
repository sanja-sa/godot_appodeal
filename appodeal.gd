extends Node

var appodeal = null
var key = null

signal sg_ns_video_shown
signal sg_ns_video_closed
signal sg_ns_video_loaded
signal sg_ns_video_finished
signal sg_ns_video_failed_load

signal sg_interstitial_shown
signal sg_interstitial_closed
signal sg_interstitial_loaded
signal sg_interstitial_clicked
signal sg_interstitial_failed_load

func init():
	if(Globals.has_singleton("Appodeal")):
		key =str(Globals.get("User/appodeal_" + OS.get_name().to_lower() + "_key"))
		appodeal = Globals.get_singleton("Appodeal")
		
		# true -- testing
		#"banner"
		#"banner/video"
		#"banner/rewardedvideo"
		#"banner/interstitial"
		
		#"video"
		
		#"interstitial"
		#"interstitial/video"
		
		#"nonSkipVideo"
		#"interstitial/nonSkipVideo"

		#"rewardedvideo"
		#"rewarded/interstitial"
		appodeal.init(get_instance_ID(), key, "interstitial/nonSkipVideo", false)
		
		appodeal.registerCallback("onNonSkippableVideoShown", "_on_ns_video_shown")
		appodeal.registerCallback("onNonSkippableVideoClosed", "_on_ns_video_closed")
		appodeal.registerCallback("onNonSkippableVideoLoaded", "_on_ns_video_loaded")
		appodeal.registerCallback("onNonSkippableVideoFinished", "_on_ns_video_finished")
		appodeal.registerCallback("onNonSkippableVideoFailedToLoad", "_on_ns_video_failed_to_load")

		appodeal.registerCallback("onInterstitialShown", "_on_interstitial_shown")
		appodeal.registerCallback("onInterstitialClosed", "_on_interstitial_closed")
		appodeal.registerCallback("onInterstitialLoaded", "_on_interstitial_loaded")
		appodeal.registerCallback("onInterstitialClicked", "_on_interstitial_clicked")
		appodeal.registerCallback("onInterstitialFailedToLoad", "_on_interstitial_failed_to_load")

func _ready():
	pass

# NON SKIPIBALE VIDEO
func showNonSkipVideoAd(placement_name = ""):
	appodeal.showNonSkipVideoAd(placement_name)
	
func loadNonSkipVideoAd():
	appodeal.loadNonSkipVideoAd()
	
func isNonSkipVideoLoaded():
	return appodeal.isNonSkipVideoLoaded()
	
func _on_ns_video_shown():
	emit_signal("sg_ns_video_shown")
	
func _on_ns_video_closed():
	emit_signal("sg_ns_video_closed")
	
func _on_ns_video_loaded():
	emit_signal("sg_ns_video_loaded")
	
func _on_ns_video_finished():
	emit_signal("sg_ns_video_finished")

func _on_ns_video_failed_to_load():
	emit_signal("sg_ns_video_failed_load")

# Interstitial
func showInterstitialAd(placement_name = ""):
	appodeal.showInterstitialAd(placement_name)
	
func loadInterstitialAd():
	appodeal.loadInterstitialVideoAd()
	
func isInterstitialLoaded():
	return appodeal.isInterstitialLoaded()

func _on_interstitial_shown():
	emit_signal("sg_interstitial_shown")
	
func _on_interstitial_closed():
	emit_signal("sg_interstitial_closed")
	
func _on_interstitial_loaded():
	emit_signal("sg_interstitial_loaded")
	
func _on_interstitial_clicked():
	emit_signal("sg_interstitial_clicked")

func _on_interstitial_failed_to_load():
	emit_signal("sg_interstitial_failed_load")
	
