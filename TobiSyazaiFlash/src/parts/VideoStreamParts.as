package parts 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import caurina.transitions.Tweener;

	public class VideoStreamParts extends Video
	{
		private var cb_start:Function;		// 再生開始コールバック
		private var cb_comp:Function;		// 再生終了コールバック
		private var nc:NetConnection;
        private var stream:NetStream;
        //private var cstream:CustomNetStream;
		private var trans : SoundTransform;
		private var vol:Number;
		private var filename:String;
		private var st:SoundTransform;

		// コンストラクタ
		public function VideoStreamParts() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// addChild()された時に呼び出されるコールバック
		private function addedToStage(e:Event):void {
		}

		// ビデオ再生開始
		public function playVideo(s:String):void
		{
			filename = s;
			st = new SoundTransform(0);

			// ネット・コネクション生成
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS , onConnect);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR , trace);

			var metaSniffer:Object=new Object();
			nc.client = metaSniffer;
			metaSniffer.onMetaData=getMeta;
			nc.connect(null);
		}

		// コネクトＣＢ：ストリーム再生開始
		// NetStatus: http://www40.atwiki.jp/spellbound/pages/271.html
		private function onConnect(e:NetStatusEvent):void
		{
			if (e.info.code == 'NetConnection.Connect.Success') {
				stream = new NetStream( e.target as NetConnection );

				stream.client = { };	//new Object();
				//cstream.client = new Object();
				//cstream.client.onCuePoint = cuePointHandler;
				
				st.volume = vol;
				stream.soundTransform = st;
				
				stream.play( filename );
				this.attachNetStream( stream );
				stream.addEventListener(NetStatusEvent.NET_STATUS, nsNetStatus, false, 0, true);
				//trace( "play!" );
			}
		}

		// ネットストリームＣＢ：ストリーム再生状況
		private function nsNetStatus(evt:NetStatusEvent):void {
			switch (evt.info.code) {
			case "NetStream.Buffer.Full" :  //バッファ充足(再生開始)
				//trace( "NetStream.Buffer.Full -> PLAY START" );
				break;
			case "NetStream.Buffer.Empty" :  //バッファ不足(再生中断)
				trace( "NetStream.Buffer.Empty" );
				break;
			case "NetStream.Buffer.Flush" :  //バッファ空(再生終了)
				trace( "NetStream.Buffer.Flush" );
				break;
			case "NetStream.Play.Start" :  //再生開始
				//trace( "NetStream.Play.Start" );
				if (cb_start != null) cb_start();	// 再生開始コールバック実行
			//	setup();
				break;
			case "NetStream.Play.Stop" :  //再生完了
				trace( "NetStream.Play.Stop" );
				if (cb_comp != null) cb_comp();		// 再生終了コールバック実行
			//	complete();
				break;
			case "NetStream.Pause.Notify" :  //再生一時停止
				trace( "NetStream.Pause.Notify" );
				break;
			case "NetStream.Play.StreamNotFound" :  //FLVが見つからない
				trace( "NetStream.Play.StreamNotFound" );
				break;
			case "NetStream.Seek.Notify" :  //シーク完了通知
				trace( "NetStream.Seek.Notify" );
				break;
			case "NetStream.Play.InvalidTime" :  //未ダウンロード時間へのシーク
				trace( "NetStream.Play.InvalidTime" );
				break;
			}
		} // 参考： http://blog.project-nya.jp/1186

		// キューポイントコールバック（ＦＬＶのみ）※mp4では使えない？
		 private function cuePointHandler(infoObject:Object):void 
        { 
            trace("cue point"); 
        }

		// メタゲット
		private function getMeta(mdata:Object):void {
			this.width=mdata.width/2;
			this.height=mdata.height/2;
		}
		
		//////////////////////////////////////////////////////////
		
		// 再生開始直後コールバック（安定再生を取って完全に同期する事が出来る)
		public function setPlayStartCallBack(f:Function):void {
			cb_start = f;
		}

		// 再生終了コールバック（安定再生を取って完全に同期する事が出来る)
		public function setPlayCompleteCallBack(f:Function):void {
			cb_comp = f;
		}

	//	// キューポイントコールバック（１個しか登録できません）
	//	public function setCuePointCallBack(f:Function):void {
	//		cb_cuepoint = f;
	//	}

		// 「Volume()」関数
		public function set volume(v:Number):void {
			vol = v;
			if (stream != null) {
				st.volume = vol;
				//var t:SoundTransform = new SoundTransform( vol );
				stream.soundTransform = st;
			}
		}
		public function get volume():Number {
			return vol;
		}

		// 再生停止関数
		public function stop():void {
			if (stream != null) {
				stream.pause();
				stream.seek( 0 );	// 停止＝一時停止して先頭へシークする。
			}
			// http://help.adobe.com/ja_JP/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7d4d.html
		}
		
		// 一次停止関数
		public function pause():void {
			stream.pause();
		}
		
		// 再生再開
		public function resume():void {
			stream.resume();
		}
	}
}
// 参考ＵＲＬ：　http://help.adobe.com/ja_JP/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7d3f.html
