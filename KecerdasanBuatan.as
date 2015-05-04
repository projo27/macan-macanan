package
{
	import flash.display.MovieClip;
		
	/**
	 * ...
	 * @author projo
	 */
	public class KecerdasanBuatan
	{
		public static var historiLangkah:Array = new Array();
		public static var bidakAktif:Array = new Array();
		public static var bidakPasif:Array = new Array();
		public static var pijakan:Array = new Array();
		public static var langkahKe:int = historiLangkah.length;
		public static var thePlayer:Array = new Array("AI", "AI"); // SET "PLAYER" ATAU "AI" [0] = MACAN, [1] = ANAK
		public static var sedangJalan:Array = new Array(); // [0] = Bidak, [1] = Pijakan
		public static var levelPermainan:int = 1;
		
		public static var arrayMenang:Array = new Array(false, ""); // [0] = menang (true, false), [1] = Macan / Anak
		
		public static var tempPijakan:Array = new Array();
		public static var tempBidakAktif:Array = new Array();
		public static var tempBidakPasif:Array = new Array();
		
		
		
		public static const MAX_LEVEL_PERMAINAN:int = 3;
		
		public function KecerdasanBuatan()
		{
			//historiLangkah = new Array();
		}
		
		public static function getHistoriLangkah():Array
		{
			return historiLangkah;
		}
		
		public static function setLevelPermainan(lev:int = 1):void {
			if (lev > MAX_LEVEL_PERMAINAN) 
				levelPermainan = MAX_LEVEL_PERMAINAN;
			else levelPermainan = lev;
		}
		
		public static function setHistoriLangkah(b:Bidak, p:Pijakan):void
		{
			historiLangkah.push(new Array((historiLangkah.length + 1), new Date().getTime(),KelasMacan.waktunya, p, b));
			//trace(historiLangkah[historiLangkah.length-1]);			
			trace((historiLangkah.length) + " | " +KelasMacan.waktunya+" | "+ p.getNama() + " | " + b.getNama());
		}
		
		//parameter bid = bidakAktif, atau tempBidakAktif
		public static function cekBidakBelumPijak(bid:Array = null):Array
		{
			var bidaks:Array = bidakAktif;
			if (bid != null)
				bidaks = bid;
				
			var bidakBelumPijak:Array = new Array();
			for (var b = 0; b < bidaks.length; b++)
			{
				if (Bidak(bidaks[b]).getPijakan() == null)
				{
					bidakBelumPijak.push(bidaks[b]);
				}
			}
			return bidakBelumPijak;
		}
		
		public static function cekBidakMacanBelumPijak(bid:Array = null):Array
		{
			var bidakMacanBelumPijak:Array = new Array();
			for (var m = 0; m < cekBidakBelumPijak(bid).length; m++)
			{
				if (Bidak(cekBidakBelumPijak(bid)[m]).tipeBidak == "macan")
				{
					bidakMacanBelumPijak.push(cekBidakBelumPijak(bid)[m]);
				}
			}
			return bidakMacanBelumPijak;
		}
		
		public static function cekBidakAnakBelumPijak(bid:Array = null):Array
		{
			var bidakAnakBelumPijak:Array = new Array();
			for (var m = 0; m < cekBidakBelumPijak(bid).length; m++)
			{
				if (Bidak(cekBidakBelumPijak(bid)[m]).tipeBidak == "anak")
				{
					bidakAnakBelumPijak.push(cekBidakBelumPijak(bid)[m]);
				}
			}
			return bidakAnakBelumPijak;
		}
		
		public static function bidakMacanAktif(bid:Array = null):Array
		{
			var bidaks:Array = bidakAktif;
			if (bid != null)
				bidaks = bid;
			var arrB:Array = new Array();
			for (var b = 0; b < bidaks.length; b++)
			{
				if (bidaks[b].tipeBidak == "macan")
					arrB.push(bidaks[b]);
			}
			return arrB;
		}
		
		public static function bidakAnakAktif(bid:Array = null):Array
		{
			var bidaks:Array = bidakAktif;
			if (bid != null)
				bidaks = bid;
			var arrB:Array = new Array();
			for (var b = 0; b < bidaks.length; b++)
			{
				if (bidaks[b].tipeBidak == "anak")
					arrB.push(bidaks[b]);
			}
			return arrB;
		}
		
		public static function hitungLangkahBidak(b:Bidak):int
		{
			var score = 0;
			
			if (b.tipeBidak == "macan")
			{
				//score = KelasMacan.jumlahKoneksiValid(b) + KelasMacan.bidakTerloncatiMacan(b.getPijakan(), p).length;
				score = KelasMacan.jumlahKoneksiValid(b);
			}
			else
				score = KelasMacan.jumlahKoneksiValid(b);
			return score;
		}
		
		public static function getPlayerMacan():String
		{
			return thePlayer[0]; // dapatkan player 1
		}
		
		public static function getPlayerAnak():String
		{
			return thePlayer[1]; // dapatkan player 2
		}
		
		public static function mariMainkan():void
		{
			sedangJalan = new Array(null, null);
			if (historiLangkah.length % 2 == 0 && getPlayerMacan() == "AI") // jika langkah ganjil dan player macan = AI
				sedangJalan = jalankanMacan();
			else if (historiLangkah.length % 2 == 1 && getPlayerAnak() == "AI") // jika langkah genap dan player anak = AI
				sedangJalan = jalankanAnak();
		}
		
		public static function jalankanMacan():Array
		{
			var b:Bidak = new Bidak();
			var p:Pijakan = new Pijakan();
			var melangkah:Array = new Array();
			if (historiLangkah.length == 0)
			{
				melangkah.push(bidakMacanAktif()[0]);
				melangkah.push(KelasMacan.pijakanBelumBerBidak()[KelasMacan.randomAntara(0, KelasMacan.pijakanBelumBerBidak().length)]);
			}
			else if (historiLangkah.length == 2)
			{
				melangkah.push(bidakMacanAktif()[1]);
				melangkah.push(KelasMacan.pijakanBelumBerBidak()[KelasMacan.randomAntara(0, KelasMacan.pijakanBelumBerBidak().length)]);
			}
			else
			{
				b = bidakMacanAktif()[KelasMacan.randomAntara(0, 1)];
				p = KelasMacan.koneksiValid(b)[KelasMacan.randomAntara(0, KelasMacan.jumlahKoneksiValid(b) - 1)];
				if (hitungLangkahBidak(b) == 0)
					return jalankanMacan();
					
				melangkah.push(b);
				melangkah.push(p);
			}
			return melangkah;
		}
		
		public static function jalankanAnak():Array
		{
			var melangkah:Array = new Array();
			var b:Bidak = new Bidak();
			var p:Pijakan = new Pijakan();
			
			if (cekBidakAnakBelumPijak().length != 0)
			{
				b = cekBidakAnakBelumPijak()[KelasMacan.randomAntara(0, (cekBidakAnakBelumPijak().length - 1))];
				p = KelasMacan.pijakanBelumBerBidak()[KelasMacan.randomAntara(0, (KelasMacan.pijakanBelumBerBidak().length - 1))];
				
				melangkah.push(b);
				melangkah.push(p);
			}
			else
			{
				b = bidakAnakAktif()[KelasMacan.randomAntara(0, bidakAnakAktif().length - 1)];
				p = KelasMacan.koneksiValid(b)[KelasMacan.randomAntara(0, (KelasMacan.koneksiValid(b).length - 1))];
				if (hitungLangkahBidak(b) == 0)
					return jalankanAnak();
				
				melangkah.push(b);
				melangkah.push(p);
			}
			
			return melangkah;
		}
		
		public static function cekMenang(bid:Array = null):Array
		{
			arrayMenang.pop();
			arrayMenang.pop();
			
			if (historiLangkah.length % 2 == 0) // jika langkah ganjil (langkah macan)
			{
				//trace("false");
				if (KecerdasanBuatan.totalHitungLangkahBidak("macan", bid) == 0) // jika bidak macan langkah habis (anak menang)
				{
					arrayMenang.push(true);
					arrayMenang.push("anak");
				}
				else
				{
					arrayMenang.push(false);
					arrayMenang.push("");
				}
			}
			else if (historiLangkah.length % 2 == 1) // jika langkah genap (langkah anak)
			{
				if (bidakAnakAktif(bid).length == 4) // jika bidak Anak yang aktif tersisa 4 (macan menang)
				{
					arrayMenang.push(true);
					arrayMenang.push("macan");
				}
				else
				{
					arrayMenang.push(false);
					arrayMenang.push("");
				}
			}			
			return arrayMenang;
		}
		
		public static function totalHitungLangkahBidak(jenisBidak:String = "macan", bid:Array = null):int
		{
			var jumlahLangkah:int = 0;
			if (jenisBidak == "macan")
			{
				if (cekBidakMacanBelumPijak(bid).length == 0)
				{
					for (var m = 0; m < bidakMacanAktif(bid).length; m++)
					{
						jumlahLangkah += hitungLangkahBidak(bidakMacanAktif(bid)[m]);
					}
				}
				else
					jumlahLangkah += 1;
			}
			else
			{
				for (var a = 0; a < bidakAnakAktif(bid).length; a++)
				{
					jumlahLangkah += hitungLangkahBidak(bidakAnakAktif(bid)[a]);
				}
			}
			return jumlahLangkah;
		}
		
		
	}

}