package
{
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Bidak extends MovieClip
	{
		
		var gambar:String;
		var circle:Sprite = new Sprite();
		var terklik:Boolean;
		var tipeBidak:String;
		var status:Boolean;
		
		private var pijakan:Pijakan;
		private var pijakanSebelum:Pijakan;
		var loadGambar:Loader = new Loader();
		
		private var nama:String;
		
		public function Bidak(tipe:String = "macan", namaGambar:String = "01")
		{
			// constructor code
			pijakan = null;
			pijakanSebelum = null;
			terklik = false;
			gambar = KelasMacan.getFolderBidak() + tipe + "_" + namaGambar + ".png";
			tipeBidak = tipe;
			status = true;
			
			nama = tipe + "_" + namaGambar;
			this.buttonMode = true;
			addEventListener(Event.ADDED_TO_STAGE, inisialisasi); //saat ditambahkan ke stage
			
			textnya.text = namaGambar;
		}
		
		private function inisialisasi(e:Event):void
		{
			//set default untuk pengambilan gambar			
			loadGambar.load(new URLRequest(gambar));
			loadGambar.x = -21;
			loadGambar.y = -21;
			
			gambarBidak.addChildAt(loadGambar, 0);
			gDisable.visible = false;
		}
		
		public function getNama():String
		{
			return nama;
		}
		
		public function setPijakan(pijak:Pijakan)
		{
			pijakanSebelum = pijakan;
			pijakan = pijak;
		}
		
		public function getPijakan():Pijakan
		{
			return pijakan;
		}
		public function getPijakanSebelum():Pijakan
		{
			return pijakanSebelum;
		}
		
		public function klikSaya()
		{
			//trace(getNama());
			if (!terklik)
			{
				var warna:uint;
				if (tipeBidak == "macan")
					warna = uint("0x" + "E56F00");
				else
					warna = uint("0x" + "008EE5");
				circle.graphics.beginFill(warna);
				circle.graphics.drawCircle(0, 0, 23);
				circle.graphics.endFill();
				this.addChildAt(circle, 0);
				terklik = true;
			}
			if (this.getPijakan() != null)
				this.getPijakan().pilihPijakan(null);
		}
		
		public function tidakKlikSaya()
		{
			if (terklik)
			{
				this.removeChildAt(0);
				terklik = false;
			}
		}
		
		public function setDisable()
		{
			circle.graphics.beginFill(0xDDDDDD, 1);
			circle.graphics.drawCircle(0, 0, 22);
			circle.graphics.endFill();
			addChildAt(circle,0);
			
			gDisable.visible = true;
			status = false;
			
			setPijakan(null);
		}
	
	}

}
