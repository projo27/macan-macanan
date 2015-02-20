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
		}
		
		public static function cekBidakBelumPijak():Array {			
			var bidakBelumPijak = new Array();
			for (var b = 0; b < bidakAktif.length; b++) {
				if (Bidak(bidakAktif[b]).getPijakan() == null){
					bidakBelumPijak.push(bidakAktif[b]);
				}
				else
				trace(bidakAktif[b].getNama()+" "+bidakAktif[b].getPijakan().getNama());
			}
			return bidakBelumPijak;
		}
		
	}

}