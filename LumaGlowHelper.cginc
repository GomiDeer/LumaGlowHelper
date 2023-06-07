#ifndef GOMI_LUMAGLOW_CGINC_INCLUDED
#define GOMI_LUMAGLOW_CGINC_INCLUDED
// I'm including the "GOMI_" prefix here incase Furality ever decides to distribute their own include file.
// I don't want to chance colliding with their def.

// ## Helper functions for Furality's Luma Glow ##
// These functions are essentially ripped straight from the Luma code in Furality's shaders.
// If your building an Amplify shader you can grab these functions from the Furality Shader package itself.
// This include file is meant to extend those functions to shader artists that don't use Amplify.
// Include file created by Gomi Deer: https://twitter.com/Gomi_Deer
// Furality's Luma Glow created by Naito Ookami: https://twitter.com/NaitoOokami

// Luma Glow v4 is an extension of AudioLink. It injects itself into the top of the render texture.
// We can think of this as essentially inverting our lookups to the top of the AudioLink texture.
#define LUMA_GLOW_BAND                      56
#define LUMA_GRADIENT_OFFSET                59
#define LUMA_ZONE_OFFSET                    63

// This is taken directly from the AudioLink shader and will only run if you don't include AudioLink yourself in your shader.
// This is the minimum code that Luma needs to grab its data.
// I know some shader developers copy the AL code into their shader rather than using the AL include file (Poi for instance).
// ALPASS_AUDIOLINK is checked here to try to prevent collisions in those shaders.
// This could probably be a more in-depth definition check but... If you're implementing AL in your own code 
// already you should do the same with these functions instead of including this file.
#if !defined(AUDIOLINK_CGINC_INCLUDED) || !defined(ALPASS_AUDIOLINK)
    #define ALPASS_AUDIOLINK                uint2(0,0)  //Size: 128, 4

    uniform float4 _AudioTexture_TexelSize;

    #ifdef SHADER_TARGET_SURFACE_ANALYSIS
    #define AUDIOLINK_STANDARD_INDEXING
    #endif

    // Mechanism to index into texture.
    #ifdef AUDIOLINK_STANDARD_INDEXING
        sampler2D _AudioTexture;
        #define AudioLinkData(xycoord) tex2Dlod(_AudioTexture, float4(uint2(xycoord) * _AudioTexture_TexelSize.xy, 0, 0))
    #else
        uniform Texture2D<float4>   _AudioTexture;
        #define AudioLinkData(xycoord) _AudioTexture[uint2(xycoord)]
    #endif

    // Mechanism to sample between two adjacent pixels and lerp between them, like "linear" supesampling
    float4 AudioLinkLerp(float2 xy) { return lerp( AudioLinkData(xy), AudioLinkData(xy+int2(1,0)), frac( xy.x ) ); }

    //Tests to see if Audio Link texture is available
    bool AudioLinkIsAvailable(){
        #if !defined(AUDIOLINK_STANDARD_INDEXING)
            int width, height;
            _AudioTexture.GetDimensions(width, height);
            return width > 16;
        #else
            return _AudioTexture_TexelSize.z > 16;
        #endif
    }
#endif

//Tests to see if Luma is available on the Audio Link texture.
bool IsLumaAvailable() {
    if (AudioLinkIsAvailable()) {
        return AudioLinkData( ALPASS_AUDIOLINK + uint2( 0, LUMA_GLOW_BAND ) ).r;
    } else {
        return false;
    }
}

//Grabs the color from a luma color zone.
float3 GetLumaZone(uint zone, int delay) {
    if (zone < 1 || zone > 4) { //At least forces a correct zone if an invalid zone is given.
        zone = 1;
    }
    zone = zone - 1; //We could just start at 0 but... This makes documentation easier :)

    return AudioLinkData(ALPASS_AUDIOLINK + uint2(delay, LUMA_ZONE_OFFSET - zone));
}

//Grabs the color from a luma gradient zone.
float3 GetLumaGradientZone(uint zone, int delay) {
    if (zone < 1 || zone > 3) { //At least forces a correct zone if an invalid zone is given.
        zone = 1;
    }
    zone = zone - 1; //Same as above lmao.

    return AudioLinkData(ALPASS_AUDIOLINK + uint2(delay, LUMA_GRADIENT_OFFSET - zone));
}

#endif