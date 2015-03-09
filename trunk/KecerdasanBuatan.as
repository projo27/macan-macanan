package
{
	
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
		public static var thePlayer:Array = new Array("AI", "AI");
		public static var sedangJalan:Array = new Array();
		
		//private static var bidakBelumPijak:Array = new Array();
		
		public function KecerdasanBuatan()
		{
			//historiLangkah = new Array();
		}
		
		public static function getHistoriLangkah():Array
		{
			return historiLangkah;
		}
		
		public static function setHistoriLangkah(b:Bidak, p:Pijakan):void
		{
			historiLangkah.push(new Array((historiLangkah.length + 1), new Date().getTime(), p, b));
			//trace(historiLangkah[historiLangkah.length-1]);
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
		
		public static function bidakMacanAktif():Array {
			var arrB:Array = new Array();
			for (var b = 0; b < bidakAktif.length; b++) {
				if (bidakAktif[b].tipeBidak == "macan")
					arrB.push(bidakAktif[b]);
			}
			return arrB;
		}
		
		public static function bidakAnakAktif():Array {
			var arrB:Array = new Array();
			for (var b = 0; b < bidakAktif.length; b++) {
				if (bidakAktif[b].tipeBidak == "anak")
					arrB.push(bidakAktif[b]);
			}
			return arrB;
		}
		
		public static function hitungLangkahBidak(b:Bidak, p:Pijakan):int
		{
			var score = 0;
			
			//TODO: hitung score bidak, untuk macan, ditambah dengan cekLoncatanMacan + koneksiValid
			if(b.tipeBidak == "macan"){
				score = KelasMacan.jumlahKoneksiValid(b) + KelasMacan.bidakTerloncatiMacan(b.getPijakan(), p).length;
			}else
				score = KelasMacan.jumlahKoneksiValid(b);
			return score;
		}
		
		public static function getPlayerMacan():String
		{
			return thePlayer[0];
		}
		
		public static function getPlayerAnak():String
		{
			return thePlayer[1];
		}
		
		public static function mariMainkan():void
		{
			//var arr:Array = new Array();
			trace("mari main " + historiLangkah.length);
			if (historiLangkah.length % 2 == 0)
			{
				sedangJalan = jalankanMacan();
			}
			else
				sedangJalan = jalankanAnak();
			KelasMacan.sleep(500);
			//return arr;
		}
		
		public static function jalankanMacan():Array
		{ //return array(bidak, pijakan)
			//trace("mari main " + historiLangkah.length);
			var b:Bidak = new Bidak();
			var p:Pijakan = new Pijakan();
			var melangkah:Array = new Array();
			if (historiLangkah.length == 0)
			{
				//trace(cekBidakMacanBelumPijak().length);
				melangkah.push(bidakMacanAktif()[0]);
				melangkah.push(KelasMacan.pijakanBelumBerBidak()[KelasMacan.randomAntara(0, KelasMacan.pijakanBelumBerBidak().length)]);
			}
			else if (historiLangkah.length == 2)
			{
				//KelasMacan.sleep(100);
				//trace(cekBidakMacanBelumPijak().length);
				melangkah.push(bidakMacanAktif()[1]);
				p = KelasMacan.pijakanBelumBerBidak()[KelasMacan.randomAntara(0, KelasMacan.pijakanBelumBerBidak().length)];
				//trace(p.getNama() );
				melangkah.push(p);
			}
			else
			{
				b = bidakMacanAktif()[KelasMacan.randomAntara(0, 1)];
				p = KelasMacan.koneksiValid(b)[KelasMacan.randomAntara(0, KelasMacan.jumlahKoneksiValid(b))];
				melangkah.push(b);
				melangkah.push(p);
			}
			return melangkah;
		}
		
		public static function jalankanAnak():Array
		{
			//trace("mari main " + historiLangkah.length);
			var melangkah:Array = new Array();
			var b:Bidak = new Bidak();
			var p:Pijakan = new Pijakan();
			//trace(cekBidakAnakBelumPijak().length);
			
			if (cekBidakAnakBelumPijak().length != 0)
			{	
				b = cekBidakAnakBelumPijak()[KelasMacan.randomAntara(0, cekBidakAnakBelumPijak().length)];
				//trace(b.getNama());
				if (hitungLangkahBidak(b, p) == 0 || b.getPijakan() != null) return jalankanAnak();
				p = KelasMacan.pijakanBelumBerBidak()[KelasMacan.randomAntara(0, KelasMacan.pijakanBelumBerBidak().length)];
				
				//trace(p.getNama());
				melangkah.push(b);
				melangkah.push(p);
			}
			else
			{
				b = bidakAnakAktif()[KelasMacan.randomAntara(0, bidakAnakAktif().length)];
				//trace(b.getNama());
				if (hitungLangkahBidak(b, p) == 0 || b.getPijakan() != null) return jalankanAnak();
				p = KelasMacan.koneksiValid(b)[KelasMacan.randomAntara(0, KelasMacan.jumlahKoneksiValid(b))];
				//trace(p.getNama());
				
				melangkah.push(b);
				melangkah.push(p);
			}
			
			return melangkah;
		}
	
		//TODO: membuat AI dan aturan jalannya
		//URL :http://code.tutsplus.com/tutorials/build-an-intelligent-tic-tac-toe-game-with-as3--active-3636
	}

}