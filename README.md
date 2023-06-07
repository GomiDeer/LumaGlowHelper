# Helper Library For Furality Luma

This is a simple library to help shader artists use Furality's Luma functionality in their own shader. 

## Why?
These functions are relatively easy to include in your own code, and if you'd like to use them without including this file feel free to. Really, I made this so that the Luma v4.0+ functionality is documented somewhere, to make it easier for shader artists to include Luma in the future.

This file is not maintained by Furality, however I plan to update it ASAP whenever Furality makes breaking changes to Luma for as long as I'm still active in VRChat. The main benefit to using this is that, once updated, all you need to do is pull the changes and your shader should be up to date, as I don't plan to make any breaking changes to these functions. Any new features will be added as separate functions in the future.

# How To Use

```IsLumaAvailable()``` is pretty self-explanatory and checks to see, first, if AudioLink is available, and then checks to see if Luma is enabled on the texture.

```GetLumaZone(uint zone, uint delay)``` returns the given color value for one of the four color zones luma provides. Valid values for "zone" are 1-3, outside of that you will be sampling from incorrect values. Anything outside of 1-4 will be converted to 1.

```GetLumaGradientZone(uint zone, uint delay)``` returns the given color value for one of the three gradient zones Luma provides. Valid values for "zone" are 1-3, outside of that you will be sampling from incorrect values. Anything outside of 1-3 will be converted to 1.

# How Luma Works

>I am not the developer on Luma, nor am I an experienced shader developer, the below information was pieced together both from talks I've had with Furality's shader artist (https://twitter.com/NaitoOokami) and my own fiddling around in their code/worlds.

Furality's Luma Glow is precomputed data and received through pixel colors sent in a video stream in Furality worlds. As of Luma Glow v4.0 this data is then injected into the top of the AudioLink render texture and can then be sampled using AudioLink's built in functionality.

To read more about Furality's Luma Glow: https://furality.org/sylva-shader-guide

# Note
I'm not and do not pretend to be a shader developer. If you run into issues (or just see glaring problems) please feel free to inform me or make a PR to fix it.