#ifndef GODOTAPPODEAL_H
#define GODOTAPPODEAL_H

#include "reference.h"

class GodotAppodeal : public Reference {
    OBJ_TYPE(GodotAppodeal, Reference);

    static void _bind_methods();

    int  instance_id;
    bool initialized;
    bool is_testing;

public:
    void init(int new_instance_id, const String& str_key, const String& str_type, bool b_is_testing);
    void run_callback(const String& str_func);

    void registerCallback(const String& callback_type, const String& callback_function);
    void unregisterCallback(const String& callback_type);

    // Interstitial
    bool isInterstitialLoaded();
    void loadInterstitialVideoAd();
    void showInterstitialAd(const String& str_placement);

    // NonSkipped
    bool isNonSkipVideoLoaded();
    void loadNonSkipVideoAd();
    void showNonSkipVideoAd(const String& str_placement);

    GodotAppodeal();
    ~GodotAppodeal();
};

#endif
