# Add Custom Fonts and Textures to SUI

Open: `World of Warcraft/_retail_/Interface/AddOns/SUI/Media/`

Add your Texture file to: `Textures/`
Add your Font file to `Fonts/`

Edit File `Media\RegisterMediaLSM.lua`

**Adding Texture**

    LSM:Register("statusbar",  "YourTextureName",  [[Interface\Addons\SUI\Media\Textures\Status\YourTextureName.blp]])

**Adding Font**

       LSM:Register("font",  "YourFontName",  [[Interface\Addons\SUI\Media\Textures\Fonts\YourFontName.blp]])
