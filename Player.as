package
{
    import flash.display.MovieClip;
    import slider.Slider;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import button.BiButton;

    import label.BiHint;
    import label.Label;

    import soundManager.SoundManager;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;

	import flash.display.Bitmap;

	import utils.*;

	import flash.display.LoaderInfo;
	import exchanger.Exchanger;

	import flash.display.StageAlign;
    import flash.display.StageScaleMode;

	import frame.Frame;

    public class Player extends MovieClip
    {
		static private var _isDebugMode = true;

        private var _positionSlider: Slider;
        private var _volumeSlider: Slider;

        private var _soundManager: SoundManager;

		private var _sliderLineHeight = 5;

		private var _titleLabel: Label;
		private var _playProgressLabel: Label;
		private var _volumeLabel: Label;

		private var _URL: String;

		private var _exchanger: Exchanger;

		private static var STR_TRUE: String = "true";
		private static var STR_FALSE: String = "false";

		private var _frame: Frame;

		static private var _exchangerParamsNames =
		{
			URL: "url",
			title: "title",
			disabled: "disabled"
		}

		

		private var _coords = 
		{

			changeAllY: function( dY: int, context: Object = null )
			{
				var context_ = this;
				if( context != null )
				{
					context_ = context;
				}					

				if( typeof context_ == "object" )
				{

					if( context_[ 'y' ] != null )
					{
						context_[ 'y' ] += dY;
					}
	            	else
					for( var iterObj in context_ )
					{
						this.changeAllY( dY, context_[ iterObj ] );
					}	
				}

			},

			updateByWidth: function( width: int )
			{
				this.sliders.position.width = width - 88;
				this.sliders.volume.x = width - 113;
				this.labels.volume.x = width - 186;
			},

			sliders:
			{

				

				position:
				{	
					x: 75,
					y: 48
				},
				volume:
				{
					width: 100,
					y: 70
				}
		  	},

		  	playPauseHint:
		  	{
		  		x: 75,
		  		y: 60
		  	},
		  	playPauseButton:
		  	{
		  		x: 10,
		  		y: 23
		  	},

		  	labels:
		  	{

		  		title:
		  		{
		  		  x: 75,
		  		  y: 20
		  		},

		  		playProgress:
		  		{
		  			x: 75,
		  			y: 65
		  		},
		  		volume:
		  		{
		  			y: 65
		  		},

		  		disable:
		  		{
		  			x: 20,
		  			y: 40
		  		}
		  	}
		};

		static private var _colors =
		{
			frame:
			{
				color: 0x3A90D3,
				bkColor: 0xFFFFFF
			}
		};

		static private var _sizes =
		{
			frame:
			{
				ellipseWidthHeight: 8
			}
		};

		static private var _fontSizes = 
		{
			playProgress: 12,
			volume: 10,
			title: 12,
			disable: 18
		}

	  	private static var _texts =
	  	{
			play: "Play",
			pause: "Pause",
			getLoading: function( percents: Number )
			{
				return "Loaded: " + String( percents ) + "%";
			},
			volume: "Volume",

			disable: "This record is available in only payed mode."

		}

		private var _playPauseButton: BiButton;

		private static var _defaultVolume = 0.5;

		private var _scaleMode = StageScaleMode.NO_SCALE;
		private var _align = StageAlign.TOP_LEFT;
        
        public function Player() {
			// here is a main constructor of flash movie
			
			// class of scroll

			stage.scaleMode = _scaleMode;
			stage.align = _align;

			_coords.updateByWidth( stage.stageWidth );

			_exchanger = new Exchanger( this.root.loaderInfo );

			var titleLabelText: String;
			var URL: String;
			var disabled: String;

			if( _isDebugMode )
			{
				titleLabelText = "Debug mode";
				URL = "http://mp3.classic-music.ru/music/chopin/ballada2.mp3";
				disabled = "false";
			}
			else
			{
				titleLabelText = _exchanger.getParameterByName( _exchangerParamsNames.title );
				URL = _exchanger.getParameterByName( _exchangerParamsNames.URL );
				disabled = _exchanger.getParameterByName( _exchangerParamsNames.disabled );
			}


			addChild( new Frame( stage.stageWidth, stage.stageHeight, _sizes.frame.ellipseWidthHeight, _colors.frame.color, _colors.frame.bkColor ) );
			_coords.changeAllY( -7 );



				//addChild( new Bitmap( new FrameBitmap( 0, 0 ) ) );

			if( disabled == STR_TRUE )
			{
				_disable();
				return;
			}

			_positionSlider = new Slider(	_coords.sliders.position.x,
											_coords.sliders.position.y,
											_coords.sliders.position.width, 
											_sliderLineHeight, 
											_positionSliderUpdate,
											false,
											false,
											false ); 

			addChild( _positionSlider );

			_volumeSlider = new Slider(	_coords.sliders.volume.x,
										_coords.sliders.volume.y,
										_coords.sliders.volume.width, 
										_sliderLineHeight, 
										_volumeSliderUpdate,
										true,
										true,
										true );

			_volumeSlider.updateSliderPosition( _defaultVolume );

			addChild( _volumeSlider );

			stage.addEventListener( MouseEvent.MOUSE_MOVE, _mouseMove );			
			stage.addEventListener( MouseEvent.MOUSE_UP, _mouseUp );			

			var biHint: BiHint = new BiHint( _texts.play, _texts.pause );

			biHint.x = _coords.playPauseHint.x;
			biHint.y = _coords.playPauseHint.y;

			_playPauseButton = new BiButton(	new PlayInactiveBitmap( 0, 0 ), 
												new PlayActiveBitmap( 0, 0 ),
												new PauseInactiveBitmap( 0, 0 ),
												new PauseActiveBitmap( 0, 0 ), 
												onPlay,
												onPause,
												biHint );

			_playPauseButton.x = _coords.playPauseButton.x;
			_playPauseButton.y = _coords.playPauseButton.y;

			addChild( _playPauseButton );

			_titleLabel = new Label( _coords.labels.title.x, _coords.labels.title.y, _fontSizes.title );
			addChild( _titleLabel );

			_playProgressLabel = new Label( _coords.labels.playProgress.x, _coords.labels.playProgress.y, _fontSizes.playProgress );
			addChild( _playProgressLabel );

			_volumeLabel = new Label( _coords.labels.volume.x, _coords.labels.volume.y, _fontSizes.volume, _texts.volume );
			addChild( _volumeLabel );

			useHandCursor = true;

			_soundManager = new SoundManager( _onLoadProgress, _onPlayProgress, _onComplete, _onIOError, _defaultVolume );

			addChild( biHint );

			_titleLabel.setText( titleLabelText );
			_setURL( URL );

        }

        private function _disable()
        {
			var disableLabel = new Label( _coords.labels.disable.x, _coords.labels.disable.y, _fontSizes.disable, _texts.disable );        	

			addChild( disableLabel );
        }

		private function _setTitle( text: String )
		{
			_titleLabel.setText( text );			
		}

		private function _setURL( URL: String )
		{
			this._URL = URL;
		}

        private function _onLoadProgress( position: Number )
        {
			_positionSlider.updateLinePosition( position );        	

			if( _soundManager.isWaitingProgress() )
				_playProgressLabel.setText( _texts.getLoading( int( position * 100 ) ) );
        }

        private function _updateSliderLabelsPosition( position: Number, time: Number, totalTime: Number )
        {
			_positionSlider.updateSliderPosition( position );

			var curSecs = Math.floor( time / 1000 );

			var totalSecs = Math.floor( totalTime / 1000 );

			if( !_soundManager.isWaitingProgress() )
				_playProgressLabel.setText( TimeLabel.get( curSecs, totalSecs ) );
        }

        private function _onPlayProgress( position: Number )
        {
//			trace( "_onPlayProgress" );

			_updateSliderLabelsPosition( position, _soundManager.getTime(), _soundManager.getFullTime() );

        }

        private function _onComplete( e: Event )
        {
			trace( "onComplete" );
			_soundManager.setPosition( 0 );			
			_soundManager.stop();

			_updateSliderLabelsPosition( 0, _soundManager.getTime(), _soundManager.getFullTime() );

			_playPauseButton.setState( 0 );
        }

        private function _onIOError( e: Event )
        {
//        	trace( "onIOError" );
        }

        private function _mouseMove( e: MouseEvent )
        {
        	_positionSlider.mouseMove( e );
        	_volumeSlider.mouseMove( e );
        }

        private function _mouseUp( e: MouseEvent )
        {
			_positionSlider.mouseUp ( e );
			_volumeSlider.mouseUp( e );
        }

        private function _positionSliderUpdate( position: Number )
        {
			_soundManager.setPosition( position );
			_updateSliderLabelsPosition( position, _soundManager.getTime(), _soundManager.getFullTime() );
        }

        private function _volumeSliderUpdate( position: Number )
        {
        	_soundManager.setVolume( position );
        }

		public function onPlay()
		{
			if( !_soundManager.isLoadingStarted() )
			{
				_soundManager.load( this._URL );
		   	}
			
			_soundManager.play();
		}

		public function onPause()
		{
			_soundManager.pause();
		}
    }
}