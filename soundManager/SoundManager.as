﻿                                 
package soundManager
{

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;	

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;

	import flash.net.URLRequest;

	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class SoundManager
	{
		namespace positionControl;
		namespace time;
		namespace volumeControl;
		namespace coeff;
		namespace state;
		namespace callbackFunc;

		time static var _startBuffer = 4000;
		time static var _stopBuffer = 2000;


		time static var _playAvailableTest = 1000;

		private var _sound: Sound;
		private var _soundURLRequest: URLRequest;
		private var _soundChannel: SoundChannel;

		positionControl var _position: Number;
		state var _isPlaying: Boolean;

		time var _progressUpdate: Number;

		private var _progressTimer: Timer;
		private var _playAvailableTestTimer: Timer;

		callbackFunc var _onPlayProgress: Function;
		callbackFunc var _onLoadProgress: Function;
		callbackFunc var _onComplete: Function;

		volumeControl var _volume: Number;

		coeff var _loaded: Number;

		state var _isPlayMode: Boolean;
		state var _isLoadingStarted: Boolean;

		public function SoundManager(	onLoadProgressCallback: Function, 
										onPlayProgressCallback: Function, 
										onCompleteCallback: Function, 
										onIOErrorCallback: Function, 
										defaultVolume: Number, 
										progressUpdateTime: Number = 50 )
		{
			_sound = new Sound();			

			_sound.addEventListener( ProgressEvent.PROGRESS, _onLoadProgress );
			_sound.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorCallback );

			positionControl::_position = 0;

			time::_progressUpdate = progressUpdateTime;
			time::_fullTime = 0;

			_progressTimer = new Timer( time::_progressUpdate );
			_progressTimer.addEventListener( "timer", _onPlayProgress );

			_playAvailableTestTimer = new Timer( time::_playAvailableTest );
			_playAvailableTestTimer.addEventListener( "timer", _takePlayAvailableTest );

			callbackFunc::_onPlayProgress = onPlayProgressCallback;
			callbackFunc::_onLoadProgress = onLoadProgressCallback;
			callbackFunc::_onComplete = onCompleteCallback;

			volumeControl::_volume = defaultVolume;

			state::_isPlayMode = false;

			state::_isLoadingStarted = false;
		}

		private function _onLoadProgress( e: ProgressEvent )
        {
			coeff::_loaded = e.bytesLoaded / e.bytesTotal;

			callbackFunc::_onLoadProgress( coeff::_getLoaded() );
        }

        public function getTime()
        {
        	return time::_getCurrent();
        }

        public function getFullTime()
        {
        	return time::_getFull();
        }

		private function _onPlayProgress( e: TimerEvent )
		{
			positionControl::_read();

			if( !_canPlay() )
			{
				// trace( "stopped..." );

				_stopOrPause();	
				_startPlayAvailableTest();
			}

			callbackFunc::_onPlayProgress( positionControl::_getCurrent() );
		}

		public function isLoadingStarted()
		{
			return state::_isLoadingStarted;
		}

		public function load( resourceURL: String )
		{
			_soundURLRequest = new URLRequest( resourceURL );

			_sound.load( _soundURLRequest );

			state::_isLoadingStarted = true;
		}

		coeff function _getLoaded()
        {
        	return coeff::_loaded;
        }

		time function getLoadedSound()
		{
			return _sound.length;
		}

		time var _fullTime: int;

		time function _getFull()
		{

		    if( time::_fullTime == 0 )
			{		    	
				time::_fullTime = int( _sound.length / coeff::_getLoaded() );
			}

			return time::_fullTime;
		}

		time function _getLoaded()
		{
			return _sound.length;
		}
		
		time function _getCurrent()
		{
		    return positionControl::_position * time::_getFull();
		}

		positionControl function _getCurrent()
		{
			if( _soundChannel != null )
			{
				var currentPosition = _soundChannel.position / time::_getFull();
				return currentPosition;
			}

			return 0;
		}

		positionControl function _read()
		{
			positionControl::_position = positionControl::_getCurrent();
		}

		positionControl function _reset()
		{
			positionControl::_position = 0;			
		}

		positionControl function set( position )
		{
			positionControl::_position = position;

			if( state::_isPlayMode ) 
			{
				_stopOrPause();
				play();
			}
		}

		public function setPosition( position )
		{
			positionControl::set( position );
		}

		volumeControl function set( volume: Number )
		{
			var soundTransform = _soundChannel.soundTransform;
			soundTransform.volume = volume;
			_soundChannel.soundTransform = soundTransform;

			volumeControl::_volume = volume;
		}

		volumeControl function setCurrent()
		{
			volumeControl::set( volumeControl::_volume );
		}

		public function setVolume( volume )
		{
			volumeControl::set( volume );
		}

		private function _canPlay()
		{
			return ( time::_getLoaded() > time::_getCurrent() + time::_startBuffer || int( coeff::_getLoaded() ) == 1 );
		}

		public function isWaitingProgress()
		{
			return _playAvailableTestTimer.running;
		}

		private function _startPlayAvailableTest()
		{
			if( !_playAvailableTestTimer.running )
			{
				// trace( "_playAvailableTestTimer.start();" );
								
				_playAvailableTestTimer.start();
			}
		}

		private function _stopPlayAvailableTest()
		{
			if( _playAvailableTestTimer.running )
			{
				// trace( "_playAvailableTestTimer.stop();" );				

				_playAvailableTestTimer.stop();
			}
		}

		private function _takePlayAvailableTest( e: TimerEvent )
		{
			play();
		}

		private function _assignSoundChannel()
		{

			trace( "in _assignSoundChannel()" );

			_soundChannel = _sound.play( time::_getCurrent() );	

			_soundChannel.addEventListener( Event.SOUND_COMPLETE, callbackFunc::_onComplete );
		}

		public function play()
		{
		    if( _canPlay() )
			{			
				_assignSoundChannel();

				volumeControl::setCurrent();

				_progressTimer.start();	

				_stopPlayAvailableTest();
			}
			else
			{
				_startPlayAvailableTest();
			}

			state::_isPlayMode = true;
		}

		private function _stopOrPause()
		{
			if( _soundChannel != null )
			{
				_soundChannel.stop();			
			}
			else
			{
				_stopPlayAvailableTest();
			}
			
			_progressTimer.stop();
		}

		public function pause()
		{
			positionControl::_read();
			_stopOrPause();

			state::_isPlayMode = false;
		}

		public function stop()
		{
			positionControl::_reset();
			_stopOrPause();

			state::_isPlayMode = false;
		}
	}
}