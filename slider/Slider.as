
package slider
{
    import flash.display.Sprite;

    import flash.events.MouseEvent;

    import slider.SlideSlider;
    import slider.SlideLine;

   	import mouseInfo.MouseInfo;

    public class Slider extends Sprite
    {
   		private var _slideSlider: SlideSlider;
   		private var _slideLine: SlideLine;

   		private var _width: Number;
   		private var _height: Number;

   		private static var _slideLineHeight = 0.25;
		private static var _slideSliderWidth = 7;
		private static var _fullHeight = 7; 

		private static var _bkColor = 0xFFFFFF;

		private var _storedWidth: Number;
		private var _storedHeight: Number;

    	private var _mouseInfo: MouseInfo;

//    	private var _isSlideLinePermanent: Boolean;
    
        public function Slider( x_: Number, y_: Number, width: Number, height: Number, positionUpdatedCallback: Function, isSlideLinePermanent: Boolean, positionCallbackWhenMove: Boolean = true, outputDebug: Boolean = false ) 
        {
        	var baseY = height / 2;
			
			x = x_;
			y = y_;
			
			_slideLine = new SlideLine( x, baseY, width, _slideLineHeight, _fullHeight, _mouseClick, _bkColor, isSlideLinePermanent );
			_slideSlider = new SlideSlider( x, baseY, width, _fullHeight, _slideSliderWidth, _bkColor, positionUpdatedCallback, positionCallbackWhenMove, outputDebug );

			if( isSlideLinePermanent ) _slideSlider.setMaxPosition( 1 );

			addChild( _slideLine );
			addChild( _slideSlider );

			_slideLine.draw();
			_slideSlider.draw();

			_storedWidth = width;
			_storedHeight = height;

			_mouseInfo = new MouseInfo();

			addEventListener( MouseEvent.MOUSE_DOWN, _mouseDown );

//			_isSlideLinePermanent = isSlideLinePermanent;
        }

        public function _mouseClick( e: MouseEvent )
        {
        	/*if( _mouseInfo.canMove() )
        	{
				_slideSlider.setPositionByCoord( e.stageX, _storedWidth );
			}*/
        }

        public function mouseMove( e: MouseEvent )
        {
			if( _mouseInfo.isCaptured() )
			{	
				_slideSlider.mouseMove( e.stageX, _storedWidth );

				_mouseInfo.setIsMoving( true );

			}
        }

        private function _mouseDown( e: MouseEvent )
        {
	        	_mouseInfo.down();
        }

        public function mouseUp( e: MouseEvent )
        {
        	if( _mouseInfo.isCaptured() )
        	{
				_mouseInfo.up();        	
				_slideSlider.mouseUp( e.stageX, _storedWidth );
				_mouseInfo.setIsMoving( false );
			}
        }

        public function updateSliderPosition( position )
        {
        	if( !_mouseInfo.isMoving() )
        	{
	        	_slideSlider.updatePosition( position );
	        }
        }
        
        public function updateLinePosition( position )
        {
        	_slideLine.updatePosition( position );

        	_slideSlider.setMaxPosition( _slideLine.getPosition() );
        }
    }
}
