package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author projo
	 */
	public class Pijakan extends MovieClip
	{
		var koneksiPijakan:Array;
		var arahPijakan:Array;
		var koneksiLoncat:Array;
		var arahLoncat:Array;
		
		private var bidak:Bidak;
		private var nama:String;
		
		public function Pijakan()
		{
			nama = "";
			bidak = null; // set bidak kosong
			koneksiPijakan = new Array(); //set koneksi
			arahPijakan = new Array(); //set arah
			koneksiLoncat = new Array();
			addEventListener(Event.ADDED_TO_STAGE, inisialisasi);
		}
		
		private function inisialisasi(e:Event):void
		{
			addEventListener(MouseEvent.CLICK, pilihPijakan);
			addEventListener(MouseEvent.MOUSE_UP, keluarPijakan);
		}
		
		private function keluarPijakan(e:MouseEvent):void
		{
			anjakKe("kosong");
		}
		
		private function pilihPijakan(e:MouseEvent):void
		{
			anjakKe("terpilih");
			
			for (var i = 0; i < this.getJumlahKoneksi(); i++)
			{
				//this.getKoneksi()[i].anjakKe("terpilih");
			}
			
			//trace (getPijakLoncatByArah("NE").getNama());
			//getPijakLoncatByArah("NE").anjakKe("terpilih");
			//trace(getKoneksiLoncat().length);
			
			for (var x = 0; x < getKoneksiLoncat().length; x++)
			{
				trace(arahPijakan[x]);
				if(getPijakLoncatByArah(arahPijakan[x]) != null)
					getPijakLoncatByArah(arahPijakan[x]).anjakKe("terpilih");
					//this.getKoneksiLoncat()[x].anjakKe("terpilih");
					//trace("pijak : " + Pijakan(this).getKoneksi()[i].getNama() + " arah : " + e.target.arahPijakan[i]);
			}
		}
		
		public function anjakKe(frameName:String = "kosong")
		{
			MovieClip(this).gotoAndStop(frameName);
		}
		
		public function setText(s:String):void
		{
			nama = s;
			tPijakan.text = nama;
		}
		
		public function getNama():String
		{
			return nama;
		}
		
		//p Adalah pijakan akhir, a adalah arah dari pijakan awal ke pijakan akhir
		public function tambahKoneksi(p:Pijakan, a:String):void
		{
			if (getJumlahKoneksi() > 0) //jika sudah ada koneksi
			{
				for (var i = getJumlahKoneksi(); i > 0; i--)
				{
					if (p.getNama() == Pijakan(koneksiPijakan[i - 1]).getNama()) //jika ketemu return false
						return;
				}
				koneksiPijakan.push(p); //masukkan pijakan ke array
				arahPijakan.push(a); //masukkan arah ke array
				tambahKoneksiLawan(p, KelasMacan.getArahLawan(a));
				return;
			}
			else
			{ // jika belum ada koneksi sama sekali
				koneksiPijakan.push(p); //masukkan pijakan ke array
				arahPijakan.push(a);//masukkan arah ke array
				tambahKoneksiLawan(p, KelasMacan.getArahLawan(a));
				return;
			}
		}
		
		public function tambahKoneksiLawan(p:Pijakan, a:String):void
		{
			if (p.getJumlahKoneksi() > 0) //jika sudah ada koneksi
			{
				for (var i = p.getJumlahKoneksi(); i > 0; i--)
				{
					if (this.getNama() == Pijakan(p.koneksiPijakan[i - 1]).getNama()) //jika ketemu return false
						return;
				}
				p.koneksiPijakan.push(this);
				p.arahPijakan.push(a);
				return;
			}
			else
			{ // jika belum ada koneksi sama sekali
				p.koneksiPijakan.push(this);
				p.arahPijakan.push(a);
				return;
			}
		}
		
		public function getKoneksi():Array
		{
			return koneksiPijakan;
		}
		
		public function getJumlahKoneksi():int
		{
			return koneksiPijakan.length;
		}
		
		public function getKoneksiPijakByArah(p:Pijakan, arah:String = "N"):Pijakan
		{
			//trace("getkoneksipijakbyarah "+arah+" "+p.getNama());
			for (var a = 0; a < p.arahPijakan.length; a++)
			{
				//trace(p.arahPijakan[a]);
				if (p.arahPijakan[a] == arah)
					return Pijakan(p.getKoneksi()[a]);
			}
			return null;
		}
		
		public function getKoneksiLoncat():Array
		{
			koneksiLoncat = null;
			//trace("jumlah arah pijakan " + this.arahPijakan.length);
			for (var a = 0; a < this.arahPijakan.length; a++)
			{
				//trace(arahPijakan[a]);
				if (getPijakLoncatByArah(arahPijakan[a]) != null)
					koneksiLoncat.push(getPijakLoncatByArah(arahPijakan[a]));
			}
			return koneksiLoncat;
		}
		
		protected function getPijakLoncatByArah(arah:String):Pijakan
		{
			var pijakloncat = null;
			try
			{
				pijakloncat = getKoneksiPijakByArah(getKoneksiPijakByArah(getKoneksiPijakByArah(this, arah), arah), arah);
			}
			catch (err:Error)
			{
			}
			return pijakloncat;
		}
		
		public function setBidak(b:Bidak):Boolean
		{
			if (bidak != null)
				return false;
			else
			{
				bidak = b;
				return true;
			}
		}
		
		public function getBidak():Bidak
		{
			return bidak;
		}
	}

}