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
		public static var sedangJalan:Array = new Array();
		public static var levelPermainan:int = 1;
		
		public static var arrayMenang:Array = new Array(false, "");
		
		public static var tempPijakan:Array = new Array();
		public static var tempbidakAktif:Array = new Array();
		
		public static const MAX_LEVEL_PERMAINAN:int = 3;
		//private static var bidakBelumPijak:Array = new Array();
		
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
			trace((historiLangkah.length - 1) + " | " +KelasMacan.waktunya+" | "+ p.getNama() + " | " + b.getNama());
		}
		
		public static function cekBidakBelumPijak():Array
		{
			var bidakBelumPijak:Array = new Array();
			for (var b = 0; b < bidakAktif.length; b++)
			{
				if (Bidak(bidakAktif[b]).getPijakan() == null)
				{
					bidakBelumPijak.push(bidakAktif[b]);
				}
			}
			return bidakBelumPijak;
		}
		
		public static function cekBidakMacanBelumPijak():Array
		{
			var bidakMacanBelumPijak:Array = new Array();
			for (var m = 0; m < cekBidakBelumPijak().length; m++)
			{
				if (Bidak(cekBidakBelumPijak()[m]).tipeBidak == "macan")
				{
					bidakMacanBelumPijak.push(cekBidakBelumPijak()[m]);
				}
			}
			return bidakMacanBelumPijak;
		}
		
		public static function cekBidakAnakBelumPijak():Array
		{
			var bidakAnakBelumPijak:Array = new Array();
			for (var m = 0; m < cekBidakBelumPijak().length; m++)
			{
				if (Bidak(cekBidakBelumPijak()[m]).tipeBidak == "anak")
				{
					bidakAnakBelumPijak.push(cekBidakBelumPijak()[m]);
				}
			}
			return bidakAnakBelumPijak;
		}
		
		public static function bidakMacanAktif():Array
		{
			var arrB:Array = new Array();
			for (var b = 0; b < bidakAktif.length; b++)
			{
				if (bidakAktif[b].tipeBidak == "macan")
					arrB.push(bidakAktif[b]);
			}
			return arrB;
		}
		
		public static function bidakAnakAktif():Array
		{
			var arrB:Array = new Array();
			for (var b = 0; b < bidakAktif.length; b++)
			{
				if (bidakAktif[b].tipeBidak == "anak")
					arrB.push(bidakAktif[b]);
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
		
		public static function cekMenang():Array
		{
			arrayMenang.pop();
			arrayMenang.pop();
			
			if (historiLangkah.length % 2 == 0) // jika langkah ganjil (langkah macan)
			{
				//trace("false");
				if (KecerdasanBuatan.totalHitungLangkahBidak("macan") == 0)
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
				if (bidakAnakAktif().length == 4)
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
		
		public static function totalHitungLangkahBidak(jenisBidak:String = "macan"):int
		{
			var jumlahLangkah:int = 0;
			if (jenisBidak == "macan")
			{
				if (cekBidakMacanBelumPijak().length == 0)
				{
					for (var m = 0; m < bidakMacanAktif().length; m++)
					{
						jumlahLangkah += hitungLangkahBidak(bidakMacanAktif()[m]);
					}
				}
				else
					jumlahLangkah += 1;
			}
			else
			{
				for (var a = 0; a < bidakAnakAktif().length; a++)
				{
					jumlahLangkah += hitungLangkahBidak(bidakAnakAktif()[a]);
				}
			}
			//trace(jumlahLangkah + " ");
			return jumlahLangkah;
		}
	}

}