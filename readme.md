# SUI

<p style="text-align: left;"><span style="font-family: tahoma, arial, helvetica, sans-serif; font-size: 24px;">Features</span></p>
<ul>
<li><span style="font-family: tahoma, arial, helvetica, sans-serif;">Enhanced WoW Interface</span></li>
<li><span style="font-family: tahoma, arial, helvetica, sans-serif;">An intuitive and powerful configuration menu</span></li>
<li><span style="font-family: tahoma, arial, helvetica, sans-serif;">Minimalistic and modular</span></li>
</ul>
<p>&nbsp;</p>
<p><span style="font-family: tahoma, arial, helvetica, sans-serif; font-size: 24px;">Quick Start</span></p>
<ul>
<li><span style="font-family: tahoma, arial, helvetica, sans-serif;">To open the configuration menu, type <span style="font-family: terminal, monaco, monospace;">/SUI</span>&nbsp;into your chat and hit enter&nbsp;</span></li>
</ul>
<p><span style="font-family: tahoma, arial, helvetica, sans-serif;">&nbsp;</span></p>
<p><span style="font-family: tahoma, arial, helvetica, sans-serif; font-size: 24px;">Issues</span></p>
<ul>
<li><span style="font-family: tahoma, arial, helvetica, sans-serif;">If you've discovered something that's clearly wrong, or if you get an error,&nbsp;<a href="https://github.com/Syiana/SUI/issues/new/choose" target="_blank" rel="noopener noreferrer">post&nbsp;an&nbsp;Issue</a>.</span></li>
<li><span style="font-family: tahoma, arial, helvetica, sans-serif;">Feel free to join our&nbsp;<a href="https://discord.gg/S3r4Acqvqv" target="_blank" rel="nofollow noopener noreferrer">Discord Community</a>&nbsp;to talk, get help and discuss everything about SUI!</span></li>
</ul>
<p><span style="font-family: tahoma, arial, helvetica, sans-serif;">&nbsp;</span></p>
<p><span style="font-family: tahoma, arial, helvetica, sans-serif; font-size: 24px;">Support</span></p>
<ul>
<li><span style="font-family: tahoma, arial, helvetica, sans-serif;">If you want to help out with development without providing code yourself, you can always donate to SUI using <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&amp;hosted_button_id=52MJHGYAEKNM4&amp;source=url" target="_blank" rel="noopener noreferrer">PayPal</a> or <a href="https://www.patreon.com/syiana" target="_blank" rel="noopener noreferrer">Patreon</a></span></li>
<li id="tw-target-text" class="tw-data-text tw-text-large tw-ta" dir="ltr" data-placeholder="&Uuml;bersetzung"><span lang="en" style="font-family: tahoma, arial, helvetica, sans-serif;" tabindex="0">Also make sure that you follow me on <a href="https://www.twitch.tv/syiana" target="_blank" rel="noopener noreferrer">Twitch.tv/Syiana</a></span></li>
</ul>
<p>&nbsp;</p>
<p><span lang="en" style="font-family: tahoma, arial, helvetica, sans-serif;" tabindex="0"><a href="https://www.paypal.com/donate/?return=https://www.curseforge.com/projects/283939&cn=Add+special+instructions+to+the+addon+author()&business=suiaddon%40gmail.com&bn=PP-DonationsBF:btn_donateCC_LG.gif:NonHosted&cancel_return=https://github.com/Syiana/SUI/&lc=US&item_name=SUI+(from+github.com)&cmd=_donations&rm=1&no_shipping=1&currency_code=EUR" target="_blank" rel="noopener noreferrer"><img src="https://i.imgur.com/Ugdh5p9.png" width="48" height="48" /></a><a href="https://discord.gg/GBdV2DBm6w" target="_blank" rel="noopener noreferrer"><img src="https://i.imgur.com/TMEOSOY.png" alt="" width="48" height="48" /></a><a href="https://www.twitch.tv/syiana" target="_blank" rel="noopener noreferrer"><img src="https://i.imgur.com/2x5x5wx.png" alt="" width="48" height="48" /></a></span></p>

## Add Custom Fonts and Textures to SUI

Open: `World of Warcraft/_retail_/Interface/AddOns/SUI/Media/`

Add your Texture file to: `Textures/`
Add your Font file to `Fonts/`

Edit File `Media\RegisterMediaLSM.lua`

**Adding Texture**

    LSM:Register("statusbar",  "YourTextureName",  [[Interface\Addons\SUI\Media\Textures\Status\YourTextureName.blp]])

**Adding Font**

    LSM:Register("font",  "YourFontName",  [[Interface\Addons\SUI\Media\Textures\Fonts\YourFontName.blp]])
