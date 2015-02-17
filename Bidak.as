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
		var terklik:Boolean = false;
		var tipeBidak:String;
		var pijakan:Pijakan;
		var loadGambar:Loader = new Loader();
		
		public function Bidak(tipe:String = "macan", namaGambar:String = "01")
		{
			// constructor code
			pijakan = null;
			gambar = KelasMacan.getFolderBidak() + tipe + "_" + namaGambar + ".png";
			tipeBidak = tipe;
			
			addEventListener(Event.ADDED_TO_STAGE, inisialisasi); //saat ditambahkan ke stage
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver); // saat diatas bidak
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut); // saat keluar bidak
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown); //ini jika drag drop
			addEventListener(MouseEvent.MOUSE_UP, mouseUp); //ini jika drag drop
		}
		
		/*
		   public function klikSaya()
		   {
		   if (!terklik)
		   {
		   circle.graphics.beginFill(0x008EE5);
		   circle.graphics.drawCircle(0, 0, 23);
		   circle.graphics.endFill();
		   addChildAt(circle, 0);
		   }
		   }
		
		   public function tidakKlikSaya()
		   {
		   if (terklik) removeChildAt(0);
		   }
		 */
		
		private function mouseDown(e:MouseEvent):void //ini jika drag drop
		{
			this.startDrag();
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
			
			gambarBidak.addChildAt(loadGambar,0);
			
			/*var masker:Shape = new Shape();
			masker.graphics.beginFill(0x0);
			masker.graphics.drawCircle(0, 0, 21);
			masker.graphics.endFill();
			this.addChild(masker);
			//loadGambar.mask = masker;*/
		
			//gambarBidak.addChild(loadGambar);
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
