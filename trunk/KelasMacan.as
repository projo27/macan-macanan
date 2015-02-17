package
{
	
	/**
	 * ...
	 * @author projo
	 */
	public class KelasMacan
	{
		
		static const FOLDER_BIDAK:String = "gambar/bidak/";
		
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
		
		public static function getArahLawan(arah:String = "N"):String {
			var arahBerlawanan:String = null;
			switch (arah) {
				case "N" :
					arahBerlawanan = "S";
					break;
				case "NE" :
					arahBerlawanan = "SW";
					break;
				case "E" :
					arahBerlawanan = "W";
					break;
				case "SE" :
					arahBerlawanan = "NW";
					break;
				case "S" :
					arahBerlawanan = "N";
					break;
				case "SW" :
					arahBerlawanan = "NE";
					break;
				case "W" :
					arahBerlawanan = "E";
					break;
				case "NW" :
					arahBerlawanan = "SE";
					break;
				default :
					arahBerlawanan = null;
					break;
			}
			return arahBerlawanan;
		}
	}

}