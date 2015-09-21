package
{
	
	/**
	 * ...
	 * @author projo
	 */
	public class KecerdasanBuatan
	{
		public var sedangJalan:Array; // array (bidak, pijakan)
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
			
			sedangJalan = new Array(arrJalan[0],arrJalan[1]);
		
		}
		
		private function mainkanAnak(bidakHidup:Array, pijakans:Array, langkahSelanjutnya:int):Array
		{
			var b:Bidak = new Bidak();
			var p:Pijakan = new Pijakan();
			var melangkah:Array = new Array();
			var skor:Number;
			var jml:int = 0;
			
			/*jml = kelasMacan.bidakBelumPijak("anak", bidakHidup).length;
			if (jml > 0)
			{
				b = kelasMacan.bidakBelumPijak("anak", bidakHidup)[KelasMacan.randomAntara(0, (jml - 1))];
				jml = kelasMacan.jmlPijakanBelumBerbidak(pijakans);
				p = kelasMacan.pijakanBelumBerBidak(pijakans)[KelasMacan.randomAntara(0, (jml - 1))];
			}
			else
			{
				jml = kelasMacan.bidakHidupByTipe("anak", bidakHidup).length;
				b = kelasMacan.bidakHidupByTipe("anak", bidakHidup)[KelasMacan.randomAntara(0, (jml - 1))];
				jml = kelasMacan.jmlPijakanBelumBerbidak(pijakans);
				p = kelasMacan.pijakanBelumBerBidak(pijakans)[KelasMacan.randomAntara(0, (jml - 1))];
			}*/
			
			var minmax:Array = MiniMax(bidakHidup, pijakans, KelasMacan.levelPermainan, false);
			b = kelasMacan.cariBidakByNama(minmax[1].getNama(), bidakHidup);
			p = kelasMacan.cariPijakanByNama(minmax[2].getNama(), pijakans);
			
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
			
			if (langkahSelanjutnya == 1)
			{
				b = kelasMacan.bidakBelumPijak("macan", bidakHidup)[0];
				p = kelasMacan.pijakanBelumBerBidak(pijakans)[KelasMacan.randomAntara(0, kelasMacan.jmlPijakanBelumBerbidak(pijakans) - 1)];
			}
			else if (langkahSelanjutnya == 3)
			{
				//trace(kelasMacan.bidakBelumPijak("macan", bidakHidup));
				b = kelasMacan.bidakBelumPijak("macan", bidakHidup)[0];
				p = kelasMacan.pijakanBelumBerBidak(pijakans)[KelasMacan.randomAntara(0, kelasMacan.jmlPijakanBelumBerbidak(pijakans) - 1)];
			}
			else
			{
				var minmax:Array = MiniMax(bidakHidup, pijakans, KelasMacan.levelPermainan, true);
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
			
			//jika node terakhir atau ada pemenang
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
					//trace(bids[0].getNama() + " "+pijs[p].getNama());
					if (aturan.cekLangkah(bids[0], pijs[p], langkahKe, bidaks))
					{
						aturan.setLangkah(bids[0], pijs[p], langkahKe, bidaks);
						if (maxPlayer)
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
							//trace(skor);
							if (skor < skorTerbaik)
							{ // jika max maka simpan bidak yang dipilih
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
								if (bidTerloncati.length == 2) {
									for (var x = 0; x < bidTerloncati.length; x ++) {
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
								if (skor > skorTerbaik){
									bidPilih = kelasMacan.copyBidak(bids[b]);
									pijPilih = kelasMacan.copyPijakan(pijs[p]);
									skorTerbaik = skor;
								}
								// kembalikan kondisi papan seperti semula							
								if (bidTerloncati.length == 2) {
									for (x = 0; x < bidTerloncati.length; x++) {
										bidTerloncati[x].setEnable(pijTerloncati[x]);
										pijTerloncati[x].setBidak(bidTerloncati[x]);
									}
								}
								aturan.setLangkah(bids[b], pijSebelum, langkahKe, bidaks);	
							}
						}
						else
						{
							if (aturan.cekLangkah(bids[b], pijs[p], langkahKe, bidaks)) {
								aturan.setLangkah(bids[b], pijs[p], langkahKe, bidaks);						
								skor = MiniMax(bidaks, pijakans, (kedalaman - 1), true)[0];
								if (skor < skorTerbaik){
									bidPilih = kelasMacan.copyBidak(bids[b]);
									pijPilih = kelasMacan.copyPijakan(pijs[p]);
									skorTerbaik = skor;
								}
								aturan.setLangkah(bids[b], bids[b].getPijakanSebelum(), langkahKe, bidaks);
							}
						}
					}
				}
				
				//kelasMacan.printPosisiBidak(bidaks);
			}
			trace(bidPilih.getNama() + " " + pijPilih.getNama());
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
			
			for (i = 0; i < retArr.length; i++)
			{
				trace(retArr[i][3].getNama() + " " + retArr[i][2].getNama());
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
			
			/*
			 * z = x(a+2b)+x(c+2d)
			 * z = x((a+2b) + (c+2d))
			 * z = x((a+c+(2(b+d));
			 * */
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
				//trace(bidMacans[2]);
				//trace(bidAnaks[2]);
				nilaiMacan = KelasMacan.BOBOT_MACAN * (bidMacans[2] + (KelasMacan.BOBOT_LONCATAN * bidMacans[3])) + nilaiBidTerloncati * 100;
				nilaiAnak = KelasMacan.BOBOT_ANAK * (bidAnaks[2] + (KelasMacan.BOBOT_LONCATAN * bidAnaks[3]));
				nilaiTotal = nilaiMacan - nilaiAnak;
			}
			
			//trace(KecerdasanBuatan.langkahKe);
			trace("---------");			
			trace(bidMacans[0] + ", " + bidMacans[1] + ", " + bidMacans[2] + ", " + bidMacans[3] + ", " + nilaiMacan+" bobot : "+KelasMacan.BOBOT_LONCATAN);
			trace(bidAnaks[0] + ", " + bidAnaks[1] + ", " + bidAnaks[2] + ", " + bidAnaks[3] + ", " + nilaiAnak);
			
			//trace(nilaiTotal);
			return nilaiTotal;
		}
	}
}