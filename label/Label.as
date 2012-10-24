
package label
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Label extends TextField
	{
		private var _text: Array;
		private static var _textColor: uint = 0x000000;

		private var textFormat: TextFormat;

		public function Label( x_: Number, y_: Number, fontSize: int, defaultText: String = "" )
		{

			border = false;
			selectable = false;

			autoSize = TextFieldAutoSize.LEFT;

			x = x_;
			y = y_;

			textColor = _textColor;

			textFormat = new TextFormat();


			textFormat.font = "Arial";
			textFormat.size = fontSize;

			defaultTextFormat = textFormat;

			text = defaultText;
		}

		public function setText( text_: String )
		{
			text = text_;
		}		
	}
}