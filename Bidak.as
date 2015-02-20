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
		
		var pijakan:Pijakan;
		var loadGambar:Loader = new Loader();
		
		private var nama:String;
		
		public function Bidak(tipe:String = "macan", namaGambar:String = "01")
		{
			// constructor code
			pijakan = null;
			terklik = false;
			gambar = KelasMacan.getFolderBidak() + tipe + "_" + namaGambar + ".png";
			tipeBidak = tipe;
			
			nama = tipe + "_" + namaGambar;
			this.buttonMode = true;
			addEventListener(Event.ADDED_TO_STAGE, inisialisasi); //saat ditambahkan ke stage
			//addEventListener(MouseEvent.MOUSE_OVER, mouseOver); // saat diatas bidak
			//addEventListener(MouseEvent.MOUSE_OUT, mouseOut); // saat keluar bidak
			
			//addEventListener(MouseEvent.MOUSE_DOWN, mouseDown); //ini jika drag drop
			//addEventListener(MouseEvent.MOUSE_UP, mouseUp); //ini jika drag drop
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
		
		private function mouseDown(e:MouseEvent):void //ini jika drag drop
		{
			this.startDrag();
			klikSaya();
		}
		
		private function mouseUp(e:MouseEvent):void //ini jika drag drop
		{
			this.stopDrag();
		}
		
		private function mouseOut(e:MouseEvent):void
		{
			removeChildAt(0);
		}
		
		private function mouseOver(e:MouseEvent):void
		{
			var warna:uint;
			if (tipeBidak == "macan")
				warna = uint("0x" + "E56F00");
			else
				warna = uint("0x" + "008EE5");
			
			circle.graphics.beginFill(warna);
			circle.graphics.drawCircle(0, 0, 23);
			circle.graphics.endFill();
			addChildAt(circle, 0);
		}
		
		private function inisialisasi(e:Event):void
		{
			//set default untuk pengambilan gambar			
			loadGambar.load(new URLRequest(gambar));
			loadGambar.x = -21;
			loadGambar.y = -21;
			
			gambarBidak.addChildAt(loadGambar, 0);
		}
		
		public function getNama():String
		{
			return nama;
		}
		
		public function setPijakan(pijak:Pijakan)
		{
			pijakan = pijak;
		}
		
		public function getPijakan():Pijakan
		{
			return pijakan;
		}
	
	}

}
