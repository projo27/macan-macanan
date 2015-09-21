package
{
	import fl.transitions.easing.Back;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Nafi Projo
	 */
	public class GantiLevel extends MovieClip
	{
		var kpManusia:KotakBidak;
		var kpMacan:KotakBidak;
		var kotakLevel:MovieClip;
		var lvlPermainan:int;
		
		public function GantiLevel()
		{
			lvlPermainan = 1;
			kotakLevel = new MovieClip();
			kpManusia = new KotakBidak("manusia");
			kpMacan = new KotakBidak("macan");
			modal.visible = false;
			SimpleButton(tombolStart).mouseEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, tambahKeStage);
		}
		
		private function tambahKeStage(e:Event):void
		{
			kpManusia.x = 515; //240
			kpManusia.y = 210;
			parentKotakPlayer.addChild(kpManusia);			
			
			kpMacan.x = 250; //130
			kpMacan.y = 210;
			parentKotakPlayer.addChild(kpMacan);
			
			kpMacan.addEventListener(MouseEvent.CLICK, klikMacan);
			kpManusia.addEventListener(MouseEvent.CLICK, klikManusia);
			
			for (var i:int = 0; i < MovieClip(pilihLevel).numChildren; i++)
			{
				pilihLevel.getChildAt(i).addEventListener(MouseEvent.CLICK, klikBarLevel);
			}
		
		}
		
		private function klikStart(e:MouseEvent):void
		{
			KecerdasanBuatan.resetKecerdasanBuatan(lvlPermainan);
			MovieClip(this.parent).gotoAndStop("Main", "Scene 1");
		}
		
		private function klikBarLevel(e:MouseEvent):void
		{
			MovieClip(e.target.parent).gotoAndStop("lev" + e.target.name.substr(10, 1));
			lvlPermainan = int(e.target.name.substr(e.target.name.length - 1, 1));
		}
		
		private function enableTombolStart(enable:Boolean):void
		{
			if (enable)
			{
				SimpleButton(tombolStart).addEventListener(MouseEvent.CLICK, klikStart);
				SimpleButton(tombolStart).mouseEnabled = true;
			}
			else {
				SimpleButton(tombolStart).removeEventListener(MouseEvent.CLICK, klikStart);
				SimpleButton(tombolStart).mouseEnabled = false;
			}
		}
		
		private function klikManusia(e:MouseEvent):void
		{
			kpManusia.pilih();
			var tipeB:String;
			if (kpManusia.apaTerpilih)
				tipeB = "PLAYER";
			else
				tipeB = "AI";
			
			KecerdasanBuatan.setPlayer(KecerdasanBuatan.thePlayer[0], tipeB);
			
			if (KecerdasanBuatan.thePlayer[0] == "PLAYER" || KecerdasanBuatan.thePlayer[1] == "PLAYER")
				enableTombolStart(true);		
			else
				enableTombolStart(false);
			
		}
		
		private function klikMacan(e:MouseEvent):void
		{
			kpMacan.pilih();
			var tipeB:String;
			if (kpMacan.apaTerpilih)
				tipeB = "PLAYER";
			else
				tipeB = "AI";
			
			KecerdasanBuatan.setPlayer(tipeB, KecerdasanBuatan.thePlayer[1]);
			
			if(KecerdasanBuatan.thePlayer[0] == "PLAYER" || KecerdasanBuatan.thePlayer[1] == "PLAYER")
				enableTombolStart(true);
			else
				enableTombolStart(false);
		}
	
	}

}