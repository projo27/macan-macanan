package
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author projo
	 */
	public class AturanMain
	{
		var historiLangkah:Array;
		var kelasMacan:KelasMacan;
		
		public function AturanMain()
		{
			historiLangkah = KelasMacan.historiLangkah;
			kelasMacan = new KelasMacan();
		}
		
		public function cekLangkah(b:Bidak, p:Pijakan, langkahKe:int, bidaks:Array):Boolean
		{
			if (p == null)
				return true;
			if (p.getBidak() != null) // jika pijakan yang dituju sudah ada bidak, maka gagal
				return false;
			if (langkahKe % 2 == 1 && b.tipeBidak != "macan") // jika langkah ganjil dan bukan macan
				return false;
			if (langkahKe % 2 == 0 && b.tipeBidak != "anak") // jika langkah genap dan bukan macan
				return false;
			
			if (b.getPijakan() == null) // jika bidak blm pijak, dan pijakan tujuan tidak ada bidak
				return true;
				
			if (b.getPijakan() != null) {
				// cek apakah ada bidak yang belum memiliki pijakan sebelum bidak dapat bergeser
				var adaBlmPijak:Boolean = kelasMacan.cekBidakBelumPijak(b.tipeBidak, bidaks);
				
				if (adaBlmPijak) // jika ada, maka gagal
					return false;
				else {
					if (pilihKoneksiPijak(b, p))
						return true;
					else
						return false;
					// jika bidak macan, bisa melakukan loncatan
				}
			}
			
			return false;
		}
		
		/*public function cekLangkah(b:Bidak, p:Pijakan, bid:Array = null, jmlHistoLangkah:int = -1):Boolean
		{
			var jumlahHistoLangkah:int = historiLangkah.length;
			var jmlBidakBelumPijak:int = 0;
			if (jmlHistoLangkah != -1)
				jumlahHistoLangkah = jmlHistoLangkah;
			
			if (jumlahHistoLangkah % 2 == 1) // jika jumlah langkah ganjil, langkah selanjutnya adalah anak
			{
				if (b.tipeBidak != "anak") // jika tipe bidak bukan anak, maka gagal
					return false;
				else
				{
					// jika bidak anak ada yang belum mendapat pijakan, maka tidak diizinkan
					jmlBidakBelumPijak = KecerdasanBuatan.cekBidakBelumPijak(bid).length;
					//if ( jmlBidakBelumPijak > 0 && b.getPijakan() != null)
					if (jmlBidakBelumPijak > 0 && b.getPijakan() != null)
						return false;
				}
			}
			else
			{
				// jika jumlah langkah sebelumnya genap, maka yang melangkah adalah macan
				if (b.tipeBidak != "macan") // jika tidak maka gagal
					return false;
				else // jika macan, true dan pilihBidak Pijak
				{
					// jika bidak macan ada yang belum mendapat pijakan maka tidak diizinkan
					jmlBidakBelumPijak = KecerdasanBuatan.cekBidakMacanBelumPijak(bid).length;
					//if (jmlBidakBelumPijak > 0 && b.getPijakan() != null)
					if (jmlBidakBelumPijak > 0 && b.getPijakan() != null)
						return false;
				}
			}
			
			if (pilihKoneksiPijak(b, p))
			{
				// selain itu, true dan pilihBidakPijak
				//pilihBidakPijak(b, p);
				return true;
			}
			return false;
		}
		*/
		public function setLangkah(b:Bidak, p:Pijakan, langkahKe:int, bidaks:Array):void
		{
			if (cekLangkah(b, p, langkahKe, bidaks))
				pilihBidakPijak(b, p);
		
		}
		
		//function untuk memilih Bidak, mengeset pijakan dan set bidak
		protected function pilihBidakPijak(b:Bidak, p:Pijakan):void
		{
			if (b.getPijakan() != null)
				b.getPijakan().setBidak(null); //set pijakan sebelumnya menjadi null
			b.setPijakan(p); // set pijakan untuk bidak
			if(p != null)
				p.setBidak(b); // set bidak pada pijakan
		}
		
		//function untuk menentukan, apakah pijakan yang dipilih terhubung dengan pijakan awal
		public function pilihKoneksiPijak(b:Bidak, p:Pijakan):Boolean
		{
			return kelasMacan.pilihKoneksiPijak(b, p);
		}
	}
}