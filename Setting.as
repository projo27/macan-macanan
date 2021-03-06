package
{
	import fl.transitions.easing.Regular;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Nafi Projo
	 */
	public class Setting extends MovieClip
	{
		public static var settingSound:Boolean = true;
		public static var settingMusic:Boolean = true;
		var settingTampil:Boolean = false;
		var settingAbout:Boolean = false;
		
		var twX:Tween;
		var twY:Tween;
		
		public var bgMusic:Sound;
		public var bgMusicChannel:SoundChannel;
		var musicPosisi:int;
		
		public function Setting(setSound:Boolean = true, setMusic:Boolean = true)
		{
			addEventListener(Event.ADDED_TO_STAGE, tambahKeStage);			
			mainkanMusic();
		}
		
		private function mainkanMusic():void 
		{			
			bgMusic = new Sound();
			bgMusic.load(new URLRequest("sound/bg_music.mp3"));
			bgMusicChannel = bgMusic.play(0, 9999, new SoundTransform(0.2));
		}
		
		private function tambahKeStage(e:Event):void
		{
			for (var i:int = this.numChildren - 1; i >= 0; i--)
			{
				//trace(i + " " + this.getChildAt(i).name);
				var btn:SimpleButton = SimpleButton(this.getChildAt(i));
				btn.x = 20;
				btn.y = 20;
				btn.addEventListener(MouseEvent.CLICK, klikTombol);
			}
		}
		
		private function klikTombol(e:MouseEvent):void
		{
			switch (e.target.name)
			{
				case "tombolSetting": 
					tampikanSetting();
					break;
				case "tombolSound": 
					setSound();
					break;
				case "tombolMusic": 
					setMusic();
					break;
				case "tombolAbout": 
					tampilkanAbout();
					break;
				default: 
					tampilkanQuit();
					break;
			}
		}
		
		
		private function setSound():void 
		{
			if (KelasMacan.SOUND){
				KelasMacan.SOUND = false;
				SimpleButton(tombolSound).alpha = 0.3;
			}
			else{
				KelasMacan.SOUND = true;
				SimpleButton(tombolSound).alpha = 1;
			}
		}
		private function setMusic():void 
		{
			if (KelasMacan.MUSIC) {
				KelasMacan.MUSIC = false;
				musicPosisi = bgMusicChannel.position;
				bgMusicChannel.stop();
				SimpleButton(tombolMusic).alpha = 0.3;
			}
			else {
				KelasMacan.MUSIC = true;
				bgMusicChannel = bgMusic.play(musicPosisi, 9999, new SoundTransform(0.2));
				SimpleButton(tombolMusic).alpha = 1;
				
			}
		}
		
		private function tampilkanQuit():void 
		{
			var ev:SettingEvent = new SettingEvent(SettingEvent.QUIT, "on");
			dispatchEvent(ev);
		}
		
		private function tampilkanAbout():void 
		{
			var ev:SettingEvent = new SettingEvent(SettingEvent.ABOUT, "on");
			dispatchEvent(ev);
		}
		
		private function tampikanSetting():void
		{
			var nx:int = 0;
			for (var r = 0; r < this.numChildren - 1; r++)
			{
				if (!settingTampil)
					nx = 200 + (r * -45);
				else
					nx = 20;
				
				twX = new Tween(this.getChildAt(r), "x", Regular.easeInOut, this.getChildAt(r).x, nx, 10);
			}
			
			if (settingTampil)
				settingTampil = false;
			else
				settingTampil = true;
		}
	
	}

}