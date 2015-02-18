package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
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
		
		public function pilihPijakan(e:MouseEvent):void
		{
			for (var i = 0; i < this.getJumlahKoneksi(); i++) {
				this.getKoneksi()[i].anjakKe("terpilih");
			}
			
			for (var x = 0; x < getJumlahKoneksiLoncat(); x++)
			{
				//trace(arahPijakan[x] + " " + getKoneksiLoncat()[x].getNama());
				getKoneksiLoncat()[x].anjakKe("terpilih");
			}
			//trace("jumlah total langkah " + getTotalKoneksi());
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
				arahPijakan.push(a); //masukkan arah ke array
				tambahKoneksiLawan(p, KelasMacan.getArahLawan(a));
				return;
			}
		}
		
		//untuk menambah koneksi sebaliknya
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
		
		//mengambil koneksi Pijakan
		public function getKoneksi():Array
		{
			return koneksiPijakan;
		}
		
		//mengambil jumlah koneksi Pijakan
		public function getJumlahKoneksi():int
		{
			return koneksiPijakan.length;
		}
		
		// tambah koneksi loncat (3 pijakan)
		public function tambahKoneksiLoncat():void
		{
			for (var a = 0; a < this.arahPijakan.length; a++)
			{
				var l:Pijakan = getPijakLoncatByArah(arahPijakan[a]);
				if (l != null)
					koneksiLoncat.push(l);
			}
		}
		
		// mengambil koneksi loncat
		public function getKoneksiLoncat():Array
		{
			return koneksiLoncat;
		}
		
		//mengambil jumlah koneksi loncat
		public function getJumlahKoneksiLoncat():int
		{
			return koneksiLoncat.length;
		}
		
		//mengambil total koneksi (pijakan + loncat)
		public function getTotalKoneksi():int
		{
			return koneksiPijakan.length + koneksiLoncat.length;
		}
		
		//mengambil 3 pijakan loncat berdasarkan arah
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
		
		// mengambil 1 pijakan loncat berdasarkan arah
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
		
		//mengeset bidak pada pijakan
		public function setBidak(b:Bidak):Boolean
		{
			if (b == null)
			{
				bidak = b;
				return true;
			}
			else
			{
				if (bidak != null)
					return false;
				else
				{
					bidak = b;
					return true;
				}
			}
		}
		
		// mengambil bidak pada pijakan
		public function getBidak():Bidak
		{
			return bidak;
		}
	}

}