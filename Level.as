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
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	
	public class Level extends MovieClip
	{
		
		public var pijakan:Array;
		public var bidakAktif:Array;
		public var bidakPasif:Array;
		
		public var historiLangkah:Array;
		public var bidakTerklik:Bidak;
		public var pijakanTerklik:Pijakan;
		
		var aturan:AturanMain;
		var arrBidakTerloncati:Array = new Array();
		
		private var tween:Array;
		protected var waktu:int;
		protected var apaMenang:Boolean;
		protected var bidakMenang:String;
		
		protected var timer:Timer;
		protected var timerGC:Timer;
		protected var timerClock:Timer;
		
		var twX:Tween;
		var twY:Tween;
		
		public function Level()
		{
			aturan = new AturanMain();
			pijakan = KecerdasanBuatan.pijakan;
			bidakAktif = KecerdasanBuatan.bidakAktif;
			bidakPasif = KecerdasanBuatan.bidakPasif;
			bidakTerklik = new Bidak;
			pijakanTerklik = new Pijakan;
			waktu = 0;
			apaMenang = false;
			bidakMenang = "";
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, tambahKeStage);
			addEventListener(MouseEvent.CLICK, klikObjek);
			btnHistori.addEventListener(MouseEvent.CLICK, klikHistori);
			
			timer = new Timer(3000, 1); // timer menjalankan AI awal
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, awalJalankanAI);
			timer.start();
			
			timerGC = new Timer(10000, 0); // timer Garbage Collector
			timerGC.addEventListener(TimerEvent.TIMER_COMPLETE, releaseGC);
			timerGC.start();
			
			timerClock = new Timer(1000, 1); //timer Waktu
			timerClock.addEventListener(TimerEvent.TIMER_COMPLETE, tambahDetik);
			timerClock.start();
		}
		
		protected function tambahDetik(e:TimerEvent):void
		{
			waktu++;
			(MovieClip(kotakWaktu).getChildByName("tWaktu") as TextField).text = KelasMacan.detikKeWaktu(waktu);
			KelasMacan.waktunya = KelasMacan.detikKeWaktu(waktu);
			timerClock.start();
		}
		
		protected function releaseGC(e:TimerEvent):void
		{
			System.gc(); // release garbage
			timerGC.start();
		}
		
		protected function klikObjek(e:MouseEvent):void
		{
			if(!KecerdasanBuatan.cekMenang()[0])
			{
				resetKlikPijakBidak();
			}
			else
			{
				apaMenang = true;
				bidakMenang = KecerdasanBuatan.cekMenang()[1];
				timer.stop();
				timerClock.stop();
				timerGC.stop();
				MovieClip(modal).visible = true;
				stage.removeEventListener(MouseEvent.CLICK, klikObjek);
				return;
			}
			
			if (e.target.parent.parent as Bidak || e.target as Bidak)
			{
				try
				{
					if (Bidak(e.target.parent.parent).status)
					{
						Bidak(e.target.parent.parent).klikSaya();
						bidakTerklik = Bidak(e.target.parent.parent);
					}
				}
				catch (err:Error)
				{
					if (Bidak(e.target).status)
					{
						Bidak(e.target).klikSaya();
						bidakTerklik = Bidak(e.target);
					}
				}
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
					var loncat:Boolean = false; // set loncat ke false
					if (bidakTerklik.getPijakan() != null)
					{
						arrBidakTerloncati = KelasMacan.bidakTerloncatiMacan(bidakTerklik.getPijakan(), pijakanTerklik);
						if (arrBidakTerloncati.length == 2)
							loncat = true;
					}
					
					if (aturan.cekLangkah(bidakTerklik, pijakanTerklik))
					{
						aturan.setLangkah(bidakTerklik, pijakanTerklik);
						bidakTerklik.klikSaya();
						twX = new Tween(bidakTerklik, "x", Regular.easeInOut, bidakTerklik.x, pijakanTerklik.x, 10);
						twY = new Tween(bidakTerklik, "y", Regular.easeInOut, bidakTerklik.y, pijakanTerklik.y, 10);
						if (bidakTerklik.tipeBidak == "anak")
							geserBidakAnak();
						
						if (!loncat)
						{
							twY.addEventListener(TweenEvent.MOTION_FINISH, mulaiJalankanAI); // jika tidak loncat langsung jalankan AI
							MovieClip(kotakWaktu).gotoAndPlay(1);
						}
						KecerdasanBuatan.setHistoriLangkah(bidakTerklik, pijakanTerklik); //simpan langkah
					}
					
					if (loncat) // jika loncat, pindahkan bidak terlebih dahulu
					{
						twX.addEventListener(TweenEvent.MOTION_FINISH, pindahBidak);
						MovieClip(kotakWaktu).gotoAndPlay(1); // memberi efek ganti warna pada jam
					}
					bidakTerklik = null;
					
				}
			}
			else
			{
				//trace(e.target);
			}
		}
		
		private function pindahBidak(e:TweenEvent):void
		{
			for (var bt = 0; bt < arrBidakTerloncati.length; bt++)
			{
				geserBidakAnakPasif(arrBidakTerloncati[bt]);
				arrBidakTerloncati[bt].setDisable();
				KelasMacan.hapusBidakAktif(arrBidakTerloncati[bt]);
				arrBidakTerloncati[bt].getPijakanSebelum().setBidak(null);
				KelasMacan.sleep(100);
			}
			
			timer = new Timer(800, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, mulaiJalankanAI);
			timer.start();
		}
		
		protected function geserBidakAnak():void
		{
			tween = new Array();
			var aArr:Array = new Array();
			var bidak:Array = bidakAktif.concat(bidakPasif);
			
			for (var a = 0; a < bidak.length; a++)
			{
				if (bidak[a].tipeBidak == "anak" && bidak[a].getPijakan() == null)
					aArr.push(bidak[a]);
			}
			
			for (var r = 0; r < aArr.length; r++)
			{
				var tw:Tween = new Tween(aArr[r], "x", Regular.easeInOut, aArr[r].x, 220 + (r * 45), 10);
				tween.push(tw);
			}
		}
		
		protected function geserBidakAnakPasif(b:Bidak):void
		{
			var bidakTerakhir:Bidak = null;
			var bidak:Array = bidakAktif.concat(bidakPasif);
			
			var korX:int = 220;
			var korY:int = 555;
			for (var a = 0; a < bidak.length; a++)
			{
				if (bidak[a].tipeBidak == "anak" && bidak[a].getPijakan() == null)
					bidakTerakhir = bidak[a];
			}
			//trace(bidakTerakhir.getNama()+" "+bidakTerakhir.x+" "+bidakTerakhir.y);
			if (bidakTerakhir != null) {
				trace(bidakTerakhir.getNama()+" "+bidakTerakhir.x+" "+bidakTerakhir.y);
				korX = bidakTerakhir.x + 45;
			}
			
			var twX:Tween = new Tween(b, "x", Regular.easeInOut, b.x, korX, 20);
			var twY:Tween = new Tween(b, "y", Regular.easeInOut, b.y, korY, 20);
			
			b.x = korX;
			b.y = korY;
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
			removeEventListener(Event.ADDED_TO_STAGE, tambahKeStage);
			buatTempatPijak();
			buatHubunganPijak();
			buatJalur();
			buatBidak();
			resetBeberapaMovie();
			
			salinPijakBidakKeTemporari();
		}
		
		private function salinPijakBidakKeTemporari():void 
		{
			KecerdasanBuatan.tempPijakan = pijakan;
			KecerdasanBuatan.tempBidakPasif = bidakPasif;
		}
		
		protected function awalJalankanAI(e:TimerEvent):void
		{
			if (KecerdasanBuatan.getPlayerMacan() == "AI")
				jalankanAI();
		}
		
		protected function mulaiJalankanAI(e:Event):void
		{
			// jika langkah langkah selanjutnya ganjil, dan player MACAN = "AI"
			if (KecerdasanBuatan.historiLangkah.length % 2 == 0 && KecerdasanBuatan.getPlayerMacan() == "AI")
				jalankanAI();
			else if (KecerdasanBuatan.historiLangkah.length % 2 == 1 && KecerdasanBuatan.getPlayerAnak() == "AI")
				jalankanAI();
				
			//selain di atas, maka bidak macan dan manusia dijalankan oleh PLAYER
		}
		
		protected function jalankanAI(e:TweenEvent = null):void
		{
			if (KecerdasanBuatan.cekMenang()[0])
			{
				klikObjek(null);
				return;
			} // jika sudah ada pemenang, stop
			
			try
			{
				KecerdasanBuatan.mariMainkan();
				var arr:Array = KecerdasanBuatan.sedangJalan;
				
				var bidak:Bidak = arr[0];
				var pijakan:Pijakan = arr[1];
				
				if (bidak != null && pijakan != null)
				{
					bidak.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					
					if (!bidak.terklik)
						jalankanAI(null);
					else
						pijakan.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				else
				{
					try
					{
						trace(bidak.getNama() + " " + pijakan.getNama());
					}
					catch (er:Error)
					{
						trace(bidak.getNama() + " kosong ");
					}
					timer = new Timer(200, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, mulaiJalankanAI);
					timer.start();
				}
			}
			catch (er:Error)
			{
				//trace("gundul");
				trace(er.message);
				//timer = new Timer(200, 1);
				//timer.addEventListener(TimerEvent.TIMER_COMPLETE, mulaiJalankanAI);
				//timer.start();
			}
		}
		
		protected function resetBeberapaMovie():void
		{
			MovieClip(kotakChat).visible = false;
			MovieClip(kotakHistoris).visible = false;
			MovieClip(modal).visible = false;
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
				parentPijakan.addChild(p);
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
				parentPijakan.addChild(pA);
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
				parentPijakan.addChild(pB);
			}
		}
		
		protected function buatBidak():void
		{
			//ini untuk membuat bidak manusia
			for (var a = 1; a <= KelasMacan.JUMLAH_BIDAK_ANAK; a++)
			{
				var bidA:Bidak = new Bidak("anak", KelasMacan.lpad(a, 2));
				bidA.x = 175 + (a * 45);
				bidA.y = 555;
				bidakAktif.push(bidA);
				parentBidak.addChild(bidA);
			}
			
			//ini untuk membuat bidak macan
			for (var b = 1; b <= KelasMacan.JUMLAH_BIDAK_MACAN; b++)
			{
				var bid:Bidak = new Bidak("macan", KelasMacan.lpad(b, 2));
				bid.x = 65 + (b * 45);
				bid.y = 555;
				bidakAktif.push(bid);
				parentBidak.addChild(bid);
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
		
		/*protected function cariPijakanByNama(s:String):Pijakan
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
		}*/
		
		private function klikHistori(e:MouseEvent):void
		{
			if (kotakHistoris.visible == false)
				kotakHistoris.visible = true;
			else
				kotakHistoris.visible = false;
		}
	
	}

}
