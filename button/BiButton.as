
package button
{

	// Play as state0
	// Pause as state1

	import flash.display.Sprite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.events.MouseEvent;

	import label.BiHint;

	public class BiButton extends Sprite
	{

		private static var _modes = [ "State1Inactive", "State1Active", "State0Inactive", "State0Active" ];

		private static var _modeIndexState1Inactive = 0;
		private static var _modeIndexState1Active = 1;
		private static var _modeIndexState0Inactive = 2;
		private static var _modeIndexState0Active = 3;

		private var _clickState0Callback: Function;
		private var _clickState1Callback: Function;

		private var _curModeIndex;
		private var _prevModeIndex;

		private var _biHint: BiHint;

		public function BiButton(	bmpState0Inactive: BitmapData,
									bmpState0Active: BitmapData, 
									bmpState1Inactive: BitmapData, 
									bmpState1Active: BitmapData,
									clickState0Callback: Function,
									clickState1Callback: Function,
									biHint: BiHint = null )
		{
			addChildAt( new Bitmap( bmpState1Inactive ), _modeIndexState1Inactive );
			addChildAt( new Bitmap( bmpState1Active ), _modeIndexState1Active );	
			addChildAt( new Bitmap( bmpState0Inactive ), _modeIndexState0Inactive );
			addChildAt( new Bitmap( bmpState0Active ), _modeIndexState0Active );

			_clickState0Callback = clickState0Callback;
			_clickState1Callback = clickState1Callback;

			_curModeIndex = 3;
			_prevModeIndex = 3;

			useHandCursor = true;
			buttonMode = true;

			addEventListener( MouseEvent.MOUSE_OVER, _mouseOver );
			addEventListener( MouseEvent.MOUSE_OUT, _mouseOut );
			addEventListener( MouseEvent.CLICK, _click );

			_biHint = biHint;
		}

		private function _update()
		{
			swapChildrenAt( _curModeIndex, _prevModeIndex );

			_prevModeIndex = _curModeIndex;	
		}

		private function _setBiHintState( state: int )
		{
			if( _biHint == null ) return;

			_biHint.setState( state );
		}

		private function _showBiHint()
		{
			if( _biHint == null ) return;

			_biHint.show();
		}

		private function _hideBiHint()
		{
			if( _biHint == null ) return;

			_biHint.hide();	
		}

		private function _mouseOver( e: MouseEvent )
		{
			switch( _curModeIndex )
			{
			case _modeIndexState1Inactive:
				
				_curModeIndex = _modeIndexState1Active;

				_setBiHintState( 1 );
				
				break;
			case _modeIndexState0Inactive:

				_curModeIndex = _modeIndexState0Active;

				_setBiHintState( 0 );

				break;
			default: 
				;
			}

			_update();


			_showBiHint();
		}

		private function _mouseOut( e: MouseEvent )
		{
			switch( _curModeIndex )
			{
			case _modeIndexState1Active:
				
				_curModeIndex = _modeIndexState1Inactive;
				
				break;
			case _modeIndexState0Active:

				_curModeIndex = _modeIndexState0Inactive;

				break;
			default: 
				;
			}

			_update();	

			_hideBiHint();
		}

		private function _click( e: MouseEvent )
		{
			if( _curModeIndex == _modeIndexState0Active || _curModeIndex == _modeIndexState0Inactive )
			{
				_clickState0Callback();
				_curModeIndex = _modeIndexState1Active;
			}
			else
			{
				_clickState1Callback();
				_curModeIndex = _modeIndexState0Active;
			}

			_update();

			_biHint.hide();	
		}

		public function setState( numState: int )
		{
			if( numState == 0 )
				_curModeIndex = _modeIndexState0Active;
			else
				_curModeIndex = _modeIndexState1Active;				

		   	_update();
		}
	}
}