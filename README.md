# Prop Chooser
### An Enhanced addons for Prop Hunt: Enhanced which gives you ability for changing other objects/props within the Map's props or even Custom Props (with a list)

### How does it Works?
This addon only supported for Prop Hunt: Enhanced. Here's how it works:

Once the map has been loaded, map props will be scanned and added into a list, in serverside. Once player joined, the list will be available. Props can either use this feature by Pressing F8 key to bring up the menu. Props can have usage limit to change their prop as they want. By default, it has 3 time chance usage. If usage drains out, you cannot use it anymore. (or can be unlimited!)
If you have enough room to disguise other object (it has spatial detection, which this will prevent you stuck on the wall), select which props that you'd like to change and... Taadaaa...! hunters will confuse to find you!

Also to note that This addon is a Server-sided Feature. It's not mean to be available for client side!

### How to Contribute or Support?
Feel free to open a pull request with this repository, if you have any better suggestions!

I worked this nearly about 6 hours, pretty quickly because just wanted to make one. Hey if you have a time, Feel free to contribute by supporting!
Support on Official Website: https://prophuntenhanced.xyz/donate

### How's about Customisation and/or configurations?
I'll write a little documentation here how to configure this thing, without modifying it's code!

#### Console Variable & Configurations
- pcr_enable : Enable/Disable this Feature.
- pcr_allow_custom : Allow custom prop models to be added outside from the map's props.
- pcr_enable_prop_ban : Enable Prop Banning. This will also includes the ban list from PH:E Prop Bans list too.
- pcr_max_enable : Enable/Disable Limit the maximum of addition to the Prop Chooser.
- pcr_max_prop_list : Maximum number of Limit to be added to the Prop Chooser. Default is 100.
- pcr_max_use : Maximum Usage after Props chosen their Prop. Default is 3.
- pcr_default_key_menu : Default Key to open up a menu. Default is KEY_F8 (Value: 9). To change/bind to other keys, please see here: https://wiki.garrysmod.com/page/Enums/BUTTON_CODE

** Experimental Section **
- pcr_enable_bbox_limit : Enable/Disable Prop's Bounding Box (AABB)/Hull Size Limit. Purpose is to prevent using any larger objects which might be unexpected.
- pcr_bbox_max_height : Entity Max Height of Bounding Box (AABB)/Hull Size. Default is 96, 72 (Standard Kleiner model).
- pcr_bbox_max_width : Entity Max Width of Bounding Box (AABB)/Hull Size. Default is 72, 56, or 48.

#### How to Add Custom Props & Adding Prop Bans?
Simply, navigate to your Root Garry's Mod game data folder, e.g: "../garrysmod/data/phe_config/"

You'll see two folder called:
- A folder "prop_chooser_custom" containing "models.txt", which will be used to add new Props Model; and
- A folder "prop_model_bans" containing "model_bans.txt" and "pcr_bans.txt" which will be used to add Prop Bans model.
- Make sure these files & folders are Writeable!

Each data will contains something like this:
```json
[
	"models/something.mdl",
	"models/anothermodels.mdl",
	-- And here you can add more models with specified path/models you want.
]
```

#### But, How do I get model listed after it being added?
Currently there is a console command to debug which models has been added to the Prop Chooser List. By using a command: "pcr_debug_model_list"
This command will prints All available models listed which specified from the maps, and can be accessed only by Admin/Superadmin.

### I got Errors!
Please open up an issue on Issue tracker if you have anything with Error and other issues related. Please NOTE that:
- This addon is in BETA stage. Buggy may still persists!
- This Addon currently only works with Prop Hunt: Enhanced gamemode. There are currently support for Classic version yet!.
- If you don't subscribed PH:E, the addon will throw the Error.