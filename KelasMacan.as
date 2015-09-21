package
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author projo
	 */
	public class KelasMacan
	{
		
		public static const FOLDER_BIDAK:String = "gambar/bidak/";
		public static const FOLDER_SOUND:String = "sound/";
		public static const JUMLAH_BIDAK_ANAK:int = 10;
		public static const JUMLAH_BIDAK_MACAN:int = 2;
		public static const MAX_LEVEL_PERMAINAN:int = 3;
		
		public static var thePlayer:Array = new Array("AI", "AI"); // SET "PLAYER" ATAU "AI" [0] = MACAN, [1] = ANAK
		public static var levelPermainanMacan:int = 3; // set level macan = 1
		public static var levelPermainanAnak:int = 3; // SET level anak = 3
		
		public static const BOBOT_MACAN:int = 5;
		public static const BOBOT_ANAK:int = 2;
		public static const BOBOT_LONCATAN:int = 8;
		
		public static var waktunya:String = "";
		public static var SOUND:Boolean = true;
		public static var MUSIC:Boolean = true;
		
		public static var langkahKe:int = 1;
		public static var historiLangkah:Array = new Array(); //[0] = langkah ke, [1] = waktu (int), [2] = waktu (detik, menit), [3] = pijakan, [4] = bidak
		
		private var arrBaru:Array = new Array();
		
		public function KelasMacan()
		{
		
		}
		
		public static function lpad(number:int, width:int):String
		{
			var ret:String = "" + number;
			while (ret.length < width)
				ret = "0" + ret;
			return ret;
		}
		
		public static function randomAntara(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		public static function sleep(ms:int):void
		{
			var init:int = getTimer();
			while (true)
			{
				if (getTimer() - init >= ms)
				{
					break;
				}
			}
		}
		
		public static function average(... args)
		{
			var sum:Number = 0;
			for (var i = 0; i < args.length; i++)
			{
				sum += args[i];
			}
			return sum / args.length;
		}
		
		public static function getArahLawan(arah:String = "N"):String
		{
			var arahBerlawanan:String = null;
			switch (arah)
			{
				case "N": 
					arahBerlawanan = "S";
					break;
				case "NE": 
					arahBerlawanan = "SW";
					break;
				case "E": 
					arahBerlawanan = "W";
					break;
				case "SE": 
					arahBerlawanan = "NW";
					break;
				case "S": 
					arahBerlawanan = "N";
					break;
				case "SW": 
					arahBerlawanan = "NE";
					break;
				case "W": 
					arahBerlawanan = "E";
					break;
				case "NW": 
					arahBerlawanan = "SE";
					break;
				default: 
					arahBerlawanan = null;
					break;
			}
			return arahBerlawanan;
		}
		
		public static function detikKeWaktu(s:int):String
		{
			var detik:int = 0;
			var menit:int = 0;
			var jam:int = 0;
			
			jam = (s / 3600) >= 1 ? Math.floor(s / 3600) : 0;
			menit = (s / 60) >= 1 ? Math.floor(s / 60) : 0;
			detik = (s % 60);
			return lpad(jam % 24, 2) + ":" + lpad(menit % 60, 2) + ":" + lpad(detik, 2);
		}
		
		public static function setLevelPermainan(lev:int = 1):void
		{
			if (lev > KelasMacan.MAX_LEVEL_PERMAINAN){
				levelPermainanAnak = KelasMacan.MAX_LEVEL_PERMAINAN;
				levelPermainanMacan = KelasMacan.MAX_LEVEL_PERMAINAN;
			}
			else{
				levelPermainanAnak = KelasMacan.MAX_LEVEL_PERMAINAN;
				levelPermainanMacan = KelasMacan.MAX_LEVEL_PERMAINAN;
			}
		}
		
		public static function setPlayer(player1:String = "AI", player2:String = "PLAYER") {
			KelasMacan.thePlayer[0] = player1;
			KelasMacan.thePlayer[1] = player2;
		}
		
		public function setHistoriLangkah(b:Bidak, p:Pijakan):void
		{
			historiLangkah.push(new Array(langkahKe, new Date().getTime(), KelasMacan.waktunya, p, b));
			langkahKe++;
			//trace((historiLangkah.length) + " | " + KelasMacan.waktunya + " | " + p.getNama() + " | " + b.getNama());
		}
		
		// return true jika ada bidak yang belum memiliki pijakan
		public function cekBidakBelumPijak(tipeBidak:String, bidaks:Array):Boolean
		{
			if (bidakBelumPijak(tipeBidak, bidaks).length > 0)
				return true;
			else
				return false;
		}
		
		// ambil bidak yang belum memiliki pijakan, berdasarkan tipe bidak
		public function bidakBelumPijak(tipeBidak:String, bidaks:Array):Array
		{
			var retArr:Array = new Array();
			for (var b = 0; b < bidaks.length; b++)
			{
				// jika tipe bidak sama, dan status = true, dan belum dapat pijakan, maka simpan
				if (tipeBidak == bidaks[b].tipeBidak && bidaks[b].status && bidaks[b].getPijakan() == null)
				{
					retArr.push(bidaks[b]);
				}
			}
			return retArr;
		}
		
		// ambil bidak yang belum memiliki pijakan, berdasarkan tipe bidak
		public function bidakHidupByTipe(tipeBidak:String, bidakHidup:Array):Array
		{
			var retArr:Array = new Array();
			for (var b = 0; b < bidakHidup.length; b++)
			{
				// jika tipe bidak sama, dan status = true, dan belum dapat pijakan, maka simpan
				if (tipeBidak == bidakHidup[b].tipeBidak && bidakHidup[b].status)
				{
					retArr.push(bidakHidup[b]);
				}
			}
			return retArr;
		}
		
		// get bidak dengan status true
		public function getBidakHidup(bidaks:Array):Array
		{
			var arr:Array = new Array();
			for (var b = 0; b < bidaks.length; b++)
			{
				if (bidaks[b].status)
				{
					arr.push(bidaks[b]);
				}
			}
			return arr;
		}
		
		// get bidak dengan status false
		public function getBidakMati(bidaks:Array):Array
		{
			var arr:Array = new Array();
			for (var b = 0; b < bidaks.length; b++)
			{
				if (!bidaks[b].status)
				{
					arr.push(bidaks[b]);
				}
			}
			return arr;
		}
		
		// ambil semua pijakan yang terhubung
		public function semuaPijakan(p:Pijakan):Array
		{
			var arr:Array = new Array();
			var bidak:Bidak = p.getBidak();
			for (var i = 0; i < p.getJumlahKoneksi(); i++)
			{
				if (p.getKoneksi()[i].getBidak() == null)
					arr.push(p.getKoneksi()[i]);
			}
			if (bidak != null && bidak.tipeBidak == "macan")
			{
				for (var x = 0; x < p.getJumlahKoneksiLoncat(); x++)
				{
					if (cekLoncatanMacan(bidak, p.getKoneksiLoncat()[x]) && p.getKoneksiLoncat()[x].getBidak() == null)
						arr.push(p.getKoneksiLoncat()[x]);
				}
			}
			return arr;
		}
		
		// ambil pijakan yang belum memiliki bidak
		public function pijakanBelumBerBidak(pij:Array):Array
		{
			var perpijakan:Array = new Array();
			for (var p = 0; p < pij.length; p++)
			{
				if (pij[p].getBidak() == null)
					perpijakan.push(pij[p]);
			}
			return perpijakan;
		}
		
		// ambil jumlah pijakan yang belum memiliki bidak
		public function jmlPijakanBelumBerbidak(pij:Array):int
		{
			return pijakanBelumBerBidak(pij).length;
		}
		
		public function jmlPijakanBerbidak(pij:Array, tipeBidak:String = "semua"):int {
			var jml:int = 0;
			for (var p = 0; p < pij.length; p++) {
				if (tipeBidak == "semua" && pij[p].getBidak() != null)
					jml++;
				else if (pij[p].getBidak() != null && pij[p].getBidak().tipeBidak == tipeBidak)
					jml++;
			}
			return jml;
		}
		
		// ambil pijakan yang terhubung, dengan bidak null;
		public function pijakanKoneksi(p:Pijakan, tipeBidak:String = "semua"):Array
		{
			var arr:Array = new Array();
			for (var i = 0; i < p.getJumlahKoneksi(); i++)
			{
				if (tipeBidak == "semua")
				{
					if (p.getKoneksi()[i].getBidak() == null)
						arr.push(p.getKoneksi()[i]);
					
				}
				else
				{
					if (p.getBidak().tipeBidak == tipeBidak)
					{
						if (p.getKoneksi()[i].getBidak() == null)
							arr.push(p.getKoneksi()[i]);
					}
					else
						continue;
				}
			}
			return arr;
		}
		
		//ambil koneksi loncatan dengan bidak null
		public function pijakanLoncat(p:Pijakan):Array
		{
			var arr:Array = new Array();
			var bidak:Bidak = p.getBidak();
			if (bidak != null && bidak.tipeBidak == "macan")
			{
				for (var x = 0; x < p.getJumlahKoneksiLoncat(); x++)
				{
					if (cekLoncatanMacan(bidak, p.getKoneksiLoncat()[x]) && p.getKoneksiLoncat()[x].getBidak() == null)
						arr.push(p.getKoneksiLoncat()[x]);
				}
			}
			
			return arr;
		}
		
		//ambil koneksi valid pijakan
		public function koneksiValid(p:Pijakan):Array
		{
			if (p == null)
				return new Array();
			var arr:Array = (p.getBidak().tipeBidak == "macan") ? pijakanKoneksi(p).concat(pijakanLoncat(p)) : pijakanKoneksi(p);
			return arr;
		}
		
		public function jmlKoneksiValid(p:Pijakan):int
		{
			return koneksiValid(p).length;
		}
		
		// untuk mengecek, apakah ada 2 bidak sejajar yang dapat diloncati
		public function cekLoncatanMacan(b:Bidak, p:Pijakan):Boolean
		{
			if (bidakTerloncatiMacan(b.getPijakan(), p).length == 2 && b.tipeBidak == "macan")
				return true;
			else
				return false;
		}
		
		//function untuk menentukan, apakah pijakan yang dipilih terhubung dengan pijakan awal
		public function pilihKoneksiPijak(b:Bidak, p:Pijakan):Boolean
		{
			if (b.getPijakan() != null) // jika bidak sudah memiliki pijakan sebelumnya
			{
				var jalurPijak:Array = b.getPijakan().getKoneksi();
				var jalurLoncat:Array = b.getPijakan().getKoneksiLoncat();
				
				for (var j = 0; j < b.getPijakan().getJumlahKoneksi(); j++) // jika pijakan yang dipilih merupakan salah satu pilihan pijakan
				{
					if (p.getNama() == jalurPijak[j].getNama() && p.getBidak() == null)
						return true; // jika termasuk return true
				}
				
				for (var l = 0; l < b.getPijakan().getJumlahKoneksiLoncat(); l++)
				{ // jika punya loncatan
					if (p.getNama() == jalurLoncat[l].getNama() && p.getBidak() == null && b.tipeBidak == "macan")
					{ // cek loncatan
						return cekLoncatanMacan(b, p);
					}
				}
				return false; // jika tidak return false
			}
			else // jika bidak belum memiliki pijakan
			{
				return true;
			}
		}
		
		//ambil bidak yang terloncati macan
		public function bidakTerloncatiMacan(pAwal:Pijakan, pAkhir:Pijakan):Array
		{
			var arrBid:Array = new Array();
			if (pAwal != null) // && pAwal.getBidak().tipeBidak == "macan" jika loncatan awal kosong, dan tipebidak macan
			{
				var arahLoncatan = "";
				var pijakan1:Pijakan = null;
				var pijakan2:Pijakan = null;
				
				for (var l = 0; l < pAwal.getJumlahKoneksiLoncat(); l++)
				{
					if (pAwal.getKoneksiLoncat()[l].getNama() == pAkhir.getNama() && pAkhir.getBidak() == null)
					{
						arahLoncatan = pAwal.getArahKoneksiLoncat()[l];
					}
				}
				if (arahLoncatan == "")
					return arrBid; // jika arah loncatan nihil, maka false
				pijakan1 = pAwal.getKoneksiPijakByArah(pAwal, arahLoncatan);
				if (pijakan1.getBidak() == null) // jika pijakan pertama null, maka gagal
					return arrBid;
				else if (pijakan1.getBidak().tipeBidak == "macan") // jika ada bidak, namun macan, maka gagal
					return arrBid;
				else // selain itu cek kembali untuk pijakan kedua
				{
					arrBid.push(pijakan1.getBidak());
					pijakan2 = pijakan1.getKoneksiPijakByArah(pijakan1, arahLoncatan);
					if (pijakan2.getBidak() == null)
						return arrBid;
					else if (pijakan2.getBidak().tipeBidak == "macan")
						return arrBid;
					else
					{
						arrBid.push(pijakan2.getBidak());
						//trace(pijakan1.getNama() + " " + pijakan1.getBidak().getNama() + " " + pijakan2.getNama() + " " + pijakan2.getBidak().getNama());
						return arrBid;
					}
				}
			}
			return arrBid;
		}
		
		// mengubah kumpulan bidak aktif, pijakan dan bidak pasif menjadi node, [0] = BidakAktif [1] = Pijakan [2] = bidakPasif
		//yang nantinya akan diproses oleh kecerdasan buatan
		public function bidakPijakanKeNode(bidakAktif:Array, pijakan:Array, bidakPasif:Array = null):Array
		{
			var node:Array = new Array();
			node.push(bidakAktif);
			node.push(pijakan);
			node.push(bidakPasif);
			
			return node;
		}
		
		//cari bidak berdasarkan nama
		public function cariBidakByNama(namaBidak:String, bidaks:Array = null):Bidak
		{
			var b:Bidak;
			for (var i = 0; i < bidaks.length; i++)
			{
				if (bidaks[i].getNama() == namaBidak)
				{
					b = bidaks[i];
					break;
				}
				
			}
			return b;
		}
		
		//cari pijakan berdasarkan nama
		public function cariPijakanByNama(namaPijak:String, pijakans:Array):Pijakan
		{
			var p:Pijakan;
			for (var i = 0; i < pijakans.length; i++)
			{
				if (pijakans[i].getNama() == namaPijak)
				{
					p = pijakans[i];
					break;
				}
			}
			return p;
		}
		
		public function ekstrakBidakDariPijakan(pijakans:Array):Array {
			var arr:Array = new Array();
			for (var i = 0; i < pijakans.length; i++) {
				if (pijakans[i].getBidak() != null) {
					arr.push(pijakans[i].getBidak());
				}
				continue;
			}
			return arr;
		}
		
		/*return array[0] => array ("M", jmlbidakmacan, jmlkoneksi, jmlloncatan);
		 return array[1] => array ("O", jmlbidakmacan, jmlkoneksi, jmlloncatan);*/
		public function representasiPapan(pijakans:Array):Array
		{
			//KecerdasanBuatan.pijakan[0].setText("gundul");
			var sBidMacan:String = "M";
			var jmlBidMacan:int = 0;
			var jmlKoneksiMacan:int = 0;
			var jmlLoncatMacan:int = 0;
			var sBidAnak:String = "O";
			var jmlBidAnak:int = 0;
			var jmlKoneksiAnak:int = 0;
			
			for (var p = 0; p < pijakans.length; p++)
			{
				//trace(pijakans[p].getBidak().getNama()+ " "+pijakans[p].getNama());
				if (pijakans[p].getBidak() != null)
				{
					//trace(pijakans[p].getBidak().getNama()+ " "+pijakans[p].getNama());
					if (pijakans[p].getBidak().tipeBidak == "macan")
					{
						jmlBidMacan++;
						jmlKoneksiMacan += pijakanKoneksi(pijakans[p], "macan").length;
						jmlLoncatMacan += pijakanLoncat(pijakans[p]).length;
					}
					else
					{
						jmlBidAnak++;
						jmlKoneksiAnak += pijakanKoneksi(pijakans[p], "anak").length;
					}
				}
			}
			
			var bidMacans:Array = new Array(sBidMacan, jmlBidMacan, jmlKoneksiMacan, jmlLoncatMacan);
			var bidAnaks:Array = new Array(sBidAnak, jmlBidAnak, jmlKoneksiAnak, 0);
			var retArr:Array = new Array();
			retArr.push(bidMacans);
			retArr.push(bidAnaks);
			
			return retArr;
		
		/*trace(KecerdasanBuatan.langkahKe);
		   trace(sBidMacan+", "+jmlBidMacan+", "+jmlKoneksiMacan+", "+jmlLoncatMacan);
		   trace(sBidAnak+", "+jmlBidAnak+", "+jmlKoneksiAnak+", 0");
		 */
			 //return "y";
		}
		
		public function copyArray(arrayStatic:Array):Array
		{
			var arrBaru:Array = new Array();
			
			for (var i = 0; i < arrayStatic.length; i++)
			{
				arrBaru.push(arrayStatic[i]);
			}
			return arrBaru;
		}
		
		// copy array bidak ke array yang baru
		public function copyBidakArray(bidaks:Array):Array
		{
			var arrBaru:Array = new Array();
			for (var i = 0; i < bidaks.length; i++)
			{
				var o:Bidak = new Bidak;
				o.tipeBidak = bidaks[i].tipeBidak;
				o.status = bidaks[i].status;
				o.pijakan = bidaks[i].pijakan;
				o.pijakanSebelum = bidaks[i].pijakanSebelum;
				o.nama = bidaks[i].nama;
				
				arrBaru.push(o);
			}
			return arrBaru;
		}
		
		public function copyBidak(bidak:Bidak):Bidak
		{
			var o:Bidak = new Bidak;
			o.tipeBidak = bidak.tipeBidak;
			o.status = bidak.status;
			o.pijakan = bidak.pijakan;
			o.pijakanSebelum = bidak.pijakanSebelum;
			o.nama = bidak.nama;
			return o;
		}
		
		// copy array pijakan ke array yang baru
		public function copyPijakanArray(pijakans:Array):Array
		{
			var arrBaru:Array = new Array();
			for (var i = 0; i < pijakans.length; i++)
			{
				var o:Pijakan = new Pijakan();
				o.koneksiPijakan = pijakans[i].koneksiPijakan;
				o.arahPijakan = pijakans[i].arahPijakan;
				o.koneksiLoncat = pijakans[i].koneksiLoncat;
				o.arahLoncat = pijakans[i].arahLoncat;
				
				o.bidak = pijakans[i].bidak;
				o.nama = pijakans[i].nama;
				arrBaru.push(o);
			}
			return arrBaru;
		}
		
		public function copyPijakan(pijakan:Pijakan):Pijakan {
			var o:Pijakan = new Pijakan();
			o.koneksiPijakan = pijakan.koneksiPijakan;
			o.arahPijakan = pijakan.arahPijakan;
			o.koneksiLoncat = pijakan.koneksiLoncat;
			o.arahLoncat = pijakan.arahLoncat;
			
			o.bidak = pijakan.bidak;
			o.nama = pijakan.nama;
			return o;
		}
		
		// set bidakAktif ataupun bidakPasif aktif maupun temporer
		public function hapusBidakAktif(b:Bidak, bidaks:Array):void
		{
			b.setDisable();
			b.getPijakanSebelum().setBidak(null);
			
			for (var i = 0; i < bidaks.length; i++)
			{
				if (bidaks[i] == b)
				{
					bidaks.splice(i, 1);
					bidaks.push(b);
				}
			}
		}
		
		public function tambahBidakAktif(b:Bidak, bidaks:Array, p:Pijakan):void
		{
			p.setBidak(b);
			b.setEnable(p);
			//bidaks.push(b);
		}
		
		// cek pemenang berdasarkan papan dan bidak yang masih hidup
		// [0] = true/false, [1] = tipeBidak
		public function cekMenang(bidakHidup:Array, pijakans:Array):Array
		{
			var jmlLangkahMacan:int = 0;
			jmlLangkahMacan += jmlKoneksiValid(bidakHidupByTipe("macan", bidakHidup)[0].getPijakan());
			jmlLangkahMacan += jmlKoneksiValid(bidakHidupByTipe("macan", bidakHidup)[1].getPijakan());
			
			if (jmlLangkahMacan == 0 && KelasMacan.langkahKe > 3)
				return new Array(true, "anak");
			if (cekBidakBelumPijak("anak", bidakHidup))
				return new Array(false, null);			
			if (bidakHidupByTipe("anak", bidakHidup).length <= 4)
				return new Array(true, "macan");
			
			return new Array(false, null);		
		}
		
		public function printPosisiBidak(bidaks:Array) {
			for each (var b in bidaks) {
				trace(b.getNama() + " " + b.status + " " + ((b.getPijakan() != null) ? b.pijakan.nama : "kosong"));
			}
		}
		
		public function jmlLangkahTipeBidak(tipeBidak:String = "macan") {
			return Math.ceil(KelasMacan.langkahKe / 2);
		}
		
		public function jmlLangkahSama(tipeBidak:String = "macan") {
			var jml:int = 0;
			for (var i = 0; i < KelasMacan.langkahKe; i++) {
				
			}
			return jml;
		}
	}

}