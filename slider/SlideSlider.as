
package slider
{
	import flash.events.MouseEvent;

	import slider.SlideElement;

	import mouseActionsAndPlayState.MouseActionsAndPlayState;

    public class SlideSlider extends SlideElement
    {    
    	private var _outputDebug: Boolean;

    	private var _positionUpdatedCallback: Function;

    	private var _positionCallbackWhenMove: Boolean;

    	private var _maxPosition: Number;

        public function SlideSlider( startX: Number, y: Number, areaWidth: Number, height: Number, width: Number, bkColor: Number, positionUpdatedCallback: Function, positionCallbackWhenMove: Boolean = true, outputDebug: Boolean = false ) 
        {
			super( startX, y, areaWidth, height, width, bkColor );

			useHandCursor = true;
			buttonMode = true;

			_outputDebug = outputDebug;

			_positionUpdatedCallback = positionUpdatedCallback;

			_positionCallbackWhenMove = positionCallbackWhenMove;

			_maxPosition = 0;
        }

        private function getPixelPosition( mouseX )
        {
        	return mouseX - _startX;
        }

        public function setPositionByCoord( mouseX: Number, width: Number )
        {
			var position = getPixelPosition( mouseX ) / width;
				
			updatePosition( position );
        }

        public function mouseMove( mouseX, width )
        {
			setPositionByCoord( mouseX, width );	

			if( _positionCallbackWhenMove )
			{
	        	_positionUpdatedCallback( _position );
	        }
        }

        public function mouseUp( mouseX, width )
        {
			setPositionByCoord( mouseX, width );	

        	_positionUpdatedCallback( _position );
        }

        public function setMaxPosition( maxPosition: Number )
        {
        	_maxPosition = maxPosition;
        }

        public override function updatePosition( position: Number )
        {
        	if( position > _maxPosition ) _position = _maxPosition;
        	else
        	if( position < 0 ) _position = 0;
        	else
        		_position = position;

        	super.updatePosition( position );
        }

        protected override function _draw(): void
        {
			var left = _areaWidth * _position;
			var bottom = _y;
			var width = _width;
			var height = _height;

			super._draw();

            with( graphics )
            {
            	beginFill( _color );    	

            	drawRect( left, bottom, width, height );

            	endFill();
            }
        }
    }
}