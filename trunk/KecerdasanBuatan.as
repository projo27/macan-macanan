package  
{
	/**
	 * ...
	 * @author projo
	 */
	public class KecerdasanBuatan 
	{
		private static var historiLangkah:Array = new Array();
		public static var bidakAktif:Array = new Array();
		public static var bidakPasif:Array = new Array();
		public static var pijakan:Array = new Array();
		//private static var bidakBelumPijak:Array = new Array();
		
		public function KecerdasanBuatan() 
		{
			//historiLangkah = new Array();
		}
		
		public static function getHistoriLangkah():Array {
			return historiLangkah;
		}
		
		public static function setHistoriLangkah(b:Bidak, p:Pijakan):void {
			historiLangkah.push(new Array((historiLangkah.length + 1), new Date().getTime(), p, b));
			//trace(historiLangkah[historiLangkah.length-1]);
		}
		
		public static function cekBidakBelumPijak():Array {			
			var bidakBelumPijak:Array = new Array();
			for (var b = 0; b < bidakAktif.length; b++) {
				if (Bidak(bidakAktif[b]).getPijakan() == null){
					bidakBelumPijak.push(bidakAktif[b]);
				}
			}
			return bidakBelumPijak;
		}
		
		public static function cekBidakMacanBelumPijak():Array {
			var bidakMacanBelumPijak:Array = new Array();
			for (var m = 0; m < cekBidakBelumPijak().length; m ++) {
				if (Bidak(bidakAktif[m]).tipeBidak == "macan"  && Bidak(bidakAktif[m]).getPijakan() == null) {
					bidakMacanBelumPijak.push(bidakAktif[m]);
				}
			}
			return bidakMacanBelumPijak;
		}
		
		public static function hitungLangkahBidak(b:Bidak, p:Pijakan):int{
			var score = 0;
			//TODO: hitung score bidak, untuk macan, ditambah dengan cekLoncatanMacan + koneksiValid
			score = KelasMacan.jumlahKoneksiValid + KelasMacan.bidakTerloncatiMacan(b.getPijakan(), p).length;
			return score;
		}
		
	}

}