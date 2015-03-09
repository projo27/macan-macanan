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
		
		public function AturanMain()
		{
			historiLangkah = KecerdasanBuatan.historiLangkah;
		}
		
		public function setLangkah(b:Bidak, p:Pijakan):Boolean
		{
			//trace(historiLangkah.length + " " + b + " " + p);
			if (historiLangkah.length % 2 == 1) // jika jumlah langkah ganjil, langkah selanjutnya adalah anak
			{
				if (b.tipeBidak != "anak") // jika tipe bidak bukan anak, maka gagal
					return false;
				else
				{
					// jika bidak anak ada yang belum mendapat pijakan, maka tidak diizinkan
					if (KecerdasanBuatan.cekBidakBelumPijak().length > 0 && b.getPijakan() != null)
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
					if (KecerdasanBuatan.cekBidakMacanBelumPijak().length > 0 && b.getPijakan() != null)
						return false;
				}
			}
			
			if (pilihKoneksiPijak(b, p))
			{
				// selain itu, true dan pilihBidakPijak
				pilihBidakPijak(b, p);
				return true;
			}
			return false;
		}
		
		//function untuk memilih Bidak, menyimpan ke historis, mengeset pijakan dan set bidak
		protected function pilihBidakPijak(b:Bidak, p:Pijakan):void
		{
			KecerdasanBuatan.setHistoriLangkah(b, p); //simpan langkah
			if (b.getPijakan() != null)
				b.getPijakan().setBidak(null); //set pijakan sebelumnya menjadi null
			b.setPijakan(p); // set pijakan untuk bidak
			p.setBidak(b); // set bidak pada pijakan
		}
		
		//function untuk menentukan, apakah pijakan yang dipilih terhubung dengan pijakan awal
		public function pilihKoneksiPijak(b:Bidak, p:Pijakan):Boolean
		{			
			return KelasMacan.pilihKoneksiPijak(b, p);
		}
	}
}