
package utils
{
	public class TimeLabel
	{

		private static function _fillZero( s: String )
		{
			if( s.length < 2 )
				s = "0" + s;

			return s;
		}

		private static function _getMinsSecs( secs: int )
		{
			var minutes:int = int( secs / 60 );
			var seconds:int = secs - minutes * 60;

			var strMins = _fillZero( String( minutes ) );
			var strSecs = _fillZero( String( seconds ) );

			return 	{ 'minutes': strMins, 'seconds': strSecs };
		}

		private static var _minsSecsSplitter = ":";
		private static var _curTotalTimeSplitter = " / ";

		public static function get( secs: int, totalSecs: int )
		{
			var curTime = _getMinsSecs( secs );
			var totalTime = _getMinsSecs( totalSecs );

			var curMinutes = curTime[ 'minutes' ];
			var curSeconds = curTime[ 'seconds' ];
			var totalMinutes = totalTime[ 'minutes' ];
			var totalSeconds = totalTime[ 'seconds' ];

			return	curMinutes + _minsSecsSplitter + curSeconds + 
					_curTotalTimeSplitter + 
					totalMinutes + _minsSecsSplitter + totalSeconds;
		}
	}
}