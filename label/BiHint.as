
package label
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class BiHint extends TextField
	{
		private var _texts: Array;
		private static var _backgroundColor = 0xFFFFFF;

		public function BiHint( textState0: String, textState1: String )
		{

			text = text;
			border = true;
			selectable = false;

			background = true;
			backgroundColor = _backgroundColor;

			autoSize = TextFieldAutoSize.LEFT;

			_texts = new Array( textState0, textState1 );

			text = textState0;

			visible = false;
		}

		public function show()
		{
		    visible = true;
		}

		public function hide()
		{
			visible = false;
		}

		public function setState( nState: int )
		{
			text = _texts[ nState ];
		}

		
	}
}