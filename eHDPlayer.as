package
{
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.ImageElement;
	import org.osmf.events.MediaElementChangeEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutMetadata;
	import org.osmf.layout.LayoutMode;
	import org.osmf.layout.VerticalAlign;
	import org.osmf.logging.Log;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.player.chrome.ChromeProvider;
	import org.osmf.player.chrome.assets.AssetsManager;
	import org.osmf.player.chrome.events.WidgetEvent;
	import org.osmf.player.chrome.widgets.BufferingOverlay;
	import org.osmf.player.chrome.widgets.PlayButtonOverlay;
	import org.osmf.player.configuration.ConfigurationLoader;
	import org.osmf.player.configuration.ControlBarMode;
	import org.osmf.player.configuration.PlayerConfiguration;
	import org.osmf.player.configuration.SkinParser;
	import org.osmf.player.configuration.XMLFileLoader;
	import org.osmf.player.debug.DebugStrobeMediaPlayer;
	import org.osmf.player.debug.LogHandler;
	import org.osmf.player.debug.StrobeLogger;
	import org.osmf.player.debug.StrobeLoggerFactory;
	import org.osmf.player.elements.AlertDialogElement;
	import org.osmf.player.elements.AuthenticationDialogElement;
	import org.osmf.player.elements.ControlBarElement;
	import org.osmf.player.errors.StrobePlayerErrorCodes;
	import org.osmf.player.media.StrobeMediaFactory;
	import org.osmf.player.media.StrobeMediaPlayer;
	import org.osmf.player.plugins.PluginLoader;
	import org.osmf.player.utils.StrobePlayerStrings;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SeekTrait;
	
	public class eHDPlayer extends Sprite
	{
		
		private static const ALWAYS_ON_TOP:int = 9999;
		
		private static const ON_TOP:int = 9998;
		
		private static const POSITION_OVER_OFFSET:int = 20;
		
		private static const MAX_OVER_WIDTH:int = 400;
		
		private static const POSTER_INDEX:int = 2;
		
		private static const PLAY_OVERLAY_INDEX:int = 3;
		
		private static const BUFFERING_OVERLAY_INDEX:int = 4;
		
		private static const OVERLAY_FADE_STEPS:int = 6;
		
		private static const EXTERNAL_INTERFACE_ERROR_CALL:String = "function(playerId, code, message, detail)" + "{" + "\tif (onMediaPlaybackError != null)" + "\t\tonMediaPlaybackError(playerId, code, message, detail);" + "}";
		
		
		public var player:StrobeMediaPlayer;
		
		public var factory:MediaFactory;
		
		private var _isChangeQulity:Boolean = false;
		
		private var _lastPlayTime:Number = 0;
		
		private var _aryMediaSrc:Array;
		
		private var changeQulityInfo:TextField;
		
		private var _arySplit:Array;
		
		private var _bSetStudyRec:Boolean = false;
		
		private var checkuserinfo:TextField = null;
		
		private var format:TextFormat;
		
		private var mtimer:Timer;
		
		private var playertimer:Timer;
		
		private var changeQhtimer:Timer;
		
		private var timecount:uint = 0;
		
		private var scrollcount:uint = 0;
		
		private var _stage:Stage;
		
		private var mainContainer:MediaContainer;
		
		private var mediaContainer:MediaContainer;
		
		private var controlBarContainer:MediaContainer;
		
		private var loginWindowContainer:MediaContainer;
		
		private var _media:MediaElement;
		
		private var configuration:PlayerConfiguration;
		
		private var controlBar:ControlBarElement;
		
		private var alert:AlertDialogElement;
		
		private var loginWindow:AuthenticationDialogElement;
		
		private var posterImage:ImageElement;
		
		private var playOverlay:PlayButtonOverlay;
		
		private var bufferingOverlay:BufferingOverlay;
		
		private var controlBarWidth:Number;
		
		private var controlBarHeight:Number;
		
		protected var logger:StrobeLogger;
		
		public function eHDPlayer()
		{
			ExternalInterface.call("msg","eHDPlayer-version-2.0");
			this.format = new TextFormat();
			this.mtimer = new Timer(1000);
			this.playertimer = new Timer(1000);
			this.changeQhtimer = new Timer(5000);
			this.logger = Log.getLogger("eHDPlayer") as StrobeLogger;
			super();
			System.useCodePage = true;
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			Log.loggerFactory = new StrobeLoggerFactory(new LogHandler());
			this.logger = Log.getLogger("eHDPlayer") as StrobeLogger;
		}
		
		public function initialize(param1:Object, param2:Stage) : void
		{
			var assetManager:AssetsManager = null;
			var onConfigurationReady:Function = null;
			var onSkinLoaderComplete:Function = null;
			var showVerInfo:Function = null;
			var onSkinLoaderFailure:Function = null;
			var onChromeProviderComplete:Function = null;
			var parameters:Object = param1;
			var stage:Stage = param2;
			onConfigurationReady = function(param1:Event):void
			{
				ExternalInterface.call("msg","onConfigurationReady");
				var _loc2_:SharedObject = null;
				var _loc3_:String = null;
				var _loc4_:uint = 0;
				var _loc5_:MediaResourceBase = null;
				var _loc6_:XMLFileLoader = null;
				logger.trackObject("PlayerConfiguration",configuration);
				_loc4_ = 0;
				for each(_loc5_ in configuration.pluginConfigurations)
				{
					logger.trackObject("PluginResource" + _loc4_++,_loc5_);
				}
				_loc2_ = SharedObject.getLocal("randomvalue");
				_loc3_ = _loc2_.data.skinpath;
				if(_loc3_ != null && _loc3_ != "" && configuration.skin != "")
				{
				}
				_loc2_.data.skinpath = configuration.skin;
				_loc2_.flush();
				if(configuration.skin != null && configuration.skin != "")
				{
					ExternalInterface.call("msg","configuration.skin");
					_loc6_ = new XMLFileLoader();
					_loc6_.addEventListener(IOErrorEvent.IO_ERROR,onSkinLoaderFailure);
					_loc6_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSkinLoaderFailure);
					_loc6_.addEventListener(Event.COMPLETE,onSkinLoaderComplete);
					_loc6_.load(configuration.skin);
				}
				else
				{
					onSkinLoaderComplete();
				}
			};
			onSkinLoaderComplete = function(param1:Event = null):void
			{
				ExternalInterface.call("msg","onSkinLoaderComplete");
				var _loc3_:XMLFileLoader = null;
				var _loc4_:SkinParser = null;
				if(param1 != null)
				{
					_loc3_ = param1.target as XMLFileLoader;
					_loc4_ = new SkinParser();
					_loc4_.parse(_loc3_.xml,assetManager);
				}
				var _loc2_:ChromeProvider = ChromeProvider.getInstance();
				
				if(_loc2_.loaded == false && _loc2_.loading == false)
				{
					_loc2_.addEventListener(Event.COMPLETE,onChromeProviderComplete);
					_loc2_.load(assetManager);
				}
				else
				{
					onChromeProviderComplete();
				}
			};
			showVerInfo = function(param1:Event):void
			{
				var _loc2_:* = new URLRequest("http://www.7east.com");
				navigateToURL(_loc2_);
			};
			onSkinLoaderFailure = function(param1:Event):void
			{ 
				ExternalInterface.call("msg","onSkinLoaderFailure");
				trace("WARNING: failed to load skin file at " + configuration.skin);
				onSkinLoaderComplete();
			};
			onChromeProviderComplete = function(param1:Event = null):void
			{
				ExternalInterface.call("msg","onChromeProviderComplete");
				initializeControl();
				initializeView();
				addEventListener(MediaElementChangeEvent.MEDIA_URL_CHANGE,onMediaElementChangeEvent);
				var _loc2_:PluginLoader = new PluginLoader(configuration.pluginConfigurations,factory);
				_loc2_.addEventListener(Event.COMPLETE,loadMedia);
				ExternalInterface.call("msg","loadPlugins");
				_loc2_.loadPlugins();
			};
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.addCallback("PlaySeek",this.SeekNewPosition);
					ExternalInterface.addCallback("ModifyStudyRec",this.ModifyRec);
					ExternalInterface.addCallback("PlayMD",this.PlayMedia);
					ExternalInterface.addCallback("Stop",this.StopMedia);
					ExternalInterface.addCallback("Pause",this.PauseMedia);
					ExternalInterface.addCallback("SetVolume",this.OnSetVolume);
				}
				catch(_:Error)
				{
				}
			}
			if(loaderInfo != null && loaderInfo.hasOwnProperty("uncaughtErrorEvents"))
			{
				loaderInfo["uncaughtErrorEvents"].addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtError);
			}
			this._stage = stage;
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			var cmi_about:ContextMenuItem = new ContextMenuItem("7eHDPlayerbit Ver1.5.0");
			contextMenu.customItems.push(cmi_about);
			var cmi_about1:ContextMenuItem = new ContextMenuItem("Powered by 七易科技 2013");
			cmi_about1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,showVerInfo);
			contextMenu.customItems.push(cmi_about1);
			assetManager = new AssetsManager();
			this.configuration = new PlayerConfiguration();
			var configurationXMLLoader:XMLFileLoader = new XMLFileLoader();
			var configurationLoader:ConfigurationLoader = new ConfigurationLoader(configurationXMLLoader);
			configurationLoader.addEventListener(Event.COMPLETE,onConfigurationReady);
			configurationLoader.load(parameters,this.configuration);
			ExternalInterface.call("msg","init----end");
		}
		
		private function initializeControl() : void
		{
			ExternalInterface.call("msg","initializeControl");
			this.factory = new StrobeMediaFactory(this.configuration);
			this.player = new StrobeMediaPlayer();
			this.player = new DebugStrobeMediaPlayer();
			this.player.addEventListener(MediaErrorEvent.MEDIA_ERROR,this.onMediaError);
			this.player.autoPlay = this.configuration.autoPlay;
			this.player.loop = this.configuration.loop;
			this.player.autoSwitchQuality = this.configuration.autoSwitchQuality;
			this.player.videoRenderingMode = this.configuration.videoRenderingMode;
			this.player.highQualityThreshold = this.configuration.highQualityThreshold;
		}
		
		private function initializeView() : void
		{
			ExternalInterface.call("msg","initializeView");
			var _loc2_:String = null;
			this._stage.scaleMode = StageScaleMode.NO_SCALE;
			this._stage.align = StageAlign.TOP_LEFT;
			this._stage.addEventListener(Event.RESIZE,this.onStageResize);
			this.mainContainer = new MediaContainer();
			this.mainContainer.backgroundColor = this.configuration.backgroundColor;
			this.mainContainer.backgroundAlpha = 1;
			addChild(this.mainContainer);
			ExternalInterface.call("msg","addChild");
			this.mediaContainer = new MediaContainer();
			this.mediaContainer.clipChildren = true;
			this.mediaContainer.layoutMetadata.percentWidth = 100;
			this.mediaContainer.layoutMetadata.percentHeight = 100;
			this.controlBarContainer = new MediaContainer();
			this.controlBarContainer.layoutMetadata.percentWidth = 100;
			this.controlBarContainer.layoutMetadata.verticalAlign = VerticalAlign.TOP;
			this.controlBarContainer.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
			if(this.configuration.playButtonOverlay == true)
			{
				this.playOverlay = new PlayButtonOverlay();
				this.playOverlay.configure(<default/>,ChromeProvider.getInstance().assetManager);
				this.playOverlay.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
				this.playOverlay.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
				this.playOverlay.layoutMetadata.index = PLAY_OVERLAY_INDEX;
				this.playOverlay.fadeSteps = OVERLAY_FADE_STEPS;
				this.mediaContainer.layoutRenderer.addTarget(this.playOverlay);
			}
			if(this.configuration.bufferingOverlay == true)
			{
				this.bufferingOverlay = new BufferingOverlay();
				this.bufferingOverlay.configure(<default/>,ChromeProvider.getInstance().assetManager);
				this.bufferingOverlay.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
				this.bufferingOverlay.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
				this.bufferingOverlay.layoutMetadata.index = BUFFERING_OVERLAY_INDEX;
				this.bufferingOverlay.fadeSteps = OVERLAY_FADE_STEPS;
				this.mediaContainer.layoutRenderer.addTarget(this.bufferingOverlay);
			}
			this.alert = new AlertDialogElement();
			this.alert.tintColor = this.configuration.tintColor;
			this.loginWindow = new AuthenticationDialogElement();
			this.loginWindow.tintColor = this.configuration.tintColor;
			this.loginWindowContainer = new MediaContainer();
			this.loginWindowContainer.layoutMetadata.index = ALWAYS_ON_TOP;
			this.loginWindowContainer.layoutMetadata.percentWidth = 100;
			this.loginWindowContainer.layoutMetadata.percentHeight = 100;
			this.loginWindowContainer.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
			this.loginWindowContainer.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
			this.loginWindowContainer.addMediaElement(this.loginWindow);
			if(this.configuration.controlBarMode == ControlBarMode.NONE)
			{
				this.mainContainer.layoutMetadata.layoutMode = LayoutMode.NONE;
			}
			else
			{
				this.controlBar = new ControlBarElement();
				this.controlBar.autoHide = this.configuration.controlBarAutoHide;
				this.controlBar.tintColor = this.configuration.tintColor;
				this.layout();
				this.controlBarContainer.layoutMetadata.height = this.controlBar.height;
				this.controlBarContainer.addMediaElement(this.controlBar);
				this.controlBarContainer.addEventListener(WidgetEvent.REQUEST_FULL_SCREEN,this.onFullScreenRequest);
				this.mainContainer.layoutRenderer.addTarget(this.controlBarContainer);
				this.mediaContainer.layoutRenderer.addTarget(this.loginWindowContainer);
			}
			this.mainContainer.layoutRenderer.addTarget(this.mediaContainer);
			this.onStageResize();
			ExternalInterface.call("msg","this.configuration.usrinfo");
			if(this.configuration.usrinfo != "")
			{
				this.format.font = "verdana";
				this.format.color = 16711680;
				this.format.size = 18;
				this.format.bold = true;
				this.checkuserinfo = new TextField();
				this.checkuserinfo.text = this.configuration.usrinfo;
				this.checkuserinfo.setTextFormat(this.format);
				this.checkuserinfo.defaultTextFormat = this.format;
				this.checkuserinfo.textColor = this.configuration.viewColor;
				this.checkuserinfo.autoSize = "left";
				this.checkuserinfo.width = 200;
				this.checkuserinfo.visible = false;
				addChild(this.checkuserinfo);
				this.mtimer.addEventListener(TimerEvent.TIMER,this.onTimerEvent);
				this.mtimer.start();
			}
			if(this.configuration.modifystudyrec != "")
			{
				_loc2_ = this.configuration.modifystudyrec;
				this._arySplit = _loc2_.split("__");
				this._bSetStudyRec = true;
			}
			var _loc1_:SharedObject = SharedObject.getLocal("randomvalue");
			_loc1_.data.rdval = this.configuration.ctrlrights;
			if(this.configuration.ctrlserver != "")
			{
				_loc1_.data.checkurl = this.configuration.ctrlserver;
			}
			_loc1_.flush();
		}
		
		private function onTimerEvent(param1:Event) : void
		{
			var _loc2_:Number = NaN;
			if(++this.timecount % this.configuration.viewInterval == 0)
			{
				this.scrollcount = 0;
				_loc2_ = Math.ceil(Math.random() * (this.stage.stageHeight - 100));
				this.checkuserinfo.visible = true;
				this.checkuserinfo.x = this.stage.stageWidth;
				this.checkuserinfo.y = _loc2_;
				
				Tweener.addTween(this.checkuserinfo,{
					"x":-this.checkuserinfo.width,
					"time":10,
					"transition":"easenone",
					"onComplete":this.OnMoveComplete,
					"rounded":false
				});
			}
		}
		
		private function OnMoveComplete() : void
		{
			if(++this.scrollcount <= 4)
			{
				this.checkuserinfo.x = this.stage.stageWidth;
				Tweener.addTween(this.checkuserinfo,{
					"x":-this.checkuserinfo.width,
					"time":10,
					"transition":"easenone",
					"onComplete":this.OnMoveComplete,
					"rounded":false
				});
			}
		}
		
		private function loadMedia(... rest) : void
		{
			ExternalInterface.call("msg","loadMedia");
			var _loc3_:* = null;
			var _loc4_:MediaError = null;
			var _loc2_:StreamingURLResource = new StreamingURLResource(this.configuration.src);
			_loc2_.streamType = this.configuration.streamType;
			_loc2_.urlIncludesFMSApplicationInstance = this.configuration.urlIncludesFMSApplicationInstance;
			for(_loc3_ in this.configuration.assetMetadata)
			{
				_loc2_.addMetadataValue(_loc3_,this.configuration.assetMetadata[_loc3_]);
			} 
			this.logger.trackResource("AssetResource",_loc2_);
			ExternalInterface.call("msg","loadMedia————_loc2_"+_loc2_.url);
			this.media = this.factory.createMediaElement(_loc2_);
			ExternalInterface.call("msg","loadMedia————procedding");
			if(this._media == null)
			{
				_loc4_ = new MediaError(MediaErrorCodes.MEDIA_LOAD_FAILED,"课件地址错误，请联系技术支持" + this.configuration.src);
				this.player.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,_loc4_));
			}
		}
		
		private function onMediaElementChangeEvent(param1:MediaElementChangeEvent) : void
		{
			var _loc4_:MediaError = null;
			var _loc2_:SharedObject = SharedObject.getLocal("randomvalue");
			if(param1.uid == 2)
			{
				this.configuration.src = this._aryMediaSrc[2];
				_loc2_.data.quality = "GQ";
			}
			if(param1.uid == 1)
			{
				this.configuration.src = this._aryMediaSrc[1];
				_loc2_.data.quality = "BQ";
			}
			else if(param1.uid == 0)
			{
				this.configuration.src = this._aryMediaSrc[0];
				_loc2_.data.quality = "LC";
			}
			_loc2_.flush();
			this._lastPlayTime = this.player.currentTime;
			this._isChangeQulity = true;
			var _loc3_:StreamingURLResource = new StreamingURLResource(this.configuration.src);
			_loc3_.streamType = this.configuration.streamType;
			_loc3_.urlIncludesFMSApplicationInstance = this.configuration.urlIncludesFMSApplicationInstance;
			this.media = this.factory.createMediaElement(_loc3_);
			if(this._media == null)
			{
				_loc4_ = new MediaError(MediaErrorCodes.MEDIA_LOAD_FAILED,"课件地址错误，请联系技术支持-2011123");
				this.player.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,_loc4_));
			}
		}
		
		private function onChangeHDEvent(param1:Event) : void
		{
			var _loc3_:MediaError = null;
			this.changeQhtimer.stop();
			var _loc2_:StreamingURLResource = new StreamingURLResource(this.configuration.src);
			_loc2_.streamType = this.configuration.streamType;
			_loc2_.urlIncludesFMSApplicationInstance = this.configuration.urlIncludesFMSApplicationInstance;
			this.media = this.factory.createMediaElement(_loc2_);
			if(this._media == null)
			{
				_loc3_ = new MediaError(MediaErrorCodes.MEDIA_LOAD_FAILED,"课件地址错误，请联系技术支持");
				this.player.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,_loc3_));
			}
		}
		
		private function processNewMedia(param1:MediaElement) : MediaElement
		{
			var _loc2_:MediaElement = null;
			var _loc3_:LayoutMetadata = null;
			if(param1 != null)
			{
				_loc2_ = param1;
				_loc3_ = _loc2_.metadata.getValue(LayoutMetadata.LAYOUT_NAMESPACE) as LayoutMetadata;
				if(_loc3_ == null)
				{
					_loc3_ = new LayoutMetadata();
					_loc2_.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE,_loc3_);
				}
				_loc3_.scaleMode = this.configuration.scaleMode;
				_loc3_.verticalAlign = VerticalAlign.MIDDLE;
				_loc3_.horizontalAlign = HorizontalAlign.CENTER;
				_loc3_.percentWidth = 100;
				_loc3_.percentHeight = 100;
				_loc3_.index = 1;
				this.processPoster();
			}
			return _loc2_;
		}
		
		private function layout() : void
		{
			this.controlBarContainer.layoutMetadata.index = ON_TOP;
			if(this.controlBar.autoHide == false && this.configuration.controlBarMode == ControlBarMode.DOCKED)
			{
				this.mainContainer.layoutMetadata.layoutMode = LayoutMode.VERTICAL;
				this.mediaContainer.layoutMetadata.index = 1;
			}
			else
			{
				this.mainContainer.layoutMetadata.layoutMode = LayoutMode.NONE;
				switch(this.configuration.controlBarMode)
				{
					case ControlBarMode.FLOATING:
						this.controlBarContainer.layoutMetadata.bottom = POSITION_OVER_OFFSET;
						break;
					case ControlBarMode.DOCKED:
						this.controlBarContainer.layoutMetadata.bottom = 0;
				}
			}
		}
		
		private function set media(param1:MediaElement) : void
		{
			var _loc2_:MediaElement = null;
			if(param1 != this._media)
			{
				if(this._media)
				{
					this.mediaContainer.removeMediaElement(this._media);
				}
				_loc2_ = this.processNewMedia(param1);
				if(_loc2_)
				{
					param1 = _loc2_;
				}
				this._media = this.player.media = param1;
				if(this._media)
				{
					this.mediaContainer.addMediaElement(this._media);
					if(this.controlBar != null)
					{
						this.controlBar.target = this._media;
					}
					if(this.playOverlay != null)
					{
						this.playOverlay.media = this._media;
					}
					if(this.bufferingOverlay != null)
					{
						this.bufferingOverlay.media = this._media;
					}
					if(this.loginWindow != null)
					{
						this.loginWindow.target = this._media;
					}
					this._stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
					this.mainContainer.addEventListener(MouseEvent.DOUBLE_CLICK,this.onFullScreenRequest);
					this.mediaContainer.addEventListener(MouseEvent.CLICK,this.onMouseClick);
					this.mediaContainer.doubleClickEnabled = true;
					this.mainContainer.doubleClickEnabled = true;
				}
				else
				{
					if(this.playOverlay != null)
					{
						this.playOverlay.media = null;
					}
					if(this.bufferingOverlay != null)
					{
						this.bufferingOverlay.media = null;
					}
				}
			}
		}
		
		private function onSeekingChange(param1:SeekEvent) : void
		{
			var event:SeekEvent = param1;
			if(event.seeking == true)
			{
				if(ExternalInterface.available)
				{
					try
					{
						ExternalInterface.call("onSeekState",this.configuration.id,event.time);
						return;
					}
					catch(_:Error)
					{
						return;
					}
				}
			}
		}
		
		private function processPoster() : void
		{
			var layoutMetadata:LayoutMetadata = null;
			var aryRound:Array = null;
			this.player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,this.onMediaPlayerStateChange);
			if(this.configuration && this.configuration.poster != null && this.configuration.poster != "" && this.player.playing == false)
			{
				try
				{
					this.posterImage = new ImageElement(new URLResource(this.configuration.poster));
					this.posterImage.smoothing = true;
					layoutMetadata = new LayoutMetadata();
					layoutMetadata.scaleMode = this.configuration.scaleMode;
					if(this.configuration.logoScope != "")
					{
						aryRound = new Array();
						aryRound = this.configuration.logoScope.split(",");
						if(aryRound.length < 4)
						{
							return;
						}
						layoutMetadata.left = aryRound[0];
						layoutMetadata.top = aryRound[1];
						layoutMetadata.width = aryRound[2];
						layoutMetadata.height = aryRound[3];
					}
					else
					{
						layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
						layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
						layoutMetadata.percentWidth = 100;
						layoutMetadata.percentHeight = 100;
					}
					layoutMetadata.index = POSTER_INDEX;
					this.posterImage.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE,layoutMetadata);
					LoadTrait(this.posterImage.getTrait(MediaTraitType.LOAD)).load();
					this.mediaContainer.addMediaElement(this.posterImage);
					return;
				}
				catch(error:Error)
				{
					trace("WARNING: poster image failed to load at",configuration.poster);
					return;
				}
			}
		}
		
		private function onMediaPlayerStateChange(param1:MediaPlayerStateChangeEvent) : void
		{
			var srcc:String = null;
			var nret:int = 0;
			var seekTrait:SeekTrait = null;
			var event:MediaPlayerStateChangeEvent = param1;
			if(event.state == MediaPlayerState.PLAYING || event.state == MediaPlayerState.PLAYBACK_ERROR)
			{
				if(this.configuration && this.configuration.poster != null && this.configuration.poster != "" && this.configuration.autoPlay == false && this.player.playing == false)
				{
					srcc = this.configuration.src;
					nret = srcc.indexOf("mp3");
					if(nret == -1)
					{
						this.player.removeEventListener(event.type,arguments.callee);
						this.mediaContainer.removeMediaElement(this.posterImage);
						LoadTrait(this.posterImage.getTrait(MediaTraitType.LOAD)).unload();
						this.posterImage = null;
					}
				}
				this.playertimer.addEventListener(TimerEvent.TIMER,this.onPlayTimerEvent);
				this.playertimer.start();
				if(ExternalInterface.available)
				{
					try
					{
						ExternalInterface.call("onPlayState",this.configuration.id);
					}
					catch(_:Error)
					{
					}
				}
				if(this._isChangeQulity)
				{
					if(this.player.canSeek)
					{
						if(this.player.canSeekTo(this._lastPlayTime))
						{
							this.player.seek(this._lastPlayTime);
						}
					}
					this._isChangeQulity = false;
				}
			}
			else if(event.state == MediaPlayerState.BUFFERING || event.state == MediaPlayerState.PAUSED)
			{
				if(ExternalInterface.available)
				{
					try
					{
						ExternalInterface.call("onPauseState",this.configuration.id);
					}
					catch(_:Error)
					{
					}
				}
			}
			else if(event.state == MediaPlayerState.READY)
			{
				if(ExternalInterface.available)
				{
					try
					{
						ExternalInterface.call("onLoadingState",this.configuration.id);
					}
					catch(_:Error)
					{
					}
				}
			}
			else if(event.state == MediaPlayerState.LOADING)
			{
				if(ExternalInterface.available)
				{
					try
					{
						ExternalInterface.call("onLoadingState",this.configuration.id);
					}
					catch(_:Error)
					{
					}
				}
			}
			else if(event.state == MediaPlayerState.SEEKING)
			{
				seekTrait = !!this._media?this._media.getTrait(MediaTraitType.SEEK) as SeekTrait:null;
				seekTrait.addEventListener(SeekEvent.SEEKING_CHANGE,this.onSeekingChange);
			}
		}
		
		private function onPlayTimerEvent(param1:Event) : void
		{
			var manifestLoader:URLLoader = null;
			var onError:Function = null;
			var onComplete:Function = null;
			var e:Event = param1;
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("onPlayMediaTime",this.player.currentTime,this.player.duration,this.configuration.id);
					if(this.player.currentTime >= this.player.duration)
					{
						if(this.player.playing == true)
						{
							this.player.stop();
							this.playertimer.stop();
						}
					}
				}
				catch(_:Error)
				{
				}
			}
			if(this._bSetStudyRec)
			{
				if(this.player.currentTime > parseInt(this._arySplit[1]))
				{
					onError = function(param1:ErrorEvent):void
					{
						manifestLoader.removeEventListener(Event.COMPLETE,onComplete);
						manifestLoader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
						manifestLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
						var _loc2_:MediaError = new MediaError(MediaErrorCodes.MEDIA_LOAD_FAILED,"Error:controlserver is null!!");
						player.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,_loc2_));
					};
					onComplete = function(param1:Event):void
					{
						var _loc3_:MediaError = null;
						var _loc2_:String = param1.target.data;
						if(_loc2_ == "0")
						{
							trace("record study failed!");
							_loc3_ = new MediaError(MediaErrorCodes.MEDIA_LOAD_FAILED,"课件次数已用完！" + _loc2_);
							player.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,_loc3_));
						}
					};
					this._bSetStudyRec = false;
					manifestLoader = new URLLoader(new URLRequest(this._arySplit[0]));
					manifestLoader.dataFormat = URLLoaderDataFormat.BINARY;
					manifestLoader.addEventListener(Event.COMPLETE,onComplete);
					manifestLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
					manifestLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
				}
			}
		}
		
		private function SeekNewPosition(param1:String) : void
		{
			if(this.player.canSeek)
			{
				if(this.player.canSeekTo(parseInt(param1)))
				{
					this.player.seek(parseInt(param1));
				}
			}
		}
		
		private function PlayMedia() : void
		{
			if(this.player.canPlay)
			{
				this.player.play();
			}
		}
		
		private function PauseMedia() : void
		{
			if(this.player.canPause)
			{
				this.player.pause();
			}
		}
		
		private function OnSetVolume(param1:Number) : void
		{
			if(this.player)
			{
				this.player.volume = param1;
			}
		}
		
		private function StopMedia() : void
		{
			if(this.player.playing || this.player.paused)
			{
				this.player.stop();
			}
		}
		
		private function ModifyRec(param1:String) : void
		{
			this._arySplit = param1.split("__");
			this._bSetStudyRec = true;
		}
		
		private function onAddedToStage(param1:Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			this.initialize(loaderInfo.parameters,stage);
		}
		
		private function onMouseClick(param1:Event = null) : void
		{
			if(this.playOverlay != null && this.playOverlay.visible)
			{
				if(!this.playOverlay._bMouseClick)
				{
					if(this.player.playing)
					{
						this.player.pause();
					}
					else if(this.player.paused)
					{
						this.player.play();
					}
				}
				else
				{
					this.playOverlay._bMouseClick = false;
				}
			}
		}
		
		private function onFullScreenRequest(param1:Event = null) : void
		{
			var event:Event = param1;
			if(this._stage.displayState == StageDisplayState.NORMAL)
			{
				removeChild(this.mainContainer);
				if(this.checkuserinfo && this.configuration.usrinfo != "")
				{
					removeChild(this.checkuserinfo);
				}
				this._stage.fullScreenSourceRect = this.player.getFullScreenSourceRect(this._stage.fullScreenWidth,this._stage.fullScreenHeight);
				if(this._stage.fullScreenSourceRect != null)
				{
					this.logger.info("Setting fullScreenSourceRect = {0}",this._stage.fullScreenSourceRect.toString());
				}
				else
				{
					this.logger.info("fullScreenSourceRect not set.");
				}
				if(this._stage.fullScreenSourceRect != null)
				{
					this.logger.qos.rendering.fullScreenSourceRect = this._stage.fullScreenSourceRect.toString();
					this.logger.qos.rendering.fullScreenSourceRectAspectRatio = this._stage.fullScreenSourceRect.width / this._stage.fullScreenSourceRect.height;
				}
				else
				{
					this.logger.qos.rendering.fullScreenSourceRect = "";
					this.logger.qos.rendering.fullScreenSourceRectAspectRatio = NaN;
				}
				this.logger.qos.rendering.screenWidth = this._stage.fullScreenWidth;
				this.logger.qos.rendering.screenHeight = this._stage.fullScreenHeight;
				this.logger.qos.rendering.screenAspectRatio = this.logger.qos.rendering.screenWidth / this.logger.qos.rendering.screenHeight;
				try
				{
					this._stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				catch(error:SecurityError)
				{
					logger.info("Failed to go to FullScreen. Check if allowfullscreen is set to false in HTML page.");
					addChild(mainContainer);
					mainContainer.validateNow();
				}
			}
			else
			{
				this._stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function onFullScreen(param1:FullScreenEvent) : void
		{
			var _loc2_:Number = NaN;
			if(this._stage.displayState == StageDisplayState.NORMAL)
			{
				if(this.controlBar)
				{
					if(this.controlBar.autoHide != this.configuration.controlBarAutoHide)
					{
						this.controlBar.autoHide = this.configuration.controlBarAutoHide;
						this.layout();
					}
				}
				Mouse.show();
			}
			else if(this._stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				if(this.controlBar)
				{
					this.controlBarWidth = this.controlBar.width;
					this.controlBarHeight = this.controlBar.height;
					this.controlBar.autoHide = true;
					if(this.controlBar.autoHide != this.configuration.controlBarAutoHide)
					{
						this.layout();
					}
				}
				addChild(this.mainContainer);
				this.mainContainer.validateNow();
				if(this.checkuserinfo && this.configuration.usrinfo != "")
				{
					addChild(this.checkuserinfo);
				}
			}
		}
		
		private function onStageResize(param1:Event = null) : void
		{
			this.mainContainer.width = this._stage.stageWidth;
			this.mainContainer.height = this._stage.stageHeight;
			if(this.controlBar != null)
			{
				if(this.configuration.controlBarMode != ControlBarMode.FLOATING || this.controlBar.width > this._stage.stageWidth || this._stage.stageWidth < MAX_OVER_WIDTH)
				{
					this.controlBar.width = this._stage.stageWidth;
				}
				else if(this.configuration.controlBarMode == ControlBarMode.FLOATING)
				{
					this.controlBar.width = MAX_OVER_WIDTH;
				}
			}
		}
		
		private function onUncaughtError(param1:Event) : void
		{
			var mediaError:MediaError = null;
			var event:Event = param1;
			var timer:Timer = new Timer(3000,1);
			mediaError = new MediaError(StrobePlayerErrorCodes.CONFIGURATION_LOAD_ERROR,StrobePlayerStrings.CONFIGURATION_LOAD_ERROR);
			timer.addEventListener(TimerEvent.TIMER,function(param1:Event):void
			{
				onMediaError(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,mediaError));
			});
			timer.start();
		}
		
		private function onMediaError(param1:MediaErrorEvent) : void
		{
			var message:String = null;
			var tokens:Array = null;
			var flashPlayerMajorVersion:int = 0;
			var flashPlayerMinorVersion:int = 0;
			var event:MediaErrorEvent = param1;
			this.player.removeEventListener(MediaErrorEvent.MEDIA_ERROR,this.onMediaError);
			this.player.media = null;
			this.media = null;
			if(event.error.errorID == MediaErrorCodes.NETSTREAM_FILE_STRUCTURE_INVALID)
			{
				if(ExternalInterface.available)
				{
					try
					{
						ExternalInterface.call("OnSwitchLine",2);
					}
					catch(_:Error)
					{
					}
				}
			}
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call(EXTERNAL_INTERFACE_ERROR_CALL,ExternalInterface.objectID,event.error.errorID,event.error.message,event.error.detail);
				}
				catch(_:Error)
				{
				}
			}
			if(this.configuration.verbose)
			{
				message = event.error.message + "\n" + event.error.detail;
			}
			else
			{
				message = event.error.message + "\n" + event.error.detail;
			}
			tokens = Capabilities.version.split(/[\s,]/);
			flashPlayerMajorVersion = parseInt(tokens[1]);
			flashPlayerMinorVersion = parseInt(tokens[2]);
			if(flashPlayerMajorVersion < 10 || flashPlayerMajorVersion == 10 && flashPlayerMinorVersion < 1)
			{
				if(this.configuration.verbose)
				{
					message = message + "\n\nThe content that you are trying to play requires the latest Flash Player version.\nPlease upgrade and try again.";
				}
				else
				{
					message = "The content that you are trying to play requires the latest Flash Player version.\nPlease upgrade and try again.";
				}
			}
			if(this.alert)
			{
				if(this._media != null && this.mediaContainer.containsMediaElement(this._media))
				{
					this.mediaContainer.removeMediaElement(this._media);
				}
				if(this.controlBar != null && this.controlBarContainer.containsMediaElement(this.controlBar))
				{
					this.controlBarContainer.removeMediaElement(this.controlBar);
				}
				if(this.posterImage && this.mediaContainer.containsMediaElement(this.posterImage))
				{
					this.mediaContainer.removeMediaElement(this.posterImage);
				}
				if(this.playOverlay != null && this.mediaContainer.layoutRenderer.hasTarget(this.playOverlay))
				{
					this.mediaContainer.layoutRenderer.removeTarget(this.playOverlay);
				}
				if(this.bufferingOverlay != null && this.mediaContainer.layoutRenderer.hasTarget(this.bufferingOverlay))
				{
					this.mediaContainer.layoutRenderer.removeTarget(this.bufferingOverlay);
				}
				this.mediaContainer.addMediaElement(this.alert);
				this.alert.alert("Error",message);
			}
			else
			{
				trace("Error:",message);
			}
		}
	}
}
