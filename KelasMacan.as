﻿package
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
		public static const JUMLAH_BIDAK_ANAK:int = 10;
		public static const JUMLAH_BIDAK_MACAN:int = 2;		
		public static const MAX_LEVEL_PERMAINAN:int = 6;
		
		public static var waktunya:String = "";
		public static var SOUND:Boolean = true;
		public static var MUSIC:Boolean = true;
		
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
		
		public static function getFolderBidak():String
		{
			return FOLDER_BIDAK;
		}
		
		public static function randomAntara(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
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
			return lpad(jam%24, 2) + ":" + lpad(menit%60, 2) + ":" + lpad(detik, 2);
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
		
		public static function semuaPijakan(p:Pijakan):Array
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
					if (KelasMacan.cekLoncatanMacan(bidak, p.getKoneksiLoncat()[x]) && p.getKoneksiLoncat()[x].getBidak() == null)
						arr.push(p.getKoneksiLoncat()[x]);
				}
			}
			return arr;
		}
		
		// untuk mengecek, apakah ada 2 bidak sejajar yang dapat diloncati
		public static function cekLoncatanMacan(b:Bidak, p:Pijakan):Boolean
		{
			if (bidakTerloncatiMacan(b.getPijakan(), p).length == 2 && b.tipeBidak == "macan")
				return true;
			else
				return false;
		}
		
		//function untuk menentukan, apakah pijakan yang dipilih terhubung dengan pijakan awal
		public static function pilihKoneksiPijak(b:Bidak, p:Pijakan):Boolean
		{
			if (b.getPijakan() != null) // jika bidak sudah memiliki pijakan sebelumnya
			{
				var jalurPijak:Array = b.getPijakan().getKoneksi();
				var jalurLoncat:Array = b.getPijakan().getKoneksiLoncat();
				
				for (var j = 0; j < b.getPijakan().getJumlahKoneksi(); j++) // jika pijakan yang dipilih merupakan salah satu pilihan pijakan
				{
					if (p == jalurPijak[j] && p.getBidak() == null)
						return true; // jika termasuk return true
				}
				
				for (var l = 0; l < b.getPijakan().getJumlahKoneksiLoncat(); l++)
				{ // jika punya loncatan
					if (p == jalurLoncat[l] && p.getBidak() == null && b.tipeBidak == "macan")
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
		
		public static function jumlahKoneksiValid(b:Bidak, pij:Array = null):int
		{
			var jml:int = KelasMacan.koneksiValid(b, pij).length;
			return jml;
		}
		
		public static function koneksiValid(b:Bidak, pij:Array = null):Array
		{
			var pijakan:Array = KecerdasanBuatan.pijakan;
			if (pij != null)
				pijakan = pij;
			
			var arr:Array = new Array();
			if (b.getPijakan() == null)
			{
				for (var p = 0; p < pijakan.length; p++)
				{
					if (pijakan[p].getBidak() == null)
						arr.push(pijakan[p]);
				}
				return pijakan;
			}
			else
			{
				for (var j = 0; j < b.getPijakan().getTotalKoneksi(); j++)
				{
					if (pilihKoneksiPijak(b, b.getPijakan().getSemuaKoneksi()[j]) == true)
						arr.push(b.getPijakan().getSemuaKoneksi()[j]);
				}
			}
			return arr;
		}
		
		public static function bidakTerloncatiMacan(pAwal:Pijakan, pAkhir:Pijakan):Array
		{
			var arrBid:Array = new Array();
			if (pAwal != null) // && pAwal.getBidak().tipeBidak == "macan" jika loncatan awal kosong, dan tipebidak macan
			{
				var arahLoncatan = "";
				var pijakan1:Pijakan = null;
				var pijakan2:Pijakan = null;
				
				for (var l = 0; l < pAwal.getJumlahKoneksiLoncat(); l++)
				{
					if (pAwal.getKoneksiLoncat()[l] == pAkhir && pAkhir.getBidak() == null)
					{
						arahLoncatan = pAwal.getArahKoneksiLoncat()[l];
					}
				}
				if (arahLoncatan == "")
					return arrBid; // jika arah loncatan nihil, maka false
				pijakan1 = pAwal.getKoneksiPijakByArah(pAwal, arahLoncatan);
				if (pijakan1.getBidak() == null)
					return arrBid;
				else if (pijakan1.getBidak().tipeBidak == "macan")
					return arrBid;
				else
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
		
		// set bidakAktif ataupun bidakPasif aktif maupun temporer
		public static function hapusBidakAktif(b:Bidak, bidA:Array = null, bidP:Array = null):void
		{
			var bidakAktif:Array = KecerdasanBuatan.bidakAktif;
			var bidakPasif:Array = KecerdasanBuatan.bidakPasif;
			if (bidA != null)
			{
				bidakAktif = bidA;
			}
			if (bidP != null)
			{
				bidakPasif = bidP;
			}
			for (var i = 0; i < bidakAktif.length; i++)
			{
				if (bidakAktif[i] == b)
				{
					bidakAktif.splice(i, 1);
					bidakPasif.push(b);
				}
			}
		}
		
		// melihat pijakan yang belum berbidak, berdasarkan pijakan aktif atau temporer
		public static function pijakanBelumBerBidak(pij:Array = null):Array
		{
			var pijakan:Array = KecerdasanBuatan.pijakan;
			if (pij != null)
				pijakan = pij;
			var perpijakan:Array = new Array();
			for (var p = 0; p < pijakan.length; p++)
			{
				if (pijakan[p].getBidak() == null)
					perpijakan.push(pijakan[p]);
			}
			
			return perpijakan;
		}
		
		// mengubah kumpulan bidak aktif, pijakan dan bidak pasif menjadi node, [0] = BidakAktif [1] = Pijakan [2] = bidakPasif
		//yang nantinya akan diproses oleh kecerdasan buatan
		public static function bidakPijakanKeNode(bidakAktif:Array, pijakan:Array, bidakPasif:Array = null):Array
		{
			var node:Array = new Array();
			node.push(bidakAktif);
			node.push(pijakan);
			node.push(bidakPasif);
			
			return node;
		}
		
		public static function cariBidakByNama(namaBidak:String, bidaks:Array = null):Bidak {
			var b:Bidak = new Bidak();
			for (var i = 0; i < bidaks.length; i++) {
				if (bidaks[i].getNama() == namaBidak)
					b=bidaks[i];
				else continue;
			}
			return b;
		}
	
	/*public static function bandingPijakan(pijFilter:Pijakan, pijSumber:Array = null):Pijakan {
	   var pijakan:Array = KecerdasanBuatan.pijakan;
	   if (pijSumber != null)
	   pijakan = pijSumber;
	
	   for (var p = 0; p < pijakan.length; p++) {
	   if (bandingPijakan(pijFilter, pijakan[p]))
	   return pijakan[p] as Pijakan;
	   }
	
	   return new Pijakan();
	   }
	
	   public static function bandingPijakan(pijFilter:Pijakan, pijUtama:Pijakan):Boolean {
	   if (pijFilter.getNama() == pijUtama.getNama())
	   return true;
	   else
	   return false;
	 }*/ /*public static function bandingBidak(bidFilter:Bidak, bidSumber:Array = null):Bidak {
	   var bidak:Array = KecerdasanBuatan.bidakAktif;
	   if (bidSumber != null)
	   bidak = bidSumber;
	   for (var b = 0; b < bidak.length; b++) {
	   if (bandingBidak(bidFilter, bidak[b] as Bidak))
	   return bidak[b];
	   }
	
	   //return new Bidak();
	   }
	
	   public static function bandingBidak(bidFilter:Bidak, bidUtama:Bidak):Boolean {
	   if (bidFilter.getNama() == bidUtama.getNama())
	   return true;
	   else
	   return false;
	   }
	 */
	}

}