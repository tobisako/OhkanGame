package parts 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author tobisako
	 */
	public class SoundParts		// extends Sound
	{
		[Embed(source = "../game/se/se_gamebgm.mp3")] private var s_bgm:Class;
		[Embed(source = "../game/se/se_catch.mp3")] private var s_catch:Class;
		[Embed(source = "../game/se/se_damage.mp3")] private var s_damage:Class;
		[Embed(source = "../game/se/se_gameclear.mp3")] private var s_clear:Class;
		[Embed(source = "../game/se/se_setsumei.mp3")] private var s_setsumei:Class;
		[Embed(source = "../game/se/se_kisimi03.mp3")] private var s_kisimi:Class;
		[Embed(source = "../game/se/se_beamgun.mp3")] private var s_beam:Class;
		[Embed(source = "../game/se/se_bowling-pin1.mp3")] private var s_pin:Class;
		[Embed(source = "../game/se/se_drum-roll1.mp3")] private var s_drum1:Class;
		[Embed(source = "../game/se/se_drum-fall1.mp3")] private var s_drum2:Class;
		private var cb_soundcomp:Function;
		protected var s:Sound;
		private var channel:SoundChannel;

		public function SoundParts(p:int = 0) {
			switch( p ) {
			case 0:		s = new s_bgm() as Sound;		break;
			case 1:		s = new s_catch() as Sound;		break;
			case 2:		s = new s_damage() as Sound;	break;
			case 3:		s = new s_clear() as Sound;		break;
			case 4:		s = new s_setsumei() as Sound;	break;
			case 5:		s = new s_kisimi() as Sound;	break;
			case 6:		s = new s_beam() as Sound;		break;
			case 7:		s = new s_pin() as Sound;		break;
			case 8:		s = new s_drum1() as Sound;		break;
			case 9:		s = new s_drum2() as Sound;		break;
			}
		}

		// 再生
		public function play( f:Function = null):void {
			cb_soundcomp = f;
			channel = s.play();
			channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		
		// 音声停止
		public function stop():void {
			if (channel != null) channel.stop();
		}
		
		// 再生終了コールバック処理
		private function soundCompleteHandler(event:Event):void {
			if (cb_soundcomp != null) cb_soundcomp();		// 再生終了コールバック呼び出し
        }
		
	//	public override function play(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null):flash.media.SoundChannel {
	//		return channel = super.play(startTime, loops, sndTransform);
	//	}
		
	//	public function stop():void {
	//		channel.stop();
	//	}
	}
}