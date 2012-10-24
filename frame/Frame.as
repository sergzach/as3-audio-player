
package frame
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.JointStyle;

	public class Frame extends Sprite
	{						
		private var _color: int;
		private var _bkColor: int;
		private var _cornerWidthHeight: int;

		private var _width: int;
		private var _height: int;

		private function _draw()
		{
			var inner: Shape = new Shape();

			inner.graphics.lineStyle( 1, _bkColor );
			inner.graphics.beginFill( _bkColor );
			inner.graphics.drawRoundRect( 0, 0, _width - 1, _height - 1, _cornerWidthHeight, _cornerWidthHeight );
			inner.graphics.endFill();

			inner.graphics.lineStyle( 1, _color, 1, true, "normal", null, JointStyle.ROUND );
			inner.graphics.drawRoundRect( 0, 0, _width - 1, _height - 1, _cornerWidthHeight, _cornerWidthHeight );
			
			addChild( inner );
		}

		public function Frame(	width: int,
								height: int,
								cornerWidthHeight: int,
								color: int,
								bkColor: int )
		{							
			_color = color;
			_bkColor = bkColor;
			_cornerWidthHeight = cornerWidthHeight;

			_width = width;
			_height = height;

			_draw();
		}
	}
}