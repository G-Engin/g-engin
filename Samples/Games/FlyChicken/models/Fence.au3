#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         RonildoSouza

 Script Function:
	

#ce ----------------------------------------------------------------------------

Local Const $iFENCE_POINT = 10
Local Const $iFENCE_NUMBER = 3
Local Const $iFENCE_SPEED = -100
Local Const $dFENCE_WIDTH = $dCHICKEN_SIZE_H
Local Const $sFENCE_TOP_IMAGE = "../res/flychicken/images/fence_top.png"
Local Const $sFENCE_BOT_IMAGE = "../res/flychicken/images/fence_bottom.png"
Local Const $dFENCE_MAX_HEIGHT = $scrH / 2 - $dCHICKEN_SIZE_H / 2
Local Const $dFENCE_MIN_HEIGHT = $scrH / 3 - $dCHICKEN_SIZE_H / 2 * 2

Dim $iScore = 0
Local $aSprTopFences[$iFENCE_NUMBER]
Local $aSprBottomFences[$iFENCE_NUMBER]


Func _FenceCreate()
	Local $dFencePosX = $scrW + $dFENCE_WIDTH

	For $r = 0 To ($iFENCE_NUMBER - 1) Step +1
		__FenceSetSizeHeight()

		$aSprTopFences[$r] = __FenceCreateSprite($dHeightTopFence, $dFencePosX, 0, $GEng_Origin_TR)
		$aSprBottomFences[$r] = __FenceCreateSprite($dHeightBottomFence, $dFencePosX, $scrH, $GEng_Origin_BR)

		$dFencePosX += $dCHICKEN_SIZE_W * 2.5
	Next
EndFunc   ;==>_FenceCreate


Func _FenceDraw()
	For $r = 0 To ($iFENCE_NUMBER - 1) Step +1
		_GEng_Sprite_Draw($aSprTopFences[$r])
		_GEng_Sprite_Draw($aSprBottomFences[$r])
	Next
EndFunc   ;==>_FenceDraw


Func _FenceMove()
	Local $dTmpFencePosX
	
	If ($bGamePlaying) Then
		For $r = 0 To ($iFENCE_NUMBER - 1) Step +1
			__FenceSetSizeHeight()

			_GEng_Sprite_SpeedSet($aSprTopFences[$r], $iFENCE_SPEED, 0, -($iFENCE_SPEED))
			_GEng_Sprite_SpeedSet($aSprBottomFences[$r], $iFENCE_SPEED, 0, -($iFENCE_SPEED))

			_GEng_Sprite_PosGet($aSprTopFences[$r], $dTmpFencePosX, Null)

			_ChickenCheckCollision($aSprTopFences[$r], $aSprBottomFences[$r])

			If (__FenceExitedTheScreen($dTmpFencePosX)) Then
				$dNewFencePosX = $scrW + $dCHICKEN_SIZE_W * 2.5
				
				__FenceAttrSet($aSprTopFences[$r], $dHeightTopFence, $dNewFencePosX, 0, $GEng_Origin_TR)
				__FenceAttrSet($aSprBottomFences[$r], $dHeightBottomFence, $dNewFencePosX, $scrH, $GEng_Origin_BR)

				$iScore += $iFENCE_POINT
			EndIf
		Next
	EndIf
EndFunc   ;==>_FenceMove


#cs
	Private Functions
#ce

Func __FenceSetSizeHeight()
	Global $dHeightTopFence = Random($dFENCE_MIN_HEIGHT, $dFENCE_MAX_HEIGHT, 1)
	Global $dHeightBottomFence = $scrH - ($dCHICKEN_SIZE_H * 2) - $dHeightTopFence
EndFunc   ;==>__FenceSetSizeHeight


Func _FenceRestartScore()
	$iScore = 0
EndFunc   ;==>_FenceRestartScore


Func _FenceGetScore()
	Return $iScore
EndFunc   ;==>_FenceGetScore


Func __FenceCreateSprite($dHeight, $dPosX, $dPosY, $eOrigin)
	Local $oImgTube = ($eOrigin == $GEng_Origin_TR) ? _GEng_ImageLoad($sFENCE_TOP_IMAGE) : _GEng_ImageLoad($sFENCE_BOT_IMAGE)

	$oSprite = _GEng_Sprite_Create($oImgTube)
	__FenceAttrSet($oSprite, $dHeight, $dPosX, $dPosY, $eOrigin)

	Return $oSprite
EndFunc   ;==>__FenceCreateSprite


Func __FenceAttrSet(ByRef $oSprite, $dHeight, $dPosX, $dPosY, $eOrigin)
	_GEng_Sprite_SizeSet($oSprite, $dFENCE_WIDTH, $dHeight)
	_GEng_Sprite_CollisionSet($oSprite, 1, 0, 0, $dFENCE_WIDTH, $dHeight)
	_GEng_Sprite_OriginSetEx($oSprite, $eOrigin)
	_GEng_Sprite_PosSet($oSprite, $dPosX, $dPosY)
EndFunc   ;==>__FenceAttrSet


Func __FenceExitedTheScreen($dFencePosX)
	;~ Return ($dFencePosX + $dFENCE_WIDTH <= 0)
	Return ($dFencePosX <= 0)
EndFunc   ;==>__FenceExitedTheScreen
