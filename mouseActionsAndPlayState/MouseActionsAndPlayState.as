package mouseActionsAndPlayState
{
	public class MouseActionsAndPlayState
	{
		private var _isMouseMove: Boolean;
		private var _isPlaying: Boolean;

		public function MouseActionsAndPlayState( isMouseMove: Boolean = false, isPlaying: false )
		{
			_isMouseMove = isMouseMove;

			_isPlaying = isPlaying;
		}

		public function setIsPlaying( isPlaying: Boolean )
		{
			_isPlaying = isPlaying;
		}

		public function setIsMouseMove( isMouseMove: Boolean )
		{
			_isMouseMove = isMouseMove;
		}

		public function doDropSliderNow(): Boolean
		{
			return !_isMouseMove && _isPlaying;
		}
	}
}