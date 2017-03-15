def can_build(plat):
	return plat == "iphone" or plat=="android"

def configure(env):
	if (env['platform'] == 'android'):
		env.android_add_java_dir("android/src")
		env.android_add_to_manifest("android/AndroidManifestChunk.xml")
		env.android_add_dependency("compile 'com.google.android.gms:play-services-ads:8.4.0'")
		env.android_add_dependency("compile fileTree(dir: '../../../modules/appodeal/android/libs', include: '*.jar')")
	elif env['platform'] == "iphone":
		env.Append(FRAMEWORKPATH=['modules/appodeal/ios/lib'])
		env.Append(LINKFLAGS=['-ObjC', 
				      '-framework', 'Appodeal',
				      '-framework', 'AdSupport',
  				      '-framework', 'CFNetwork',
				      '-framework', 'CoreFoundation',
				      '-framework', 'CoreImage',
				      '-framework', 'CoreLocation',
			              '-framework', 'CoreTelephony',
				      '-framework', 'EventKit',
 				      '-framework', 'EventKitUI',
				      '-framework', 'MessageUI',
				      '-framework', 'MobileCoreServices',
				      '-framework', 'Social', 
			              '-framework', 'StoreKit',
				      '-framework', 'Twitter',
				      '-framework', 'WebKit',
 				      '-framework', 'JavaScriptCore',
				      '-framework', 'CoreBluetooth',
				      '-framework', 'GLKit', 
				      '-framework', 'SafariServices',
				      '-stdlib=libc++',
				      '-lsqlite3',
				      '-lxml2.2',
				      '-lz'
			])
#		env.Append(RESOURCES=['modules/appodeal/ios/lib/Resources/*'])

