
package slider
{
	import slider.SlideElement;
	import flash.events.MouseEvent;

    public class SlideLine extends SlideElement
    {    

    	private var _isPermanent: Boolean;

    	private var _fullHeight: Number;

        public function SlideLine( startX: Number, y: Number, areaWidth: Number, height: Number, fullHeight: Number, mouseClickCallback: Function, bkColor = 0xFFFFFF, isPermanent: Boolean = false ) 
        {

        	_isPermanent = isPermanent;

			super( startX, y, areaWidth, height, 0, bkColor );

			_fullHeight = fullHeight;

			useHandCursor = true;
			buttonMode = true;

			addEventListener( MouseEvent.MOUSE_UP, mouseClickCallback );

        }

        public override function updatePosition( position: Number )
        {
        	if( position > 1 ) _position = 1;
        	else
        	if( position < 0 ) _position = 0;
        	else
        		_position = position;

        	super.updatePosition( position );
        }

        protected override function _draw(): void
        {
			var left = 0;
			var bottom = _y;
			var width;
			var height = _height;

			if( _isPermanent )
				width = _areaWidth;
		   	else
		   		width = _areaWidth * _position;

			super._draw();

			var color: Number;

			if( _isPermanent )
				color = _permanentColor;
			else
				color = _color;

            with( graphics )
            {

            	beginFill( _bkColor );
            	drawRect( left, bottom, width, _fullHeight );
            	endFill();

            	beginFill( color );
            	drawRect( left, bottom + _fullHeight, width, height );
            	endFill();
            }
        }
    }
}