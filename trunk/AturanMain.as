package
{
	
	/**
	 * ...
	 * @author projo
	 */
	public class AturanMain
	{
		var historiLangkah:Array;
		
		public function AturanMain()
		{
			historiLangkah = KecerdasanBuatan.getHistoriLangkah();
		}
		
		public function setLangkah(b:Bidak, p:Pijakan):Boolean
		{
			//trace(historiLangkah.length + " " + b + " " + p);
			// jika jumlah histori langkah 0 yang mulai harus macan dulu
			if (historiLangkah.length == 0)
			{
				if (b.tipeBidak != "macan")
					return false;
				else
				{
					pilihBidakPijak(b, p);
					return true;
				}
			}
			//selai itu hitung langkah
			else
			{
				if (historiLangkah.length % 2 == 1) // jika jumlah langkah ganjil, langkah selanjutnya adalah anak
				{
					if (b.tipeBidak != "anak") // jika tipe bidak bukan anak, maka gagal
						return false;
					else
					{
						// jika bidak anak ada yang belum mendapat pijakan, maka tidak diizinkan
						if (KecerdasanBuatan.cekBidakBelumPijak().length > 0 && b.getPijakan() != null)
						{
							trace("bidak harus habis terlebih dahulu");
							return false;
						}
						// selain itu, true dan pilihBidakPijak
						pilihBidakPijak(b, p);
						return true;
					}
				}
				else
				{
					// jika jumlah langkah sebelumnya genap, maka yang melangkah adalah macan
					if (b.tipeBidak != "macan") // jika tidak maka gagal
						return false;
					else // jika macan, true dan pilihBidak Pijak
					{
						pilihBidakPijak(b, p);
						return true;
					}
				}
			}
		}
		
		protected function pilihBidakPijak(b:Bidak, p:Pijakan):void
		{
			KecerdasanBuatan.setHistoriLangkah(b, p);
			b.setPijakan(p);
			p.setBidak(b);
		}
	}

}