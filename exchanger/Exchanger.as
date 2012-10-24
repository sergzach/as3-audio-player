
package exchanger
{
	import flash.display.LoaderInfo;

// must be instantiated?

	public class Exchanger
	{
		private var _parameters: Object;	

		public function Exchanger( loaderInfo: LoaderInfo )
		{
			_parameters = LoaderInfo( loaderInfo ).parameters;
		}

		public function getParameterByName( name: String )
		{
			return String( _parameters[ name ] );
		}
	}
}