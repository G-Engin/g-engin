#Include <Misc.au3>
#include <GUIConstantsEx.au3>
#include "..\GEngin.au3"

#Region https://www.autoitscript.com/autoit3/docs/libfunctions/_IsPressed.htm
 Local Const $SPACEBAR = 20
#EndRegion 

Global $scrW = 480, $scrH = 320 
Global Const $iExplosionFrameCount = 20

_GEng_Start("Sound And Animation", $scrW, $scrH)

#cs
	Initialize sound system
	Prototype:
		_GEng_Sound_Init($iSampleRate = 44100, $iStereo = 1)

	Remarks:
		Must be called before loading the audio file.
#ce
_GEng_Sound_Init()

#Region Load Image and Sound
 $oImageExplosion = _GEng_ImageLoad("./res/images/sound_and_animation/explosion_20_frames.png")
 $oSoundExplosion = _GEng_Sound_Load("./res/sounds/explosion.wav")
#EndRegion

#cs
	Create animation and set the frames
	Remarks:
		Frame duration (in ms) = 390
		Top left corner position of the rectangle, Axis X = 50 multiplied by the current frame number
		Top left corner position of the rectangle, Axis Y = 0
		Size of the rectangle width of a frame = 50
		Size of the rectangle heigth of a frame = 128
#ce
$oAnimationExplosion = _GEng_Anim_Create()
For $i = 0 To $iExplosionFrameCount
	_GEng_Anim_FrameAdd($oAnimationExplosion, $oImageExplosion, 390, 50 * $i, 0, 50, 128)
Next

$oSpriteExplosion = _GEng_Sprite_Create()
_GEng_Sprite_OriginSetEx($oSpriteExplosion, $GEng_Origin_Mid)
_GEng_Sprite_PosSet($oSpriteExplosion, ($scrW - 50) / 2, $scrH - 200)

$oFont = _GEng_Font_Create("Comic Sans MS", 25)
$oText = _GEng_Text_Create($oFont, "", $GEng_Color_Navy, 0, 0, $scrW, $scrH)

Do
	_GEng_ScrFlush($GEng_Color_White)
	;~ ---
	
	If (_IsPressed($SPACEBAR) And Not _GEng_Sound_IsPlaying($oSoundExplosion)) Then
		;~ Execute sound
		_GEng_Sound_Play($oSoundExplosion)
	EndIf

	;~ Check if sound is playing and start animation
	If(_GEng_Sound_IsPlaying($oSoundExplosion)) Then
		_GEng_Sprite_Animate($oSpriteExplosion, $oAnimationExplosion)
		_GEng_Sprite_Draw($oSpriteExplosion)
	EndIf

	#Region Draw Text
	 If (_GEng_Sound_IsPlaying($oSoundExplosion)) Then
	 	 _GEng_Text_StringSet($oText, "* Blowing up")
	 Else
		 _GEng_Text_StringSet($oText, "* Spacebar => Start Explosion")
	 EndIf
	 _GEng_Text_Draw($oText)		
	#EndRegion

	;~ ---
	_GEng_ScrUpdate()
Until GuiGetMsg() = $GUI_EVENT_CLOSE

_GEng_Font_Delete($oFont)
_GEng_Text_Delete($oText)
_GEng_Shutdown()