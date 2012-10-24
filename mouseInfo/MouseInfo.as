
package mouseInfo
{
	
    public class MouseInfo
    {
    
    	private var _isDown: Boolean;
    	private var _isMoving: Boolean;

   	    import flash.events.MouseEvent;

        public function MouseInfo(  ) 
        {
			_isDown = false;
			_isMoving = false;
        }

	   	public function down()
	   	{
			_isDown = true;
	   	}

	   	public function up()
	   	{
			_isDown = false;
	   	}

		public function isCaptured()
		{
			return _isDown;	
		}

		public function setIsMoving( isMoving: Boolean )
		{
			_isMoving = isMoving;
		}

		public function isMoving()
		{
			return _isMoving;
		}
    }
}
