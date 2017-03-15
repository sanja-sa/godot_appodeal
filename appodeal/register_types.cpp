#include "register_types.h"
#include "object_type_db.h"
#include "core/globals.h"
#include "ios/src/GodotAppodeal.h"

void register_appodeal_types() 
{
    Globals::get_singleton()->add_singleton(Globals::Singleton("Appodeal", memnew(GodotAppodeal)));
}

void unregister_appodeal_types() 
{
}
