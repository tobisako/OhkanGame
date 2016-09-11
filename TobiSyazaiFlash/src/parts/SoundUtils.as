package parts 
{
	import flash.media.SoundTransform;

	/**
	 * ...
	 * @author tobisako
	 */
	public class SoundUtils {
		private var st:SoundTransform;
		private var source:Object;
		public function SoundUtils(src:Object) {
			source = src;
		}
		public function set volume(num:Number):void {
			getSoundTransform().volume = num;
			source.soundTransform = getSoundTransform();
		}
		public function get volume():Number {
			return getSoundTransform().volume;
		}
		public function set pan(num:Number):void {
			getSoundTransform().pan = num;
			source.soundTransform = getSoundTransform();
		}
		public function get pan():Number {
			return getSoundTransform().pan;
		}
		private function getSoundTransform():SoundTransform {
			if (!st) {
				st = source.soundTransform;
			}
			return st;
		}
	}
} // http://feb19.jp/blog/archives/000130.php
