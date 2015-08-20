package
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	public class Game extends MovieClip
	{
		var lastFrame:int = 0;
		
		public function Game()
		{
			theAbout.visible = false;
			theQuit.visible = false;
			// constructor code
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			theSetting.addEventListener(SettingEvent.ABOUT, tampilkanAbout);
			theSetting.addEventListener(SettingEvent.QUIT, tampilkanQuit);
			theAbout.theClose.addEventListener(MouseEvent.CLICK, tampilkanAbout);
			theAbout.theClose.buttonMode = true;
			
			theQuit.tombolResetGame.buttonMode = true;
			theQuit.tombolGantiLevel.buttonMode = true;
			
			theQuit.tombolResetGame.addEventListener(MouseEvent.CLICK, keResetGame);
			theQuit.tombolGantiLevel.addEventListener(MouseEvent.CLICK, keGantiLevel);
			
			theQuit.theClose.addEventListener(MouseEvent.CLICK, tampilkanQuit);
			
			//SimpleButton(theLevel.theWin.btnMainLagi).addEventListener(MouseEvent.CLICK, resetGame);
		}
		
		private function enterFrame(e:Event):void 
		{
			//trace(currentFrame);
			if (lastFrame != currentFrame && currentFrameLabel == "Main")
				SimpleButton(theLevel.theWin.btnMainLagi).addEventListener(MouseEvent.CLICK, resetGame);
		}
		
		private function resetGame(ev:MouseEvent):void
		{
			try
			{
				removeChild(this.getChildByName("theLevel"));
				KecerdasanBuatan.resetKecerdasanBuatan(KecerdasanBuatan.levelPermainan);
			}
			catch (er:Error)
			{
				trace(er.message);
			}
			var lev:Main = new Main();
			lev.name
			lev.name = "theLevel";
			this.addChildAt(lev, 3);
			SimpleButton(lev.theWin.btnMainLagi).addEventListener(MouseEvent.CLICK, resetGame);
			//setModal();
		}
		
		public function keResetGame(e:MouseEvent):void
		{
			//MovieClip(this.parent).gotoAndPlay("Main", "Scene 1");
			if (currentFrameLabel == "Main")
			{
				resetGame(null);
			}
			else
			{
				//return;	
			}
			//trace(this.name);
			//setModal(false);
			tampilkanQuit(null);
		}
		
		private function keGantiLevel(e:Event):void
		{
			try
			{
				System.gc();
				removeChild(this.getChildByName("theLevel"));
				//KelasMacan.sleep(1000);
				//KecerdasanBuatan.resetKecerdasanBuatan();
			}
			catch (er:Error)
			{
			}
			gotoAndStop("Start");
			//try { MovieClip(theLevel) = null; } catch (er:Error) {}
			//System.gc();
			tampilkanQuit(null);
		}
		
		function setModal(tampil:Boolean = true)
		{
			try
			{
				theLevel.modal.visible = tampil;
			}
			catch (er:Error)
			{
			}
			try
			{
				theGantiLevel.modal.visible = tampil;
			}
			catch (er:Error)
			{
			}
		}
		
		private function tampilkanQuit(e:Event):void
		{
			if (!theQuit.visible)
			{
				theQuit.visible = true;
				if (theAbout.visible)
					tampilkanAbout(null);
				setModal();
			}
			else
			{
				setModal(false);
				theQuit.visible = false;
			}
		}
		
		function tampilkanAbout(ev:*)
		{
			if (!theAbout.visible)
			{
				theAbout.visible = true;
				if (theQuit.visible)
					tampilkanQuit(null);
				setModal();
			}
			else
			{
				setModal(false);
				theAbout.visible = false;
			}
		}
	}

}
