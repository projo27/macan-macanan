package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Nafi Projo
	 */
	public class KotakBidak extends MovieClip
	{
		var jenisPlayer:String;
		var bgColor:String = "338CCB";
		var bgColorToggle:String = "03AEDA";
		var gambar:String;
		var ctWarna:ColorTransform;
		var rect:Shape;
		public var apaTerpilih:Boolean;
		var loadGambar:Loader;
		
		public function KotakBidak(jnsPlayer:String = "macan")
		{
			jenisPlayer = jnsPlayer;
			
			ctWarna = new ColorTransform();
			rect = new Shape();
			apaTerpilih = false;
			
			loadGambar = new Loader();
			
			addEventListener(Event.ADDED_TO_STAGE, tambahKeStage);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOver);
		}
		
		private function mouseOver(e:MouseEvent):void
		{
			if (ctWarna.color.toString(16).toUpperCase() == bgColor)
				gantiWarna(bgColorToggle, bgColor, false);
			else
				gantiWarna(bgColor, bgColorToggle, false);
			
			(MovieClip(kotakBg)).transform.colorTransform = ctWarna;
		}
		
		private function gantiWarna(warna:String, warnaToggle:String, toggle:Boolean = false):void
		{
			if (toggle)
				this.ctWarna.color = uint("0x" + warnaToggle);
			else
				this.ctWarna.color = uint("0x" + warna);
		}
		
		private function tambahKeStage(e:Event):void
		{
			//trace(jenisPlayer);
			if (jenisPlayer == "macan")
			{
				gantiWarna(bgColor, bgColorToggle, false);				
			}
			else
			{
				gantiWarna(bgColorToggle, bgColor, false);
				this.buttonMode = true;
			}
			textnya.text = jenisPlayer.toUpperCase();
			textnya2.text = jenisPlayer.toUpperCase();
			gambar = KelasMacan.getFolderBidak() + "PLAYER_" + jenisPlayer.toUpperCase() + ".jpg";
			(MovieClip(kotakBg)).transform.colorTransform = ctWarna;
			
			loadGambar.load(new URLRequest(gambar));
			loadGambar.scaleX = 1.6;
			loadGambar.scaleY = 1.6;
			loadGambar.x = -61;
			loadGambar.y = -61;
			
			loadGambarPlayer.addChild(loadGambar);
			
			//buat bayangan
			rect.graphics.beginFill(0xDDDDDD, 1);
			rect.graphics.drawRect(-83, -82, 170, 180);
			rect.graphics.endFill();
			this.addChildAt(rect, 0);
		}
		
		public function pilih(terpilih:Boolean = true)
		{
			if (terpilih)
			{
				if (!apaTerpilih)
				{
					this.x -= 2;
					this.y -= 2;
					rect.x += 2;
					rect.y += 2;
					apaTerpilih = true;
				}
			}
			else
			{
				if (apaTerpilih)
				{
					this.x += 2;
					this.y += 2;
					rect.x -= 2;
					rect.y -= 2;
					apaTerpilih = false;
				}
			}
		}
	
	}

}