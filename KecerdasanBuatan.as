package
{
	import flash.display.MovieClip;
	
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
		public static var thePlayer:Array = new Array("AI", "PLAYER"); // SET "PLAYER" ATAU "AI" [0] = MACAN, [1] = ANAK
		public static var sedangJalan:Array = new Array(); // [0] = Bidak, [1] = Pijakan
		public static var levelPermainan:int = 2;
		
		public static var arrayMenang:Array = new Array(false, ""); // [0] = menang (true, false), [1] = Macan / Anak
		
		public static var tempPijakan:Array = new Array();
		public static var tempBidakAktif:Array = new Array();
		public static var tempBidakPasif:Array = new Array();
		public static var tempSedangJalan:Array = new Array(); // [0] = Bidak, [1] = Pijakan
		
		public var prediksiPijakan:Array;
		public var prediksiBidakAktif:Array;
		public var prediksiBidakPasif:Array;
		public var prediksiJalan:Array;
		
		public function KecerdasanBuatan()
		{
			//historiLangkah = new Array();
			prediksiPijakan = new Array();
			prediksiBidakAktif = new Array();
			prediksiBidakPasif = new Array();
			prediksiJalan = new Array();
		}
		
		public static function resetKecerdasanBuatan(lvlPermainan:int = 2):void {
			
			historiLangkah = new Array();
			bidakAktif = new Array();
			bidakPasif = new Array();
			pijakan = new Array();
			langkahKe = historiLangkah.length;
			sedangJalan = new Array(); // [0] = Bidak, [1] = Pijakan
			setLevelPermainan(lvlPermainan); // set level permainan, jika ter-set
			
			arrayMenang = new Array(false, ""); // [0] = menang (true, false), [1] = Macan / Anak
			
			tempPijakan = new Array();
			tempBidakAktif = new Array();
			tempBidakPasif = new Array();
			tempSedangJalan = new Array(); // [0] = Bidak, [1] = Pijakan
		}
		
		public static function getHistoriLangkah():Array
		{
			return historiLangkah;
		}
		
		public static function setLevelPermainan(lev:int = 1):void
		{
			if (lev > KelasMacan.MAX_LEVEL_PERMAINAN)
				levelPermainan = KelasMacan.MAX_LEVEL_PERMAINAN;
			else
				levelPermainan = lev;
		}
		
		public static function setPlayer(player1:String = "AI", player2:String = "PLAYER") {
			KecerdasanBuatan.thePlayer[0] = player1;
			KecerdasanBuatan.thePlayer[1] = player2;
		}
		
		public static function setHistoriLangkah(b:Bidak, p:Pijakan):void
		{
			langkahKe++;
			historiLangkah.push(new Array(langkahKe, new Date().getTime(), KelasMacan.waktunya, p, b));
			//trace((historiLangkah.length) + " | " + KelasMacan.waktunya + " | " + p.getNama() + " | " + b.getNama());
		}
		
		//parameter bid = bidakAktif, atau tempBidakAktif
		public static function cekBidakBelumPijak(bid:Array = null):Array
		{
			var bidaks:Array = bidakAktif;
			if (bid != null)
				bidaks = bid;
			
			var bidakBelumPijak:Array = new Array();
			for (var b = 0; b < bidaks.length; b++)
			{
				if (Bidak(bidaks[b]).getPijakan() == null)
				{
					bidakBelumPijak.push(bidaks[b]);
				}
			}
			return bidakBelumPijak;
		}
		
		public static function cekBidakMacanBelumPijak(bid:Array = null):Array
		{
			var bidakMacanBelumPijak:Array = new Array();
			for (var m = 0; m < cekBidakBelumPijak(bid).length; m++)
			{
				if (Bidak(cekBidakBelumPijak(bid)[m]).tipeBidak == "macan")
				{
					bidakMacanBelumPijak.push(cekBidakBelumPijak(bid)[m]);
				}
			}
			return bidakMacanBelumPijak;
		}
		
		public static function cekBidakAnakBelumPijak(bid:Array = null):Array
		{
			var bidakAnakBelumPijak:Array = new Array();
			for (var m = 0; m < cekBidakBelumPijak(bid).length; m++)
			{
				if (Bidak(cekBidakBelumPijak(bid)[m]).tipeBidak == "anak")
				{
					bidakAnakBelumPijak.push(cekBidakBelumPijak(bid)[m]);
				}
			}
			return bidakAnakBelumPijak;
		}
		
		public static function bidakMacanAktif(bid:Array = null):Array
		{
			var bidaks:Array = bidakAktif;
			if (bid != null)
				bidaks = bid;
			var arrB:Array = new Array();
			for (var b = 0; b < bidaks.length; b++)
			{
				if (bidaks[b].tipeBidak == "macan")
					arrB.push(bidaks[b]);
			}
			return arrB;
		}
		
		public static function bidakAnakAktif(bid:Array = null):Array
		{
			var bidaks:Array = bidakAktif;
			if (bid != null)
				bidaks = bid;
			var arrB:Array = new Array();
			for (var b = 0; b < bidaks.length; b++)
			{
				if (bidaks[b].tipeBidak == "anak")
					arrB.push(bidaks[b]);
			}
			return arrB;
		}
		
		public static function hitungLangkahBidak(b:Bidak, pij:Array = null):int
		{
			var score = 0;
			
			if (b.tipeBidak == "macan")
			{
				//score = KelasMacan.jumlahKoneksiValid(b) + KelasMacan.bidakTerloncatiMacan(b.getPijakan(), p).length;
				score = KelasMacan.jumlahKoneksiValid(b, pij);
			}
			else
				score = KelasMacan.jumlahKoneksiValid(b, pij);
			return score;
		}
		
		public static function getPlayerMacan():String
		{
			return thePlayer[0]; // dapatkan player 1
		}
		
		public static function getPlayerAnak():String
		{
			return thePlayer[1]; // dapatkan player 2
		}
		
		public static function mariMainkan():void
		{
			sedangJalan = new Array(null, null);
			tempBidakAktif = bidakAktif;
			tempPijakan = pijakan;
			if (historiLangkah.length % 2 == 0 && getPlayerMacan() == "AI") // jika langkah ganjil dan player macan = AI
				sedangJalan = jalankanMacan(tempBidakAktif, tempPijakan);
			else if (historiLangkah.length % 2 == 1 && getPlayerAnak() == "AI") // jika langkah genap dan player anak = AI
				sedangJalan = jalankanAnak();
		}
		
		public static function jalankanMacan(bid:Array = null, pij:Array = null):Array
		{
			var b:Bidak = new Bidak();
			var p:Pijakan = new Pijakan();
			var melangkah:Array = new Array();
			var kbut:KecerdasanBuatan = new KecerdasanBuatan();
			var skor:Number;
			
			if (historiLangkah.length == 0)
			{
				melangkah.push(bidakMacanAktif(bid)[0]);
				melangkah.push(KelasMacan.pijakanBelumBerBidak(pij)[KelasMacan.randomAntara(0, KelasMacan.pijakanBelumBerBidak().length)]);
			}
			else if (historiLangkah.length == 2)
			{
				melangkah.push(bidakMacanAktif(bid)[1]);
				melangkah.push(KelasMacan.pijakanBelumBerBidak(pij)[KelasMacan.randomAntara(0, KelasMacan.pijakanBelumBerBidak().length)]);
			}
			else
			{
				/*b = bidakMacanAktif(bid)[KelasMacan.randomAntara(0, 1)];
				   p = KelasMacan.koneksiValid(b)[KelasMacan.randomAntara(0, KelasMacan.jumlahKoneksiValid(b) - 1)];
				   if (hitungLangkahBidak(b) == 0)
				   return jalankanMacan(bid, pij);
				
				   melangkah.push(b);
				 melangkah.push(p);*/
				
				skor = kbut.MiniMax(KelasMacan.bidakPijakanKeNode(bid, pij), levelPermainan, true);
				//melangkah = tempSedangJalan;
				
				var b:Bidak;
				for (var i = 0; i < KecerdasanBuatan.bidakAktif.length; i++)
				{
					if (bidakAktif[i].getNama() == tempSedangJalan[0].getNama())
						b = bidakAktif[i]
				}
				var p:Pijakan;
				for (i = 0; i < KecerdasanBuatan.pijakan.length; i++)
				{
					if (pijakan[i].getNama() == tempSedangJalan[1].getNama())
						p = pijakan[i];
				}
				trace(b.getNama() + " " + p.getNama());
				melangkah.push(b);
				melangkah.push(p);
					//melangkah.push(KelasMacan.bandingBidak(tempSedangJalan[0], bidakAktif));
					//melangkah.push(KelasMacan.bandingPijakan(tempSedangJalan[1], pijakan));
			}
			return melangkah;
		
		}
		
		public static function jalankanAnak(bid:Array = null, pij:Array = null):Array
		{
			var melangkah:Array = new Array();
			var b:Bidak = new Bidak();
			var p:Pijakan = new Pijakan();
			
			if (cekBidakAnakBelumPijak(bid).length != 0)
			{
				b = cekBidakAnakBelumPijak(bid)[KelasMacan.randomAntara(0, (cekBidakAnakBelumPijak(bid).length - 1))];
				p = KelasMacan.pijakanBelumBerBidak(pij)[KelasMacan.randomAntara(0, (KelasMacan.pijakanBelumBerBidak(pij).length - 1))];
				
				melangkah.push(b);
				melangkah.push(p);
			}
			else
			{
				b = bidakAnakAktif(bid)[KelasMacan.randomAntara(0, bidakAnakAktif(bid).length - 1)];
				p = KelasMacan.koneksiValid(b)[KelasMacan.randomAntara(0, (KelasMacan.koneksiValid(b).length - 1))];
				if (hitungLangkahBidak(b) == 0)
					return jalankanAnak();
				
				melangkah.push(b);
				melangkah.push(p);
			}
			
			return melangkah;
		}
		
		public static function cekMenang(bid:Array = null):Array
		{
			var arrayMenang:Array = KecerdasanBuatan.arrayMenang;
			if (bid == null)
			{
				bid = KecerdasanBuatan.bidakAktif;
				arrayMenang.pop();
				arrayMenang.pop();
			}
			else
			{
				arrayMenang = new Array();
			}
			
			if (historiLangkah.length % 2 == 0) // jika langkah ganjil (langkah macan)
			{
				//trace("false");
				if (KecerdasanBuatan.totalHitungLangkahBidak("macan", bid) == 0) // jika bidak macan langkah habis (anak menang)
				{
					arrayMenang.push(true);
					arrayMenang.push("anak");
				}
				else
				{
					arrayMenang.push(false);
					arrayMenang.push("");
				}
			}
			else if (historiLangkah.length % 2 == 1) // jika langkah genap (langkah anak)
			{
				if (bidakAnakAktif(bid).length == 4) // jika bidak Anak yang aktif tersisa 4 (macan menang)
				{
					arrayMenang.push(true);
					arrayMenang.push("macan");
				}
				else
				{
					arrayMenang.push(false);
					arrayMenang.push("");
				}
			}
			return arrayMenang;
		}
		
		//perhitungan langkah Bidak
		public static function totalHitungLangkahBidak(jenisBidak:String = "macan", bid:Array = null, pij:Array = null):int
		{
			var jumlahLangkah:int = 0;
			if (jenisBidak == "macan")
			{
				if (cekBidakMacanBelumPijak(bid).length == 0)
				{
					for (var m = 0; m < bidakMacanAktif(bid).length; m++)
					{
						jumlahLangkah += hitungLangkahBidak(bidakMacanAktif(bid)[m]);
					}
				}
				else
					jumlahLangkah ++;
			}
			else
			{
				for (var a = 0; a < bidakAnakAktif(bid).length; a++)
				{
					jumlahLangkah += hitungLangkahBidak(bidakAnakAktif(bid)[a]);
				}
			}
			return jumlahLangkah;
		}
		
		public function MiniMax(node:Array, kedalaman:int, maxPlayer:Boolean):Number
		{
			var dalam:int = kedalaman;
			var jenisBidak:String = "macan";
			var langkahTerbaik:Number = 0;
			var b:Number = 0;
			var p:Number = 0;
			var bi:Bidak = new Bidak();
			var bidaks:Array = new Array();
			
			if (!maxPlayer) jenisBidak = "anak";
			
			//trace("kedalaman " + kedalaman + " bidak " + jenisBidak);
			if (kedalaman == 0)
			{
				//trace("hitung kedalaman " + jenisBidak+ " "+kedalaman + " total langkah : " + totalHitungLangkahBidak(jenisBidak, node[0], node[1]));
				return totalHitungLangkahBidak(jenisBidak, node[0], node[1]);
			}
			
			kedalaman--;
			
			if (maxPlayer)
			{
				langkahTerbaik = Number.NEGATIVE_INFINITY;
				
				bidaks = (cekBidakMacanBelumPijak(node[0]).length == 1) ? cekBidakMacanBelumPijak(node[0]) : bidakMacanAktif(node[0]);
				//trace(bidaks.length);
				for (b = 0; b < bidaks.length; b++)
				{
					//if (hitungLangkahBidak(node[0][b]) != 0 && bi.getPijakan() != null)
					//{
					//trace(KelasMacan.jumlahKoneksiValid(bidaks[b], node[1]));
					for (p = 0; p < KelasMacan.jumlahKoneksiValid(bidaks[b], node[1]); p++)
					{
						var kb:KecerdasanBuatan = new KecerdasanBuatan();
						kb.prediksiBidakAktif = node[0];
						kb.prediksiPijakan = node[1];
						kb.prediksiBidakPasif = node[2];
						
						bi = bidaks[b];
						//trace(bi.getNama());
						var aturan:AturanMain = new AturanMain();
						
						if (!aturan.cekLangkah(bi, KelasMacan.koneksiValid(bi)[p], kb.prediksiBidakAktif, 0)){
							//trace (bi.getNama());
							continue;
						}
						else {
							var skor:Number = kb.MiniMax(KelasMacan.bidakPijakanKeNode(kb.prediksiBidakAktif, kb.prediksiPijakan, kb.prediksiBidakPasif), kedalaman, false);
						}
						//trace(bi.getPijakan().getNama());
						//if(aturan.pilihKoneksiPijak(bi, KelasMacan.koneksiValid(bi, kb.prediksiPijakan)[p]))
						
						//if (langkahTerbaik < skor)
						//{
							//tempBidakAktif = kb.prediksiBidakAktif;
							//tempPijakan = kb.prediksiPijakan;
							//tempBidakPasif = kb.prediksiBidakPasif;
							tempSedangJalan.pop();
							tempSedangJalan.pop();
							tempSedangJalan.push(bi);
							tempSedangJalan.push(KelasMacan.koneksiValid(bi, kb.prediksiPijakan)[p]);
						//}
						
						//bi.setDisable();
						langkahTerbaik = Math.max(langkahTerbaik, skor);
						trace("macan kedalaman : " + dalam + " " + bi.getNama() + " " + KelasMacan.koneksiValid(bi, kb.prediksiPijakan)[p].getNama() + " skor " + langkahTerbaik);
					}
				}
				return langkahTerbaik;
			}
			else
			{
				langkahTerbaik = Number.POSITIVE_INFINITY;
				
				bidaks = (cekBidakAnakBelumPijak(node[0]).length == 1) ? cekBidakAnakBelumPijak(node[0]) : bidakAnakAktif(node[0]);
				//trace("tes "+node[0].length);
				for (b = 0; b < bidaks.length; b++)
				{
					//trace(KelasMacan.jumlahKoneksiValid(bidaks[b], node[1]));
					for (p = 0; p < KelasMacan.jumlahKoneksiValid(bidaks[b], node[1]); p++)
					{
						var kb:KecerdasanBuatan = new KecerdasanBuatan();
						kb.prediksiBidakAktif = node[0];
						kb.prediksiPijakan = node[1];
						kb.prediksiBidakPasif = node[2];
						bi = bidaks[b];
						//if (cekBidakAnakBelumPijak(kb.prediksiBidakAktif).length > 0)
							//bi = cekBidakAnakBelumPijak(kb.prediksiBidakAktif)[0];
						
						var aturan:AturanMain = new AturanMain();
						if (!aturan.cekLangkah(bi, KelasMacan.koneksiValid(bi)[p], kb.prediksiBidakAktif, 1)){
							//trace (bi.getNama());
							continue;
						}
						else {
							//aturan.setLangkah(bi, KelasMacan.koneksiValid(bi)[p]);
							var skor:Number = kb.MiniMax(KelasMacan.bidakPijakanKeNode(kb.prediksiBidakAktif, kb.prediksiPijakan, kb.prediksiBidakPasif), kedalaman, true);
						}
						//if (aturan.pilihKoneksiPijak(bi, KelasMacan.koneksiValid(bi, kb.prediksiPijakan)[p]))
						
						//if (langkahTerbaik > skor)
						//{
							//tempBidakAktif = kb.prediksiBidakAktif;
							//tempPijakan = kb.prediksiPijakan;
							//tempBidakPasif = kb.prediksiBidakPasif;
							tempSedangJalan.pop();
							tempSedangJalan.pop();
							tempSedangJalan.push(bi);
							tempSedangJalan.push(KelasMacan.koneksiValid(bi, kb.prediksiPijakan)[p]);
						//}
						langkahTerbaik = Math.min(langkahTerbaik, skor);
						trace("anak kedalaman : " + dalam + " " + bi.getNama() + " " + KelasMacan.koneksiValid(bi, kb.prediksiPijakan)[p].getNama() + " skor " + langkahTerbaik);
					}
				}
				return langkahTerbaik;
			}
			//return 0;
		}
	
	/*
	 *
	   function minimax(node, depth, maximizingPlayer)
		if depth = 0 or node is a terminal node
			return the heuristic value of node
		if maximizingPlayer
			bestValue := -∞
			for each child of node
				val := minimax(child, depth - 1, FALSE)
				bestValue := max(bestValue, val)
				return bestValue
		else
			bestValue := +∞
			for each child of node
				val := minimax(child, depth - 1, TRUE)
				bestValue := min(bestValue, val)
				return bestValue
	
	   (* Initial call for maximizing player *)
	   minimax(origin, depth, TRUE)
	
	   function alphaBeta(node, alpha, beta, maximisingPlayer) {
	   var bestValue;
	   if (node.children.length === 0) {
	   bestValue = node.data;
	   }
	   else if (maximisingPlayer) {
	   bestValue = alpha;
	
	   // Recurse for all children of node.
	   for (var i=0, c=node.children.length; i<c; i++) {
	   var childValue = alphaBeta(node.children[i], bestValue, beta, false);
	   bestValue = Math.max(bestValue, childValue);
	   if (beta <= bestValue) {
	   break;
	   }
	   }
	   }
	   else {
	   bestValue = beta;
	
	   // Recurse for all children of node.
	   for (var i=0, c=node.children.length; i<c; i++) {
	   var childValue = alphaBeta(node.children[i], alpha, bestValue, true);
	   bestValue = Math.min(bestValue, childValue);
	   if (bestValue <= alpha) {
	   break;
	   }
	   }
	   }
	   return bestValue;
	   }
	
	   /*function alphabeta(node, depth, α, β, maximizingPlayer)
	   if depth = 0 or node is a terminal node
	   return the heuristic value of node
	   if maximizingPlayer
	   v := -∞
	   for each child of node
	   v := max(v, alphabeta(child, depth - 1, α, β, FALSE))
	   α := max(α, v)
	   if β ≤ α
	   break (* β cut-off *)
	   return v
	   else
	   v := ∞
	   for each child of node
	   v := min(v, alphabeta(child, depth - 1, α, β, TRUE))
	   β := min(β, v)
	   if β ≤ α
	   break (* α cut-off *)
	   return v
	
	 alphabeta(origin, depth, -∞, +∞, TRUE)*/
	}
}