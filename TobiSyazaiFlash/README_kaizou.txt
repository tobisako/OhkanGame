# �Ƃ���������@

�p�F�Ȃ��A�X�C�b�`��Ő؂�ւ���l�ɂ��Ȃ��̂��H
�`�F��l�̎���ł��B����܂��ȒP�Ɍ����l�ɂ���̂������ׂł��B

���{���̊T�v�́A�uREADME.me�v���������������B



��1.�t�@�C�����ړ�����B

�ubin_sonota�v�t�H���_���ɂ���S�t�@�C�����A
�ubin�v�t�H���_�ֈړ������Ă��������B


��2.�v���O��������������B

���L�菇�ʂ�A�v���O�������C�����ĉ������B

[SceneSpriteOpening.as]
�����L�u�a�v���R�����g�A�E�g���āA��L�u�`�v�̃R�����g�A�E�g���O���ėL���ɂ��ĉ������B
--------------------------------------------------
// �`�p�X�v���b�V����ʕ\���^�C���A�b�v�b�a
private function onSplashTimeUp(te:TimerEvent):void
{
	///////////////////////////////////////
	// [201609]�߂鏈���R�����g�A�E�g�n�o���[�r�[���΂��āA�����Ȃ�I�[�v�j���O�ֈړ�����e�X�g�R�[�h

	// �`�F�I�[�v�j���O�f������B
	//sceneControl();		// �����Ȃ������̃V�[���֑J�ڂ���B

	// �a�F�I�[�v�j���O�f�������B
	sceneControl( false, 7 );
	st.goScreenTransition( 1 );		// �Q�[���^�C�g����ʂփW�����v

	///////////////////////////////////////
}
--------------------------------------------------


[SceneSpriteGameTitle.as]
�����L�Q�ӏ��̃R�����g�A�E�g���O���āA�L���ɂ��ĉ������B
--------------------------------------------------
private function onPushedModoruButton():void
{
	// [201609]�߂鏈���R�����g�A�E�g
	// st.goScreenTransition( 0, 6 );
}
	�F
// �R�O�b�^�C���A�b�v�b�a
private function onTimeUp(te:TimerEvent):void
{
	// [201609]�߂鏈���R�����g�A�E�g
	// st.goScreenTransition( 0, 6 );
}
--------------------------------------------------


[SceneSpriteGameStage.as]
�����L�u�a�v���R�����g�A�E�g���āA��L�u�`�v�̃R�����g�A�E�g���O���ėL���ɂ��ĉ������B
--------------------------------------------------
// �u�߂�v�{�^���������̏���
private function onBtnBack():void
{
	//////////////////////////////////
	// [201609]�߂鏈���R�����g�A�E�g

	// �`�F�`�F�I�[�v�j���O�f������B
	// st.goScreenTransition( 0, 6 );		// �I�[�v�j���O��ʂ֖߂�I
		
	// �a�F�Q�[���^�C�g���ɖ߂�B
	st.goScreenTransition( 1 );		// �Q�[���^�C�g����ʂփW�����v

	//////////////////////////////////
}
--------------------------------------------------


[SceneSpriteGameClear.as]
�����L�u�a�v���R�����g�A�E�g���āA��L�u�`�v�̃R�����g�A�E�g���O���ėL���ɂ��ĉ������B
--------------------------------------------------
// �߂�{�^�����������X�g�֖߂�
private function onBtnBack():void
{
	////////////////////////////////////////
	// [201609]�߂鏈���R�����g�A�E�g
	
	// �`�F�I�[�v�j���O�f���ɖ߂�B
	// st.goScreenTransition( 0, 6 );
	
	// �a�F�Q�[���^�C�g���ɖ߂�B
	st.goScreenTransition( 1 );		// �Q�[���^�C�g����ʂփW�����v

	////////////////////////////////////////
}
--------------------------------------------------


[SceneSpriteGameClear.as]
�����L�̃R�����g�A�E�g���O���ėL���ɂ��ĉ������B
--------------------------------------------------
	�F
		// �R�O�b�^�C���A�b�v�b�a
		private function onTimeUp(te:TimerEvent):void
		{
			// [201609]�߂鏈���R�����g�A�E�g
			//st.goScreenTransition( 0, 6 );
		}
--------------------------------------------------


��3.�C���X�g�[���[����

��L�����ŁAFlashDevelop��Ŏ��s����΁A�S�҂��m�F�ł��܂��B

�܂��Aair�C���X�g�[���[���쐬����ׂɂ́A
���L�o�b�`�t�@�C�������s���ĉ������B

PackageApp.bat

���uair�v�t�H���_���ɁA177M�ʂ̃C���X�g�[���[�i.air�j�����������ΐ����ł��B



[�ȏ�]
