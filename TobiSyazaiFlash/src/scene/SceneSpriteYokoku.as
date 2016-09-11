package scene 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	//import fl.video.FLVPlayback;
	//import parts.VideoFLVPlaybackParts;
	import parts.VideoPlayWindowParts;

	/**
	 * 謝罪の王様：予告
	 * @author tobisako
	 */
	public class SceneSpriteYokoku extends AqtorScreenTransSprite
	{
		private var st:AqtorScreenTransition;
		private var ys:YokokuScene;
		//private var pl:FLVPlayback;
		private var vp:VideoPlayWindowParts;		// 特殊ビデオパーツ

		public function SceneSpriteYokoku(st:AqtorScreenTransition) 
		{
			this.st = st;
			ys = new YokokuScene();
			this.addChild( ys );
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// addChild()された時に呼び出されるコールバック
		private function addedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// 初期化処理
		public override function onInitScene(param:int = 0):void {
			// 画面遷移配置を元に戻る（一覧をトップに）
			//this.setChildIndex(slist, this.numChildren - 1);

			// 初期動画の再生
			vp = new VideoPlayWindowParts();
			vp.videoStreamParts.volume = 1;
			vp.x = 26;
			vp.y = 224;
			//vp.setViewArea( 1024, 580 );
			addChild( vp );
			vp.mode = 1;
			vp.setPlayCompleteCallBack( onMovieCompleteCallBack );
			vp.playVideo( "yokoku.mp4" ); 
			// ボタンコールバック登録
			onButtonCallBack();
		}

		// ボタンのコールバック登録処理
		private function onButtonCallBack():void {
			var i:int = 0;
			var result:int = 0;
			// ボタン・インスタンス確認
			while (true) {
				trace("(" + i + ")=[" + ys.getChildAt(i) + "]");
				if (getQualifiedClassName(ys.getChildAt(i)) == "yMovieButton") {
					ys.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onMovieButton);
					result++;
				}
				if (getQualifiedClassName(ys.getChildAt(i)) == "yAisatsuButton") {
					ys.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onAisatsuButton);
					result++;
				}
				if (getQualifiedClassName(ys.getChildAt(i)) == "ySongButton") {
					ys.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onSongButton);
					result++;
				}
				if (getQualifiedClassName(ys.getChildAt(i)) == "yReturnButton") {
					ys.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onReturnButton);
					result++;
				}
				if (result == 4) break;		// １つ、みつからない。
				i++;
			}
		}

		// 「再生終了」コールバック
		private function onMovieCompleteCallBack():void {
			st.goScreenTransition( 0, 6 );
		}

		// 「特別映像」ボタン押下
		private function onMovieButton(me:MouseEvent):void
		{
			//vp.videoStreamParts.stop();
			vp.mode = 1;
			vp.playVideo( "tokubetsu.mp4" );
		}

		// 「舞台あいさつ」ボタン押下
		private function onAisatsuButton(me:MouseEvent):void
		{
			//vp.videoStreamParts.stop();
			vp.mode = 2;
			vp.playVideo( "comment.mp4" );
		}
		private function onSongButton(me:MouseEvent):void
		{
		//	vp.videoStreamParts.pause();
			vp.mode = 1;
			vp.setPlayStartCallBack( fff );
			vp.playVideo( "song.mp4" );
			vp.visible = true;
		}

		private function fff():void {
			vp.visible = true;
		}
		
		private function onReturnButton(me:MouseEvent):void
		{
			st.goScreenTransition( 0, 6 );
		}

		// 終了処理
		public override function onLeaveScene(param:int = 0):void {
			vp.videoStreamParts.stop();
		}
	}
}
