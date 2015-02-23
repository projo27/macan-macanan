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
			
			if (pilihKoneksiPijak(b, p)) // || cekLoncatanMacan(b, p)
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
		protected function pilihKoneksiPijak(b:Bidak, p:Pijakan):Boolean
		{
			if (b.getPijakan() != null) // jika bidak sudah memiliki pijakan sebelumnya
			{
				//trace(b.getPijakan().getNama());
				var jalurPijak:Array = b.getPijakan().getKoneksi();
				var jalurLoncat:Array = b.getPijakan().getKoneksiLoncat();
				
				for (var j = 0; j < b.getPijakan().getJumlahKoneksi(); j++) // jika pijakan yang dipilih merupakan salah satu pilihan pijakan
				{
					//trace(jalurPijak[j].getNama() + " " + p.getNama());
					if (p == jalurPijak[j])
						return true; // jika termasuk return true
				}
				
				for (var l = 0; l < b.getPijakan().getJumlahKoneksiLoncat(); l++)
				{ // jika punya loncatan
					if (p == jalurLoncat[l])
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
		
		// untuk mengecek, apakah ada 2 bidak sejajar yang dapat diloncati
		public static function cekLoncatanMacan(b:Bidak, p:Pijakan):Boolean
		{
			if (b.getPijakan() != null && b.tipeBidak == "macan") // jika loncatan awal kosong, dan tipebidak macan
			{
				var arahLoncatan = "";
				var pijakan1:Pijakan = null;
				var pijakan2:Pijakan = null;
				var ketemu:Boolean = false;
				for (var l = 0; l < b.getPijakan().getJumlahKoneksiLoncat(); l++)
				{
					if (b.getPijakan().getKoneksiLoncat()[l] == p)
					{
						arahLoncatan = b.getPijakan().getArahKoneksiLoncat()[l];
					}
				}
				
				pijakan1 = b.getPijakan().getKoneksiPijakByArah(b.getPijakan(), arahLoncatan);
				if (pijakan1.getBidak() == null)
					return false;
				else if (pijakan1.getBidak().tipeBidak == "macan")
					return false;
				else
				{
					pijakan2 = pijakan1.getKoneksiPijakByArah(pijakan1, arahLoncatan);
					if (pijakan2.getBidak() == null)
						return false;
					else if (pijakan2.getBidak().tipeBidak == "macan")
						return false;
					else
					{
						//trace(pijakan1.getNama() + " " + pijakan1.getBidak().getNama() + " " + pijakan2.getNama() + " " + pijakan2.getBidak().getNama());
						return true;
					}
				}
			}
			return true;
		}
	
	}
}