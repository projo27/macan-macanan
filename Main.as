package
{
	import fl.transitions.easing.Regular;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class Main extends MovieClip
	{
		private var pijakans:Array;
		private var bidaks:Array;
		var bidaksAktif:Array;
		var bidaksPasif:Array;
		var bidakTerklik:Bidak;
		var pijakanTerklik:Pijakan;
		var bidakTerloncati:Array;
		var arrSedangJalan:Array;
		var bidakAI:Bidak;
		var pijakanAI:Pijakan;
		
		var aturan:AturanMain;
		var kelasMacan:KelasMacan;
		var AI:KecerdasanBuatan;
		var menang:Array;
		
		/* tween */
		var twX:Tween;
		var twY:Tween;
		var tween:Array;
		
		/* timer */
		protected var timerAI:Timer;
		protected var timerGC:Timer;
		protected var timerClock:Timer;
		protected var waktu:int;
		static var dalam:int = 10;
		
		public function Main()
		{
			pijakans = new Array();
			bidaks = new Array();
			aturan = new AturanMain();
			kelasMacan = new KelasMacan();
			AI = new KecerdasanBuatan();
			menang = new Array();
			
			addEventListener(Event.ADDED_TO_STAGE, tambahKeStage);
			addEventListener(MouseEvent.CLICK, klikObjek);
			
			timerAI = new Timer(3000, 1); // timer menjalankan AI awal
			timerAI.addEventListener(TimerEvent.TIMER_COMPLETE, awalJalankanAI);
			timerAI.start();
			
			timerGC = new Timer(10000, 0); // timer Garbage Collector
			timerGC.addEventListener(TimerEvent.TIMER_COMPLETE, releaseGC);
			timerGC.start();
			
			timerClock = new Timer(1000, 1); //timer Waktu
			timerClock.addEventListener(TimerEvent.TIMER_COMPLETE, tambahDetik);
			timerClock.start();			
		}		
		
		//saat tambah ke stage
		protected function tambahKeStage(e:Event):void
		{
			//trace(KecerdasanBuatan.levelPermainan);
			removeEventListener(Event.ADDED_TO_STAGE, tambahKeStage);
			//KecerdasanBuatan.resetKecerdasanBuatan();
			buatTempatPijak();
			buatHubunganPijak();
			buatJalur();
			buatBidak();
			resetBeberapaMovie();
			
			//kelasMacan.printPosisiBidak(bidaks);
		}
		
		
		protected function klikObjek(e:MouseEvent = null):void
		{
			menang = kelasMacan.cekMenang(kelasMacan.getBidakHidup(bidaks), pijakans);
			if (menang[0])
				tampilkanPemenang(menang[1]);
				
			resetKlikPijakBidak();
			try
			{
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
					
					// jika sebelumnya pernah memilih bidak
					if (bidakTerklik != null)
					{
						var loncat:Boolean = false;						
						if (bidakTerklik.getPijakan() != null && bidakTerklik.tipeBidak == "macan")
						{
							bidakTerloncati = kelasMacan.bidakTerloncatiMacan(bidakTerklik.getPijakan(), pijakanTerklik);
							if (bidakTerloncati.length == 2)
								loncat = true;
						}
						
						//cek langkah (bidakterpilih, pijakanterpilih, langkahke)
						var bisaMelangkah:Boolean = aturan.cekLangkah(bidakTerklik, pijakanTerklik, KelasMacan.langkahKe, bidaks);
						if (bisaMelangkah)
						{
							bidakTerloncati = kelasMacan.bidakTerloncatiMacan(bidakTerklik.getPijakan(), pijakanTerklik);
							
							aturan.setLangkah(bidakTerklik, pijakanTerklik, KelasMacan.langkahKe, bidaks); // update bidak dan pijakan
							kelasMacan.setHistoriLangkah(bidakTerklik, pijakanTerklik); // update historis
							
							//lakukan animasi							
							if (bidakTerklik.tipeBidak == "anak")
								geserBidakAnak();
							bidakTerklik.klikSaya();
							twX = new Tween(bidakTerklik, "x", Regular.easeInOut, bidakTerklik.x, pijakanTerklik.x, 10);
							twY = new Tween(bidakTerklik, "y", Regular.easeInOut, bidakTerklik.y, pijakanTerklik.y, 10);
							
							twY.addEventListener(TweenEvent.MOTION_FINISH, mulaiJalankanAI); // jika tidak loncat langsung jalankan AI
						}
						
						if (loncat) { // jika masuk loncatan
							twX.addEventListener(TweenEvent.MOTION_FINISH, pindahBidak);
							MovieClip(kotakWaktu).gotoAndPlay(1); // memberi efek ganti warna pada jam
						}
					}
				}
				else
				{
					bidakTerklik = null;
					pijakanTerklik = null;
				}
				
			}
			catch (er:Error)
			{
			}
		}
		
		/*********** AI *********/		
		protected function awalJalankanAI(e:TimerEvent):void
		{
			if (KelasMacan.thePlayer[0] == "AI")
				jalankanAI();
		}
		
		protected function mulaiJalankanAI(e:Event):void
		{
			// jika langkah selanjutnya ganjil, dan player MACAN = "AI"
			if (KelasMacan.langkahKe % 2 == 1 && KelasMacan.thePlayer[0] == "AI")
				jalankanAI();
			else if (KelasMacan.langkahKe % 2 == 0 && KelasMacan.thePlayer[1] == "AI")
				jalankanAI();
		
			//selain di atas, maka bidak macan dan manusia dijalankan oleh PLAYER
		}
		
		protected function jalankanAI(e:TweenEvent = null):void
		{
			if (menang[0]) // jika sudah ada pemenang, stop
			{
				klikObjek();
				return;
			}
			
			try
			{
				AI.mariMainkan(kelasMacan.getBidakHidup(bidaks), pijakans, KelasMacan.langkahKe);
				arrSedangJalan = AI.sedangJalan;
				
				bidakAI = arrSedangJalan[0];
				pijakanAI = arrSedangJalan[1];
				
				if (bidakAI != null && pijakanAI != null)
				{
					bidakAI.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					
					if (!bidakAI.terklik)
						jalankanAI(null);
					else
						pijakanAI.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				else
				{
					try
					{
						trace(bidakAI.getNama() + " " + pijakanAI.getNama());
					}
					catch (er:Error)
					{
						trace(bidakAI.getNama() + " kosong ");
					}
					timerAI = new Timer(200, 1);
					timerAI.addEventListener(TimerEvent.TIMER_COMPLETE, mulaiJalankanAI);
					timerAI.start();
				}
			}
			catch (er:Error)
			{
				trace(er.message);
			}
		}		
		/***** END OF AI ************/
		
		/********** INISIALISASI PAPAN DAN BIDAK *********/		
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
				
				pijakans.push(p);
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
				
				pijakans.push(pA);
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
				
				pijakans.push(pB);
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
				bidaks.push(bidA);
				parentBidak.addChild(bidA);
			}
			
			//ini untuk membuat bidak macan
			for (var b = 1; b <= KelasMacan.JUMLAH_BIDAK_MACAN; b++)
			{
				var bid:Bidak = new Bidak("macan", KelasMacan.lpad(b, 2));
				bid.x = 65 + (b * 45);
				bid.y = 555;
				bidaks.push(bid);
				parentBidak.addChild(bid);
			}
		}
		
		protected function buatHubunganPijak():void
		{
			var pX = 0;
			var pY = 0;
			// cari tiap pijakan dan hubungkan
			for (var b = 0; b < pijakans.length; b++)
			{
				pX = Pijakan(pijakans[b]).x;
				pY = Pijakan(pijakans[b]).y;
				//cari tiap pijakan lain
				for (var bx = 0; bx < pijakans.length; bx++)
				{
					// hitung selisih get by name
					var pijakanAwal:Pijakan = Pijakan(pijakans[b]);
					var pijakanAkhir:Pijakan = Pijakan(pijakans[bx]);
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
			for (var pj = 0; pj < pijakans.length; pj++)
			{
				pijakans[pj].tambahKoneksiLoncat();
			}
		
		}
		
		protected function buatJalur()
		{
			for (var i = 0; i < pijakans.length; i++)
			{
				if (Pijakan(pijakans[i]).getJumlahKoneksi() > 0)
				{
					for (var j = 0; j < Pijakan(pijakans[i]).getJumlahKoneksi(); j++)
					{
						var pKon:Pijakan = Pijakan(pijakans[i].getKoneksi()[j]);
						graphics.lineStyle(5, 0xAAAAAA);
						graphics.moveTo(pijakans[i].x, pijakans[i].y);
						graphics.lineTo(pKon.x, pKon.y);
					}
				}
			}
		}
		
		protected function geserBidakAnak():void
		{
			tween = new Array();
			var aArr:Array = new Array();
			var bidak:Array = bidaks;
			
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
		
		protected function resetBeberapaMovie():void
		{
			MovieClip(kotakChat).visible = false;
			MovieClip(kotakHistoris).visible = false;
			MovieClip(modal).visible = false;
			MovieClip(theWin).visible = false;
		}
		
		private function resetKlikPijakBidak():void
		{
			for (var p = 0; p < pijakans.length; p++)
			{
				pijakans[p].anjakKe("kosong");
			}
			for (var b1 = 0; b1 < bidaks.length; b1++)
			{
				bidaks[b1].tidakKlikSaya();
			}
		}
		
		/********** HANYA ANIMASI *********/
		private function pindahBidak(e:TweenEvent):void 
		{
			for (var bt = 0; bt < bidakTerloncati.length; bt++)
			{
				
				geserBidakAnakPasif(bidakTerloncati[bt]);
				kelasMacan.hapusBidakAktif(bidakTerloncati[bt], bidaks);
				KelasMacan.sleep(100);
			}			
		}
		
		protected function geserBidakAnakPasif(b:Bidak):void
		{
			var bidakTerakhir:Bidak = null;
			var bidak:Array = bidaks;
			
			var korX:int = 220;
			var korY:int = 555;
			for (var a = 0; a < bidak.length; a++)
			{
				if (bidak[a].tipeBidak == "anak" && bidak[a].getPijakan() == null)
					bidakTerakhir = bidak[a];
			}
			
			if (bidakTerakhir != null)
			{
				korX = bidakTerakhir.x + 45;
			}
			
			var twX:Tween = new Tween(b, "x", Regular.easeInOut, b.x, korX, 20);
			var twY:Tween = new Tween(b, "y", Regular.easeInOut, b.y, korY, 20);
			
			b.x = korX;
			b.y = korY;
		}
		
		private function tampilkanPemenang(pemenang:String):void 
		{
			timerAI.stop();
			timerClock.stop();
			timerGC.stop();
			MovieClip(modal).visible = true;
			MovieClip(theWin).visible = true;
			
			theWin.textPlayer.text = pemenang.toUpperCase();
			stage.removeEventListener(MouseEvent.CLICK, klikObjek);
			return;
		}
		
		private function klikHistori(e:MouseEvent):void
		{
			if (kotakHistoris.visible == false)
				kotakHistoris.visible = true;
			else
				kotakHistoris.visible = false;
		}
		
		/********** TIMER *********/
		protected function tambahDetik(e:TimerEvent):void
		{
			waktu++;
			(MovieClip(kotakWaktu).getChildByName("tWaktu") as TextField).text = KelasMacan.detikKeWaktu(waktu);
			KelasMacan.waktunya = KelasMacan.detikKeWaktu(waktu);
			timerClock.start();
			//adaPemenang();
		}
		
		protected function releaseGC(e:TimerEvent):void
		{
			System.gc(); // release garbage
			timerGC.start();
		}
		
	}

}

