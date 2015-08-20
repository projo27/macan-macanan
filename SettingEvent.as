package  
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Nafi Projo
	 */
	public class SettingEvent extends Event
	{
		public var setting:String;
		public static const ABOUT = "about";
		public static const SOUND = "sound";
		public static const MUSIC = "music";
		public static const QUIT = "quit";
		public static const WIN = "win";
		
		public function SettingEvent(type:String, setting:String) 
		{
			super(type);
			this.setting = setting;
		}
		
	}

}