package  
{
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
		var manaTerpilih:String;
		var kpManusia:KotakPlayer;
		var kpMacan:KotakPlayer;
		var kotakLevel:MovieClip;
		
		public function GantiLevel() 
		{
			manaTerpilih = null;
			kotakLevel = new MovieClip();
			kpManusia = new KotakPlayer("manusia");
			kpMacan = new KotakPlayer("macan");
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
			
			for (var i:int = 0; i < MovieClip(pilihLevel).numChildren; i++) {
				 pilihLevel.getChildAt(i).addEventListener(MouseEvent.CLICK, klikBarLevel);				 
			}
			
		}
		
		private function klikStart(e:MouseEvent):void 
		{
			MovieClip(this.parent).gotoAndPlay("Main", "Scene 1");
		}
		private function klikBarLevel(e:MouseEvent):void 
		{
			MovieClip(e.target.parent).gotoAndPlay("lev"+e.target.name.substr(10,1));
		}
		
		private function enableTombolStart():void {			
			if(kpManusia.apaTerpilih || kpMacan.apaTerpilih){
				SimpleButton(tombolStart).addEventListener(MouseEvent.CLICK, klikStart);
				SimpleButton(tombolStart).mouseEnabled = true;
				//tombolStart.buttonMode = true;
			}
		}
		
		private function klikManusia(e:MouseEvent):void 
		{
			kpMacan.pilih(false);
			/*if(kpManusia.apaTerpilih)
				kpManusia.pilih(false);
			else*/
				kpManusia.pilih(true);
			
			KecerdasanBuatan.thePlayer[0] = "AI";
			KecerdasanBuatan.thePlayer[1] = "PLAYER";
			enableTombolStart();
		}
		
		private function klikMacan(e:MouseEvent):void 
		{
			/*kpManusia.pilih(false);
			kpMacan.pilih(true);
			KecerdasanBuatan.thePlayer[0] = "PLAYER";
			KecerdasanBuatan.thePlayer[1] = "AI";*/
		}
		
	}

}