package
{
	
	import fl.transitions.easing.Regular;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Level extends MovieClip
	{
		
		public var pijakan:Array;
		public var bidakAktif:Array;
		public var bidakPasif:Array;
		
		public var historiLangkah:Array;
		public var bidakTerklik:Bidak;
		public var pijakanTerklik:Pijakan;
		
		var aturan:AturanMain;
		
		public function Level()
		{
			aturan = new AturanMain();
			pijakan = KecerdasanBuatan.pijakan;
			bidakAktif = KecerdasanBuatan.bidakAktif;
			bidakPasif = KecerdasanBuatan.bidakPasif;
			bidakTerklik = null;
			pijakanTerklik = new Pijakan;
			// constructor code
			addEventListener(Event.ENTER_FRAME, setiapFrame);
			addEventListener(Event.ADDED_TO_STAGE, tambahKeStage);
			addEventListener(MouseEvent.CLICK, klikObjek);
			btnHistori.addEventListener(MouseEvent.CLICK, klikHistori);
			//addEventListener(MouseEvent.MOUSE_UP, mosUp);
		}
		
		private function klikObjek(e:MouseEvent):void
		{
			resetKlikPijakBidak();
			if (e.target.parent.parent as Bidak)
			{
				Bidak(e.target.parent.parent).klikSaya();
				bidakTerklik = Bidak(e.target.parent.parent);
			}
			else if ((e.target as Pijakan) || (e.target.parent as Pijakan))
			{
				try
				{
					Pijakan(e.target).pilihPijakan(null);
					pijakanTerklik = Pijakan(e.target);
				}
				catch (er:Error)
				{
					Pijakan(e.target.parent).pilihPijakan(null);
					pijakanTerklik = Pijakan(e.target.parent);
				}
				if (bidakTerklik != null)
				{
					if (aturan.setLangkah(bidakTerklik, pijakanTerklik))
					{
						bidakTerklik.klikSaya();
						var twX:Tween = new Tween(bidakTerklik, "x", Regular.easeInOut, bidakTerklik.x, pijakanTerklik.x, 10);
						var twY:Tween = new Tween(bidakTerklik, "y", Regular.easeInOut, bidakTerklik.y, pijakanTerklik.y, 10);
					}
					bidakTerklik = null;
				}
				
			}
			else {
				//trace(e.target);
			}
		}
		// reset klik Pijakan dan Bidak
		private function resetKlikPijakBidak():void
		{
			for (var p = 0; p < pijakan.length; p++)
			{
				pijakan[p].anjakKe("kosong");
			}
			for (var b1 = 0; b1 < bidakAktif.length; b1++)
			{
				bidakAktif[b1].tidakKlikSaya();
			}
		}
		
		//saat tambah ke stage
		protected function tambahKeStage(e:Event):void
		{
			buatTempatPijak();
			buatHubunganPijak();
			buatJalur();
			buatBidak();
			resetBeberapaMovie();			
		}
		
		protected function resetBeberapaMovie():void
		{
			MovieClip(kotakChat).visible = false;
			MovieClip(kotakHistoris).visible = false;
		}
		
		protected function buatBidak():void
		{
			//ini untuk membuat bidak manusia
			for (var a = 1; a <= 12; a++)
			{
				var bidA:Bidak = new Bidak("anak", KelasMacan.lpad(a, 2));
				bidA.x = 175 + (a * 45);
				bidA.y = 555;
				bidakAktif.push(bidA);
				addChild(bidA);
			}
			
			//ini untuk membuat bidak macan
			for (var b = 1; b <= 2; b++)
			{
				var bid:Bidak = new Bidak("macan", KelasMacan.lpad(b, 2));
				bid.x = 65 + (b * 45);
				bid.y = 555;
				bidakAktif.push(bid);
				addChild(bid);
			}
		}
		
		protected function buatHubunganPijak():void
		{
			var pX = 0;
			var pY = 0;
			// cari tiap pijakan dan hubungkan
			for (var b = 0; b < pijakan.length; b++)
			{
				pX = Pijakan(pijakan[b]).x;
				pY = Pijakan(pijakan[b]).y;
				//cari tiap pijakan lain
				for (var bx = 0; bx < pijakan.length; bx++)
				{
					// hitung selisih get by name
					var pijakanAwal:Pijakan = Pijakan(pijakan[b]);
					var pijakanAkhir:Pijakan = Pijakan(pijakan[bx]);
					var noPijakAwal:Number = Number(pijakanAwal.getNama().substring(1));
					var noPijakAkhir:Number = Number(pijakanAkhir.getNama().substring(1));
					var selisih:Number = Math.abs(noPijakAwal - noPijakAkhir);
					
					// buat koneksi pijakan untuk vertikal
					if (pX == pijakanAkhir.x && pijakanAwal.getNama() != pijakanAkhir.getNama() && selisih == 1)
						pijakanAwal.tambahKoneksi(pijakanAkhir, "N");
					
					//buat koneksi pijakan untuk horisontal
					if (pY == pijakanAkhir.y && ((pX == (pijakanAkhir.x - 90) || pijakanAkhir.x == (pX - 90)) || (pX == (pijakanAkhir.x - 80) || pijakanAkhir.x == (pX - 80))))
					{
						if (pijakanAwal.x < pijakanAkhir.x)
							pijakanAwal.tambahKoneksi(pijakanAkhir, "E");
						else
							pijakanAwal.tambahKoneksi(pijakanAkhir, "W");
					}
					
					//buat jalur silang bawah kanan atas
					if (noPijakAwal % 2 == 1 && pijakanAwal.x == (pijakanAkhir.x - 90) && pijakanAwal.y == (pijakanAkhir.y + 90))
						pijakanAwal.tambahKoneksi(pijakanAkhir, "NE");
					
					// buat jalur silang kiri kanan bawah
					if (noPijakAwal % 2 == 1 && pijakanAwal.x == (pijakanAkhir.x + 90) && pijakanAwal.y == (pijakanAkhir.y + 90))
						pijakanAwal.tambahKoneksi(pijakanAkhir, "NW");
					
					//buat jalur silang bawah kanan atas untuk U dan B
					if ((pijakanAwal.x == (pijakanAkhir.x - 80) && pijakanAwal.y == (pijakanAkhir.y + 80)))
					{
						if (pijakanAwal.getNama() != "A2" && pijakanAwal.getNama() != "B1")
							pijakanAwal.tambahKoneksi(pijakanAkhir, "NE");
					}
					//buat jalur silang atas kanan bawah untuk U dan B
					if ((pijakanAwal.x == (pijakanAkhir.x - 80) && pijakanAwal.y == (pijakanAkhir.y - 80)))
					{
						if (pijakanAwal.getNama() != "A2" && pijakanAwal.getNama() != "B3")
							pijakanAwal.tambahKoneksi(pijakanAkhir, "SE");
					}
				}
			}
			
			//buat koneksi loncat
			for (var pj = 0; pj < pijakan.length; pj++)
			{
				pijakan[pj].tambahKoneksiLoncat();
			}
		
		}
		
		protected function buatJalur()
		{
			for (var i = 0; i < pijakan.length; i++)
			{
				if (Pijakan(pijakan[i]).getJumlahKoneksi() > 0)
				{
					for (var j = 0; j < Pijakan(pijakan[i]).getJumlahKoneksi(); j++)
					{
						var pKon:Pijakan = Pijakan(pijakan[i].getKoneksi()[j]);
						graphics.lineStyle(5, 0xAAAAAA);
						graphics.moveTo(pijakan[i].x, pijakan[i].y);
						graphics.lineTo(pKon.x, pKon.y);
					}
				}
			}
		}
		
		protected function cariPijakanByNama(s:String):Pijakan
		{
			for (var i = 0; i < pijakan.length; i++)
			{
				if (Pijakan(pijakan[i]).getNama() == s)
				{
					return Pijakan(pijakan[i]);
					break;
				}
			}
			return null;
		}
		
		protected function buatTempatPijak():void
		{
			// di sini kita akan membuat Kumpulan Pijakan tengah (Center) 5x5
			// selisih untuk tiap pijakan (x=90, y=10)
			// pijakan pertama 200,480, kedua 200, 390
			var letakX:Number = 0;
			var letakY:Number = 0;
			for (var i:int = 0; i < 25; i++)
			{
				letakY = 480 - ((i % 5) * 90);
				if (i < 5)
					letakX = 200 + (0 * 90);
				else if (i < 10)
					letakX = 200 + (1 * 90);
				else if (i < 15)
					letakX = 200 + (2 * 90);
				else if (i < 20)
					letakX = 200 + (3 * 90);
				else if (i < 25)
					letakX = 200 + (4 * 90);
				
				var p:Pijakan = new Pijakan();
				p.x = letakX;
				p.y = letakY;
				p.setText("C" + (i + 1));
				
				pijakan.push(p);
				addChild(p);
			}
			
			// buat pijakan atas (A) 3x2
			for (var a:int = 0; a < 6; a++)
			{
				if (a < 3)
				{
					letakX = 40;
					letakY = 460 - (a * 160);
				}
				else if (a < 6)
				{
					letakX = 40 + 80;
					letakY = 380 - ((a % 3) * 80);
				}
				
				var pA:Pijakan = new Pijakan();
				pA.x = letakX;
				pA.y = letakY;
				pA.setText("A" + (a + 1));
				
				pijakan.push(pA);
				addChild(pA);
			}
			
			// buat pijakan bawah (B) 3x2
			for (var b:int = 0; b < 6; b++)
			{
				if (b < 3)
				{
					letakX = 640;
					letakY = 380 - ((b % 3) * 80);
				}
				else if (b < 6)
				{
					letakX = 640 + 80;
					letakY = 460 - ((b % 3) * 160);
				}
				
				var pB:Pijakan = new Pijakan();
				pB.x = letakX;
				pB.y = letakY;
				pB.setText("B" + (b + 1));
				
				pijakan.push(pB);
				addChild(pB);
			}
		}
		
		private function setiapFrame(e:Event):void
		{
		
		}
		
		private function mosUp(e:MouseEvent):void
		{
			if (e.target.parent.parent as Bidak)
			{
				var b:Bidak = e.target.parent.parent as Bidak;
				var posAwalX = b.x;
				var posAwalY = b.y;
				var pij:Array = new Array();
				for (var p = 0; p < pijakan.length; p++)
				{
					if (Bidak(e.target.parent.parent).hitTestObject(pijakan[p]))
					{
						pij.push(pijakan[p]);
					}
				}
				
				if (pij.length > 1)
				{
					
					e.target.parent.parent.x = posAwalX;
					e.target.parent.parent.y = posAwalY;
				}
			}
		}
		private function klikHistori(e:MouseEvent):void 
		{
			if(kotakHistoris.visible == false)
				kotakHistoris.visible = true;
			else
				kotakHistoris.visible = false;
			//trace("tombol terklik");
		}
		
	}

}
