package
{
	
	/**
	 * ...
	 * @author projo
	 */
	public class KecerdasanBuatan
	{
		public static var sedangJalan:Array; // array (bidak, pijakan)
		private static var tempJalan:Array;
		var kelasMacan:KelasMacan;
		var aturan:AturanMain;
		
		public function KecerdasanBuatan()
		{
			//sedangJalan = new Array();
			//tempJalan = new Array();
			aturan = new AturanMain();
			kelasMacan = new KelasMacan();
		}
		
		public function mariMainkan(bidakHidup:Array, pijakans:Array, langkahKe:int)
		{ // dapatkan bidak yang hidup dan pijakan untuk dibaca
			//tempJalan = new Array(kelasMacan.copyBidak(bidakHidup), kelasMacan.copyPijakan(pijakans));
			var arrJalan:Array;
			
			//var langkahSelanjutnya:int = langkahSebelum + 1; // langkah sebelumnya genap, maka prediksi selanjutnya adalah langkah ganjil
			if (langkahKe % 2 == 1 && KelasMacan.thePlayer[0] == "AI") // jika langkah ganjil
				arrJalan = mainkanMacan(bidakHidup, pijakans, langkahKe);
			if (langkahKe % 2 == 0 && KelasMacan.thePlayer[1] == "AI")
				arrJalan = mainkanAnak(bidakHidup, pijakans, langkahKe);
			
			sedangJalan = new Array(arrJalan[0], arrJalan[1]);
		
		}
		
		private function mainkanAnak(bidakHidup:Array, pijakans:Array, langkahSelanjutnya:int):Array
		{
			var b:Bidak = new Bidak();
			var p:Pijakan = new Pijakan();
			var melangkah:Array = new Array();
			var skor:Number;
			var jml:int = 0;			
			var lvl:int = KelasMacan.levelPermainanAnak - 1;			
			
			if(KelasMacan.historiLangkah.length > 8){
				if (KelasMacan.historiLangkah[langkahSelanjutnya - 2][3] == KelasMacan.historiLangkah[langkahSelanjutnya - 6][3])
					lvl = 0;
			}
			
			if (lvl == 0)
			{
				var lev0:Array = level0(bidakHidup, pijakans, 0, false);
				b = lev0[1];
				p = lev0[2];
			}
			else
			{
				var minmax:Array = MiniMax(bidakHidup, pijakans, lvl, false);
				b = kelasMacan.cariBidakByNama(minmax[1].getNama(), bidakHidup);
				p = kelasMacan.cariPijakanByNama(minmax[2].getNama(), pijakans);
			}
			
			melangkah.push(b);
			melangkah.push(p);
			
			return melangkah;
		}
		
		private function mainkanMacan(bidakHidup:Array, pijakans:Array, langkahSelanjutnya:int):Array
		{
			var b:Bidak = new Bidak();
			var p:Pijakan = new Pijakan();
			var melangkah:Array = new Array();
			var kbut:KecerdasanBuatan = new KecerdasanBuatan();
			var skor:Number;
			var jml:int;
			var lvl:int = KelasMacan.levelPermainanMacan - 1;
			
			if(KelasMacan.historiLangkah.length > 8){
				if (KelasMacan.historiLangkah[langkahSelanjutnya - 2][3] == KelasMacan.historiLangkah[langkahSelanjutnya - 6][3])
					lvl = 0;
			}
				
			if (lvl == 0)
			{
				var lev0:Array = level0(bidakHidup, pijakans, 0, true);
				b = lev0[1];
				p = lev0[2];
			}
			else
			{
				var minmax:Array = MiniMax(bidakHidup, pijakans, lvl, true);
				b = kelasMacan.cariBidakByNama(minmax[1].getNama(), bidakHidup);
				p = kelasMacan.cariPijakanByNama(minmax[2].getNama(), pijakans);
			}
			melangkah.push(b);
			melangkah.push(p);
			
			return melangkah;
		}
		
		// return [0] = score, [1] = bidak, [2] = pijakan
		protected function MiniMax(bidaks:Array, pijakans:Array, kedalaman:int, maxPlayer:Boolean = true, jmlBidTerloncati:int = 0):Array
		{
			var bids:Array = bidaks; // copy array baru dari bidaks
			var pijs:Array = pijs; // copy array baru dari pijakans
			var bidPilih:Bidak;
			var pijPilih:Pijakan;
			var tipeBidak:String;
			var langkahKe:int;
			var bidTerloncati:Array;
			var pijTerloncati:Array = new Array();
			var pijSebelum:Pijakan;
			var jmlPijBidakSebelum:int;
			var jmlPijBidakSesudah:int;
			var jmlSelisihPijBid:int;
			
			var skor:Number;
			var skorTerbaik:Number = (maxPlayer) ? Number.NEGATIVE_INFINITY : Number.POSITIVE_INFINITY;
			var menang = kelasMacan.cekMenang(bidaks, pijakans);
			
			var prediksi:Array;
			
			if (maxPlayer)
			{
				tipeBidak = "macan";
				langkahKe = 3;
			}
			else
			{
				tipeBidak = "anak";
				langkahKe = 4;
			}
			
			//jika node terakhir atau ada pemenang, lakukan evaluasi
			if (kedalaman == 0 || menang[0])
			{
				if (menang[1] == "macan")
					skor = Evaluasi(pijakans, menang[1], true);
				else if (menang[1] == "anak")
					skor = Evaluasi(pijakans, menang[1], true);
				else
					skor = Evaluasi(pijakans, menang[1], false, jmlBidTerloncati);
				
				return new Array(skor, null, null);
			}
			
			// jika ada bidak yang belum pijak
			if (kelasMacan.cekBidakBelumPijak(tipeBidak, bidaks))
			{
				bids = kelasMacan.bidakBelumPijak(tipeBidak, bidaks);				
				pijs = kelasMacan.pijakanBelumBerBidak(pijakans);
				
				for (var p = 0; p < pijs.length; p++)
				{
					if (aturan.cekLangkah(bids[0], pijs[p], langkahKe, bidaks)) // cek langkah, jika bisa
					{
						aturan.setLangkah(bids[0], pijs[p], langkahKe, bidaks);
						if (maxPlayer) // jika max player (macan)
						{
							skor = MiniMax(bidaks, pijakans, (kedalaman - 1), false)[0];
							if (skor > skorTerbaik)
							{ // jika max maka simpan bidak yang dipilih
								bidPilih = kelasMacan.copyBidak(bids[0]);
								pijPilih = kelasMacan.copyPijakan(pijs[p]);
								skorTerbaik = skor;
							}
						}
						else
						{
							skor = MiniMax(bidaks, pijakans, (kedalaman - 1), true)[0];
							if (skor < skorTerbaik)
							{ // jika min maka simpan bidak yang dipilih
								bidPilih = kelasMacan.copyBidak(bids[0]);
								pijPilih = kelasMacan.copyPijakan(pijs[p]);
								skorTerbaik = skor;
							}
						}
						aturan.setLangkah(bids[0], bids[0].getPijakanSebelum(), langkahKe, bidaks);
					}
				}
			}
			else
			{
				bids = kelasMacan.bidakHidupByTipe(tipeBidak, bidaks);
				for (var b = 0; b < bids.length; b++)
				{
					pijs = kelasMacan.koneksiValid(bids[b].getPijakan());
					for (p = 0; p < pijs.length; p++)
					{
						if (maxPlayer)
						{
							if (aturan.cekLangkah(bids[b], pijs[p], langkahKe, bidaks))
							{
								jmlPijBidakSebelum = kelasMacan.jmlPijakanBerbidak(pijakans, "anak");
								bidTerloncati = kelasMacan.bidakTerloncatiMacan(bids[b].getPijakan(), pijs[p]);
								pijTerloncati = new Array();
								if (bidTerloncati.length == 2)
								{
									for (var x = 0; x < bidTerloncati.length; x++)
									{
										pijTerloncati.push(bidTerloncati[x].getPijakan());
										bidTerloncati[x].setDisableTemp();
										pijTerloncati[x].setBidak(null);
									}
								}
								pijSebelum = bids[b].getPijakan();
								aturan.setLangkah(bids[b], pijs[p], langkahKe, bidaks);
								
								jmlPijBidakSesudah = kelasMacan.jmlPijakanBerbidak(pijakans, "anak");
								jmlSelisihPijBid = ((jmlPijBidakSebelum - jmlPijBidakSesudah) == 2) ? 2 : 0;
								
								skor = MiniMax(bidaks, pijakans, (kedalaman - 1), false, jmlSelisihPijBid)[0];
								if (skor > skorTerbaik)
								{
									bidPilih = kelasMacan.copyBidak(bids[b]);
									pijPilih = kelasMacan.copyPijakan(pijs[p]);
									skorTerbaik = skor;
								}
								// kembalikan kondisi papan seperti semula							
								if (bidTerloncati.length == 2)
								{
									for (x = 0; x < bidTerloncati.length; x++)
									{
										bidTerloncati[x].setEnable(pijTerloncati[x]);
										pijTerloncati[x].setBidak(bidTerloncati[x]);
									}
								}
								aturan.setLangkah(bids[b], pijSebelum, langkahKe, bidaks);
							}
						}
						else
						{
							pijSebelum = bids[b].getPijakan();
							if (aturan.cekLangkah(bids[b], pijs[p], langkahKe, bidaks))
							{
								aturan.setLangkah(bids[b], pijs[p], langkahKe, bidaks);
								skor = MiniMax(bidaks, pijakans, (kedalaman - 1), true)[0];
								if (skor < skorTerbaik)
								{
									bidPilih = kelasMacan.copyBidak(bids[b]);
									pijPilih = kelasMacan.copyPijakan(pijs[p]);
									skorTerbaik = skor;
								}
								aturan.setLangkah(bids[b], pijSebelum, langkahKe, bidaks);
							}
						}
					}
				}
			}
			return new Array(skorTerbaik, bidPilih, pijPilih);
		}
		
		// return [0] = pijakans, [1] = bidaks, [2] = pijakan, [3] = bidak
		protected function prediksiLangkah(bidaks:Array, pijakans:Array, tipeBidak:String = "macan"):Array
		{
			var retArr:Array = new Array();
			var langkah:int;
			var copyBidaks:Array;
			var copyPijakans:Array;
			var bidakTerloncati:Array;
			var bid:Bidak;
			var pij:Pijakan;
			
			if (tipeBidak == "macan")
				langkah = 3;
			else
				langkah = 4;
			
			if (kelasMacan.cekBidakBelumPijak(tipeBidak, bidaks))
			{
				for (var i = 0; i < 1; i++)
				{
					copyBidaks = kelasMacan.copyBidakArray(bidaks);
					for (var p = 0; p < kelasMacan.jmlPijakanBelumBerbidak(pijakans); p++)
					{
						copyPijakans = kelasMacan.copyPijakanArray(pijakans);
						
						if (aturan.cekLangkah(copyBidaks[i], copyPijakans[p], langkah, copyBidaks))
						{
							aturan.setLangkah(copyBidaks[i], copyPijakans[p], langkah, copyBidaks);
							retArr.push(new Array(copyPijakans, copyBidaks, copyPijakans[p], copyBidaks[i]));
						}
					}
				}
			}
			else
			{
				for (i = 0; i < kelasMacan.bidakHidupByTipe(tipeBidak, bidaks).length; i++)
				{
					for (p = 0; p < kelasMacan.koneksiValid(kelasMacan.bidakHidupByTipe(tipeBidak, bidaks)[i].getPijakan()).length; p++)
					{
						copyBidaks = kelasMacan.copyBidakArray(bidaks);
						bid = kelasMacan.cariBidakByNama(kelasMacan.bidakHidupByTipe(tipeBidak, bidaks)[i].getNama(), copyBidaks);
						copyPijakans = kelasMacan.copyPijakanArray(pijakans);
						pij = kelasMacan.cariPijakanByNama(kelasMacan.koneksiValid(bid.getPijakan())[p].getNama(), copyPijakans);
						
						if (aturan.cekLangkah(bid, pij, langkah, copyBidaks))
						{
							bidakTerloncati = kelasMacan.bidakTerloncatiMacan(bid.getPijakan(), pij);
							if (bidakTerloncati.length == 2)
							{
								kelasMacan.hapusBidakAktif(bidakTerloncati[0], copyBidaks);
								kelasMacan.hapusBidakAktif(bidakTerloncati[1], copyBidaks);
							}
							aturan.setLangkah(bid, pij, langkah, copyBidaks);
							retArr.push(new Array(copyPijakans, copyBidaks, pij, bid));
						}
					}
				}
			}
			
			return retArr;
		}
		
		protected function Evaluasi(pijakans:Array, tipeBidak:String, menang:Boolean = false, jmlBidTerloncati:int = 0):Number
		{
			var pijaks:Array = pijakans;
			var bidMacans:Array = kelasMacan.representasiPapan(pijaks)[0];
			var bidAnaks:Array = kelasMacan.representasiPapan(pijaks)[1];
			var nilaiMacan:Number;
			var nilaiAnak:Number;
			var nilaiTotal:Number;
			var nilaiBidTerloncati:Number = jmlBidTerloncati;
			
			if (menang)
			{
				if (tipeBidak == "macan")
				{
					nilaiTotal = 100;
				}
				else
					nilaiTotal = -100;
			}
			else
			{
				nilaiMacan = KelasMacan.BOBOT_MACAN * (bidMacans[2] + (KelasMacan.BOBOT_LONCATAN * bidMacans[3])) + KelasMacan.BOBOT_LONCATAN ^ nilaiBidTerloncati;
				nilaiAnak = KelasMacan.BOBOT_ANAK * (bidAnaks[2] + (KelasMacan.BOBOT_LONCATAN * bidAnaks[3]));
				nilaiTotal = nilaiMacan - nilaiAnak;
			}
			/*
			   trace(bidMacans[0] + ", " + bidMacans[1] + ", " + bidMacans[2] + ", " + bidMacans[3] + ", " + nilaiMacan+" bobot : "+KelasMacan.BOBOT_LONCATAN);
			   trace(bidAnaks[0] + ", " + bidAnaks[1] + ", " + bidAnaks[2] + ", " + bidAnaks[3] + ", " + nilaiAnak);
			 */
			return nilaiTotal;
		}
		
		protected function level0(bidaks:Array, pijakans:Array, kedalaman:int, maxPlayer:Boolean = true):Array
		{
			var bids:Array;
			var bidsBaru:Array;
			var pijs:Array
			var tipeBidak:String;
			var bidPilih:Bidak;
			var pijPilih:Pijakan;
			
			if (maxPlayer) // jika maxplayer
				tipeBidak = "macan";
			else
				tipeBidak = "anak";
			
			if (kelasMacan.cekBidakBelumPijak(tipeBidak, bidaks)) // jika ada bidak yang belum pijak, mainkan dulu
			{
				bids = kelasMacan.bidakBelumPijak(tipeBidak, bidaks);
				pijs = kelasMacan.pijakanBelumBerBidak(pijakans);
				bidPilih = bids[0];
				pijPilih = pijs[KelasMacan.randomAntara(0, (kelasMacan.jmlPijakanBelumBerbidak(pijakans) - 1))];
			}
			else
			{
				bidsBaru = new Array();
				bids = kelasMacan.bidakHidupByTipe(tipeBidak, bidaks); // cari tipe bidak
				for (var b = 0; b < bids.length; b++) {
					if (kelasMacan.jmlKoneksiValid(bids[b].getPijakan()) > 0) { // cari langkah valid
						bidsBaru.push(bids[b]);
					}
					else continue;
				}
				bidPilih = bidsBaru[KelasMacan.randomAntara(0, (bidsBaru.length - 1))]; // random saja pilihan bidaknya
				pijs = kelasMacan.koneksiValid(bidPilih.getPijakan());
				pijPilih = pijs[KelasMacan.randomAntara(0, (pijs.length - 1))];
			}
			
			return new Array(10, bidPilih, pijPilih); // default skor = 10
		}
		
		public static function resetKecerdasanBuatan(lvlPermainan:int = 2):void
		{
			
			KelasMacan.historiLangkah = new Array(); // hapus histori langkah
			Main.bidaks = new Array();
			Main.pijakans = new Array();
			KelasMacan.langkahKe = 1;
			sedangJalan = new Array(); // [0] = Bidak, [1] = Pijakan
			KelasMacan.setLevelPermainan(lvlPermainan); // set level permainan, jika ter-set
			
			Main.menang = new Array(false, ""); // [0] = menang (true, false), [1] = Macan / Anak
		}
	}
}