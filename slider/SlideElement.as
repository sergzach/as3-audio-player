
package slider
{
	
	import flash.display.Sprite;

    class SlideElement extends Sprite
    {

   		protected var _position: Number;

   		protected var _startX: Number

   		protected var _y: Number;
   		protected var _areaWidth: Number;
   		protected var _width: Number;
   		protected var _height: Number;

   		protected var _permanentColor = 0x505050;
   		protected var _color = 0xA8A8A8;

   		protected var _bkColor;
    
        public function SlideElement( startX: Number, y: Number, areaWidth: Number, height: Number, width: Number = 0, bkColor: Number = 0xFFFFFF ) 
        {

        	_startX = startX;
			_y = y;
			_areaWidth = areaWidth;

			_width = width;
			_height = height;

			_position = 0;

			_bkColor = bkColor;
        }

        public virtual function updatePosition( position: Number )
        {
        	_draw();
        }

        public function draw()
        {
        	_draw();
        }

        public function getPosition(): Number
        {
        	return _position;
        }

        protected virtual function _draw(): void
        {
       		graphics.clear();
        }
    }
}