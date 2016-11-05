; branched from Hunter Stats Open Source
#pragma compile(Out, entro-stats.exe)
#pragma compile(Icon, Icon\entro-stats.ico)
#NoTrayIcon

#include <GuiConstantsEx.au3>
#include <File.au3>
#include <Constants.au3>
#include <EditConstants.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GUIEdit.au3>
#include <ListBoxConstants.au3>
#include <GUIstatusbar.au3>
#include <ButtonConstants.au3>
#include <GuiTab.au3>
#include <Inet.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>

#include <HotKey_21b.au3>
#include <HotKeyInput.au3>
#include <vkConstants.au3>
#include <RestrictControlRegExp.au3>

Opt("GUICloseOnESC", 0)
Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)

Global Const $SC_DRAGMOVE = 0xF012
Global Const $GUI_ENABLE_1 = 64
Global Const $GUI_DISABLE_1 = 128
Global Const $all_items = ["w1","w2","w3","w3","w4","w5","w6","m1","m2","m3"]
Global Const $enhcs = ["w_enh_dmg", "w_enh_acc", "w_enh_eco", "w_enh_rng", "w_enh_skl", "m_enh_hea", "m_enh_eco", "m_enh_skl"]
Global Const $w_enh_dmg_default_cost = 80 * (400/100)
Global Const $w_enh_acc_default_cost = 40 * (350/100)
Global Const $w_enh_eco_default_cost = 100 * (350/100)
Global Const $w_enh_rng_default_cost = 40 * (350/100)
Global Const $w_enh_skl_default_cost = 60 * (350/100)
Global Const $m_enh_eco_default_cost = 60 * (350/100)
Global Const $m_enh_hea_default_cost = 40 * (350/100)
Global Const $m_enh_skl_default_cost = 60 * (350/100)

Dim $config_file = @ScriptDir & "\config.ini"
Dim $w1_file = @ScriptDir & "\w1.ini"
Dim $w2_file = @ScriptDir & "\w2.ini"
Dim $w3_file = @ScriptDir & "\w3.ini"
Dim $w4_file = @ScriptDir & "\w4.ini"
Dim $w5_file = @ScriptDir & "\w5.ini"
Dim $w6_file = @ScriptDir & "\w6.ini"
Dim $m1_file = @ScriptDir & "\m1.ini"
Dim $m2_file = @ScriptDir & "\m2.ini"
Dim $m3_file = @ScriptDir & "\m3.ini"
Dim $summary_file = @ScriptDir & "\summary.ini"
Dim $chat_log_line_number = 0 ; which line is currently being read
Dim $window_title = "EntroStats - Open Source"
Dim $chat_log_location, $chat_log_line
Dim $equipped_item, $last_item, $new, $hunting_log_line

Dim $dmgout_dmg_sum, $dmgout_hit_count, $dmgout_crit_count,  $dmgout_use_count, $dmgout_miss_count, $dmgout_hit_percent, $dmgout_crit_percent, $dmgout_macrit_percent
Dim $dmgin_dmg_sum, $dmgin_hit_count, $dmgin_crit_count, $dmgin_carm_count, $dmgin_reddmg_sum, $medicals_use_count, $medicals_heal_sum

Dim $w1_name, $w1_decay, $w1_ammo, $w1_amp_decay, $w1_amp_ammo, $w1_key="None", $w1_key_code=0, $w1_upm, $w1_dpu
Dim $w1_dmg_sum, $w1_cdmg_sum, $w1_use_count, $w1_hit_count, $w1_crit_count, $w1_miss_count, $w1_cdmg_min, $w1_cdmg_max, $w1_dmg_min, $w1_dmg_max
Dim $w1_cdmg_min, $w1_cdmg_max, $w1_dmg_min, $w1_dmg_max
Dim $w1_dpp, $w1_dps, $w1_hit_percent, $w1_crit_percent, $w1_crit_inc_percent, $w1_dmg_chk_percent, $w1_macrit_percent
Dim $w1_enh_dmg, $w1_enh_acc, $w1_enh_eco, $w1_enh_rng, $w1_enh_skl

Dim $w2_name, $w2_decay, $w2_ammo, $w2_amp_decay, $w2_amp_ammo, $w2_key="None", $w2_key_code=0, $w2_upm, $w2_dpu
Dim $w2_dmg_sum, $w2_cdmg_sum, $w2_use_count, $w2_hit_count, $w2_crit_count, $w2_miss_count, $w2_cdmg_min, $w2_cdmg_max, $w2_dmg_min, $w2_dmg_max
Dim $w2_cdmg_min, $w2_cdmg_max, $w2_dmg_min, $w2_dmg_max
Dim $w2_dpp, $w2_dps, $w2_hit_percent, $w2_crit_percent, $w2_crit_inc_percent, $w2_dmg_chk_percent, $w2_macrit_percent
Dim $w2_enh_dmg, $w2_enh_acc, $w2_enh_eco, $w2_enh_rng, $w2_enh_skl

Dim $w3_name, $w3_decay, $w3_ammo, $w3_amp_decay, $w3_amp_ammo, $w3_key="None", $w3_key_code=0, $w3_upm, $w3_dpu
Dim $w3_dmg_sum, $w3_cdmg_sum, $w3_use_count, $w3_hit_count, $w3_crit_count, $w3_miss_count, $w3_cdmg_min, $w3_cdmg_max, $w3_dmg_min, $w3_dmg_max
Dim $w3_cdmg_min, $w3_cdmg_max, $w3_dmg_min, $w3_dmg_max
Dim $w3_dpp, $w3_dps, $w3_hit_percent, $w3_crit_percent, $w3_crit_inc_percent, $w3_dmg_chk_percent, $w3_macrit_percent
Dim $w3_enh_dmg, $w3_enh_acc, $w3_enh_eco, $w3_enh_rng, $w3_enh_skl

Dim $w4_name, $w4_decay, $w4_ammo, $w4_amp_decay, $w4_amp_ammo, $w4_key="None", $w4_key_code=0, $w4_upm, $w4_dpu
Dim $w4_dmg_sum, $w4_cdmg_sum, $w4_use_count, $w4_hit_count, $w4_crit_count, $w4_miss_count, $w4_cdmg_min, $w4_cdmg_max, $w4_dmg_min, $w4_dmg_max
Dim $w4_cdmg_min, $w4_cdmg_max, $w4_dmg_min, $w4_dmg_max
Dim $w4_dpp, $w4_dps, $w4_hit_percent, $w4_crit_percent, $w4_crit_inc_percent, $w4_dmg_chk_percent, $w4_macrit_percent
Dim $w5_enh_dmg, $w5_enh_acc, $w5_enh_eco, $w5_enh_rng, $w5_enh_skl

Dim $w5_name, $w5_decay, $w5_ammo, $w5_amp_decay, $w5_amp_ammo, $w5_key="None", $w5_key_code=0, $w5_upm, $w5_dpu
Dim $w5_dmg_sum, $w5_cdmg_sum, $w5_use_count, $w5_hit_count, $w5_crit_count, $w5_miss_count, $w5_cdmg_min, $w5_cdmg_max, $w5_dmg_min, $w5_dmg_max
Dim $w5_cdmg_min, $w5_cdmg_max, $w5_dmg_min, $w5_dmg_max
Dim $w5_dpp, $w5_dps, $w5_hit_percent, $w5_crit_percent, $w5_crit_inc_percent, $w5_dmg_chk_percent, $w5_macrit_percent
Dim $w5_enh_dmg, $w5_enh_acc, $w5_enh_eco, $w5_enh_rng, $w6_enh_skl

Dim $w6_name, $w6_decay, $w6_ammo, $w6_amp_decay, $w6_amp_ammo, $w6_key="None", $w6_key_code=0, $w6_upm, $w6_dpu
Dim $w6_dmg_sum, $w6_cdmg_sum, $w6_use_count, $w6_hit_count, $w6_crit_count, $w6_miss_count, $w6_cdmg_min, $w6_cdmg_max, $w6_dmg_min, $w6_dmg_max
Dim $w6_cdmg_min, $w6_cdmg_max, $w6_dmg_min, $w6_dmg_max
Dim $w6_dpp, $w6_dps, $w6_hit_percent, $w6_crit_percent, $w6_crit_inc_percent, $w6_dmg_chk_percent, $w6_macrit_percent
Dim $w6_enh_dmg, $w6_enh_acc, $w6_enh_eco, $w6_enh_rng, $w6_enh_skl

Dim $m1_name, $m1_decay, $m1_key="None", $m1_key_code=0, $m1_upm, $m1_use_count, $m1_heal_sum
Dim $m1_hpp, $m1_hps, $m1_enh_hea, $m1_enh_eco, $m1_enh_skl

Dim $m2_name, $m2_decay, $m2_key="None", $m2_key_code=0, $m2_upm, $m2_use_count, $m2_heal_sum
Dim $m2_hpp, $m2_hps, $m2_enh_hea, $m2_enh_eco, $m2_enh_skl

Dim $m3_name, $m3_decay, $m3_key="None", $m3_key_code=0, $m3_upm, $m3_use_count, $m3_heal_sum
Dim $m3_hpp, $m3_hps, $m3_enh_hea, $m3_enh_eco, $m3_enh_skl

Dim $w_enh_dmg_cost, $w_enh_acc_cost, $w_enh_eco_cost, $w_enh_rng_cost, $w_enh_skl_cost, $m_enh_hea_cost, $m_enh_eco_cost, $m_enh_skl_cost

Dim $winClass="Entropia Universe Client", $winTitle=""
Dim $hWnd = 0

start()

Func start()
   GUI()
   Local $x
   ini_read_settings_general()
   ini_write_settings_general()
   ini_read_settings_items()
   ini_write_settings_items()
   ini_read_usage_items()
   ini_read_usage_summary()
   math_sum_dmgout()
   for $x = 0 to ubound($all_items)-1
	  math_item($all_items[$x])
   next
   gui_update_item_names()
   gui_update_summary_dmgout()
   gui_update_summary_dmgin()
   gui_update_summary_medicals()
   gui_update_settings_general()
   gui_update_settings_items()
   for $x = 0 to ubound($all_items)-1
	  gui_update_item_usage($all_items[$x])
   next
   gui_update_item_status()

   if not init_chat_read() then
	  GUISetState(@SW_SHOW, $gui_stgs_wnd)
   EndIf
   hotkeys_assign()
   wait_for_entropia_wnd()
   Local $wnd_check_time = TimerInit()
   Local $read_time = TimerInit()
   Local $save_time = TimerInit()
   While 1
	  If TimerDiff($read_time) >= 50 Then
		 $read_time = TimerInit()
		 $chat_log_line = FileReadLine($chat_log_location, $chat_log_line_number)
		 If StringLen($chat_log_line) > 1 Then
			 $chat_log_line_number += 1
			 read_log_line()
		  EndIf
	  EndIf
	  If TimerDiff($save_time) >= 60000 Then
		 $save_time = TimerInit()
		 ini_write_usage_items()
		 ini_write_usage_summary()
	  EndIf
	  If TimerDiff($wnd_check_time) >= 10000 Then
		 wait_for_entropia_wnd()
		 $wnd_check_time = TimerInit()
	  EndIf
	  Sleep(50)
   WEnd
EndFunc

Func wait_for_entropia_wnd()
   $hWnd = WingetHandle($winClass, $winTitle)
   local $isErr = @error
   if $isErr=1 Then
	  $equipped_item=""
	  GUICtrlSetData($gui_main_sum_item_status_grp, "[ WAITING FOR ENTROPIA WINDOW ]")
	  gui_update_item_status()
	  While $isErr=1
		 Sleep(10000)
		 $hWnd = WingetHandle($winClass, $winTitle)
		 $isErr = @error
	  WEnd
	  GUICtrlSetData($gui_main_sum_item_status_grp, "[ " & $gui_main_sum_item_status_grp_txt & " ]")
	  hotkeys_assign()
   EndIf
EndFunc

func init_chat_read()
   $chat_log_line_number = _FileCountLines2($chat_log_location) ; get last line of chat.log
   If not @error Then
	  if $chat_log_line_number = 0 Then
		 msgbox(0,"Error", "Chat lines return is 0")
		 return False
	  Else
		 if $chat_log_line_number > 24999 Then
			;~ 		-========== Split chat.log =========
			Local $CurDate = @YEAR & @MON & @MDAY
			Local $CurDateSep = @YEAR & "-" & @MON & "-" & @MDAY
			Local $CurTime = @HOUR & @MIN & @SEC
			Local $CurTimeSep = @HOUR & @MIN & @SEC
			FileCopy ( $chat_log_location, StringTrimRight($chat_log_location, 4) & "-" & $CurDate & "-" & $CurTime & ".log" )
			Local $hFile = FileOpen($chat_log_location, 2)
			If $hFile = -1 Then
			   MsgBox(0, "Error", "Unable to open chat.log file.")
			   return False
			Else
			   FileWriteLine($hFile, $CurDateSep & " " & $CurTimeSep & " [EntropiaStats] Backup created. Creating new file.")
			   FileClose($hFile)
			   $chat_log_line_number = 1
			EndIf
		 EndIf
	  EndIf
   Else
	  msgbox(0,"Error", "chat.log file cannot be read")
	  return False
   endif
   return true
EndFunc

Func equip_item($pressed_key)
    local $cnt
	for $cnt = 0 to ubound($all_items)-1
		if Eval($all_items[$cnt] & "_key_code") = $pressed_key Then
		    $equipped_item = $all_items[$cnt]
			If $equipped_item <> $last_item Then
			   $last_item = $equipped_item
			   gui_update_item_status()
			EndIf
	    EndIf
	 next
EndFunc

Func hotkeys_assign()
   _HotKey_Release()
   local $x
	for $x = 0 to ubound($all_items)-1
		if Eval($all_items[$x] & "_key_code") <> 0 Then
			_HotKey_Assign(Eval($all_items[$x] & "_key_code") + 0, 'equip_item', BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL, $HK_FLAG_NOBLOCKHOTKEY), $hWnd)
	    EndIf
	next
EndFunc

Func window_events()
    Local $msg, $cnt
	$msg = @GUI_CtrlId
	Select
		 Case $msg = $GUI_Event_Close or $msg = $gui_main_file_exit_itm
			ini_write_settings_general()
			ini_write_settings_items()
			ini_write_usage_items()
			ini_write_usage_summary()
			Exit
		 Case $msg = $gui_main_edit_settings_itm
			GUISetState(@SW_DISABLE, $gui_main_wnd)
			GUISetState(@SW_SHOW, $gui_stgs_wnd)
		 Case $msg = $gui_stgs_gen_main_chatlog_location_btn
			gui_change_file_location(@UserProfileDir & "\Documents\Entropia Universe\", "chat_log_location", "chat.log", "log files (*.log)")
		 Case $msg = $gui_stgs_exit_btn
			if gui_read_settings_general() and gui_read_settings_items() Then
			   ini_write_settings_general()
			   ini_write_settings_items()
			   hotkeys_assign()
			   math_sum_dmgout()
			   for $cnt = 0 to ubound($all_items)-1
				  math_item($all_items[$cnt])
			   next
			   gui_update_item_names()
			   gui_update_item_status()
			   GUISetState(@SW_HIDE, $gui_stgs_wnd)
			   GUISetState(@SW_ENABLE, $gui_main_wnd)
			   WinActivate($gui_main_wnd)
			EndIf
		 Case $msg = $gui_stgs_cancel_btn
			GUISetState(@SW_HIDE, $gui_stgs_wnd)
			gui_update_settings_general()
			gui_update_settings_items()
			GUISetState(@SW_ENABLE, $gui_main_wnd)
			WinActivate($gui_main_wnd)
		 Case $msg = $gui_main_sum_dmgout_reset_btn
			if gui_confirm_reset() Then reset_summary_dmgout()
		 Case $msg = $gui_main_sum_dmgin_reset_btn
			if gui_confirm_reset() then reset_summary_dmgin()
		 Case $msg = $gui_main_sum_medical_reset_btn
			if gui_confirm_reset() then reset_summary_medical()
		 Case $msg = $gui_main_wpn1_w1_reset_btn
			if gui_confirm_reset() Then reset_item("w1")
		 Case $msg = $gui_main_wpn1_w2_reset_btn
			if gui_confirm_reset() Then reset_item("w2")
		 Case $msg = $gui_main_wpn1_w3_reset_btn
			if gui_confirm_reset() Then reset_item("w3")
		 Case $msg = $gui_main_wpn2_w4_reset_btn
			if gui_confirm_reset() Then reset_item("w4")
		 Case $msg = $gui_main_wpn2_w5_reset_btn
			if gui_confirm_reset() Then reset_item("w5")
		 Case $msg = $gui_main_wpn2_w6_reset_btn
			if gui_confirm_reset() Then reset_item("w6")
		 Case $msg = $gui_main_medicals_m1_reset_btn
			if gui_confirm_reset() Then reset_item("m1")
		 Case $msg = $gui_main_medicals_m2_reset_btn
			if gui_confirm_reset() Then reset_item("m2")
		 Case $msg = $gui_main_medicals_m3_reset_btn
			if gui_confirm_reset() Then reset_item("m3")
		 Case $msg = $gui_main_help_about_itm
			GUISetState(@SW_DISABLE, $gui_main_wnd)
			GUISetState(@SW_SHOW, $gui_about_wnd)
			WinActivate($gui_main_wnd)
		 Case $msg = $gui_about_ok_btn
			GUISetState(@SW_HIDE, $gui_about_wnd)
			GUISetState(@SW_ENABLE, $gui_main_wnd)
			WinActivate($gui_main_wnd)
	EndSelect
EndFunc   ;==>window_events

Func read_log_line()
    Local $dmgout, $cdmgout, $miss, $dmgin, $cdmgin, $carmin, $reddmgin, $redarmin, $heal, $enh
	Local $item_type, $enh_type
	$dmgout = StringRegExp($chat_log_line, "] You inflicted", 0)
	$cdmgout = StringRegExp($chat_log_line, "] Critical hit - additional damage! You inflict", 0)
	$miss = (StringRegExp($chat_log_line, "] Target evaded attack", 0) or StringRegExp($chat_log_line, "] You missed", 0))
	$dmgin = StringRegExp($chat_log_line, "] You take", 0)
	$cdmgin = StringRegExp($chat_log_line, "] Critical hit - additional damage! You take", 0)
	$carmin = StringRegExp($chat_log_line, "] Critical hit - armor penetration! You take", 0)
	$redarmin = StringRegExp($chat_log_line, "] Reduced .*? points of armor", 0)
	$reddmgin = StringRegExp($chat_log_line, "] Reduced .*? points of critical", 0)
	$heal = StringRegExp($chat_log_line, "] You healed", 0)
	$enh = StringRegExp($chat_log_line, "] Your enhancer", 0)
	Select
		 Case $dmgout = 1
			$new = StringRegExpReplace($chat_log_line, "[^0-9.\s]", "")
			$new = StringTrimRight($new, 2)
			$new = StringTrimLeft($new, 3 + 17)
			$dmgout_dmg_sum += $new
			$dmgout_hit_count += 1
			$hunting_log_line = "-> " & $new
			$dmgout_use_count += 1
			math_sum_dmgout()
			if (StringLen($equipped_item)=2) and (StringTrimRight($equipped_item, 1)="w") Then
			   dmgout_weapon($equipped_item, false)
			   math_item($equipped_item)
			   gui_update_item_usage($equipped_item)
			EndIf
			gui_update_summary_dmgout()
			gui_update_logboxes()

		Case $cdmgout = 1
			$new = StringRegExpReplace($chat_log_line, "[^0-9.\s]", "")
			$new = StringTrimRight($new, 2)
			$new = StringTrimLeft($new, 8 + 17)
			$dmgout_dmg_sum += $new
			$dmgout_hit_count += 1
			$dmgout_crit_count += 1
			$hunting_log_line = "-> !" & $new
			$dmgout_use_count += 1
			math_sum_dmgout()
			if (StringLen($equipped_item)=2) and (StringTrimRight($equipped_item, 1)="w") Then
			   cdmgout_weapon($equipped_item)
			   math_item($equipped_item)
			   gui_update_item_usage($equipped_item)
			EndIf
			gui_update_summary_dmgout()
			gui_update_logboxes()

		Case $miss = 1
			$new = StringTrimLeft($chat_log_line, 2 + 17 + 12)
			$dmgout_miss_count += 1
			$hunting_log_line = "-> miss"
			$dmgout_use_count += 1
			math_sum_dmgout()
			if (StringLen($equipped_item)=2) and (StringTrimRight($equipped_item, 1)="w") Then
			   miss_weapon($equipped_item)
			   math_item($equipped_item)
			   gui_update_item_usage($equipped_item)
			EndIf
			gui_update_summary_dmgout()
			gui_update_logboxes()

		Case $dmgin = 1
			$new = StringRegExpReplace($chat_log_line, "[^0-9.\s]", "")
			$new = StringTrimRight($new, 2)
			$new = StringTrimLeft($new, 3 + 17)
			$dmgin_dmg_sum += $new
			$dmgin_hit_count += 1
			$hunting_log_line = "<- " & $new
			gui_update_summary_dmgin()
			gui_update_logboxes()

		Case $cdmgin = 1
			$new = StringRegExpReplace($chat_log_line, "[^0-9.\s]", "")
			$new = StringTrimRight($new, 2)
			$new = StringTrimLeft($new, 7 + 17)
			$dmgin_dmg_sum += $new
			$dmgin_hit_count += 1
			$dmgin_crit_count += 1
			$hunting_log_line = "<- !" & $new
			gui_update_summary_dmgin()
			gui_update_logboxes()

		Case $carmin = 1
			$new = StringRegExpReplace($chat_log_line, "[^0-9.\s]", "")
			$new = StringTrimRight($new, 2)
			$new = StringTrimLeft($new, 17+7)
			$dmgin_dmg_sum += $new
			$dmgin_hit_count += 1
			$dmgin_carm_count += 1
			$hunting_log_line = "<- !" & $new
			gui_update_summary_dmgin()
			gui_update_logboxes()

		Case $reddmgin = 1
			$new = StringRegExpReplace($chat_log_line, "[^0-9.\s]", "")
			$new = StringTrimRight($new, 2)
			$new = StringTrimLeft($new, 17+2)
			$dmgin_reddmg_sum += $new
			$hunting_log_line = "<- Reduced crit damage: " & $new
			gui_update_summary_dmgin()
			gui_update_logboxes()

		Case $redarmin = 1
			$new = StringRegExpReplace($chat_log_line, "[^0-9.\s]", "")
			$new = StringTrimRight($new, 4)
			$new = StringTrimLeft($new, 17+2)
			$dmgin_reddmg_sum += $new
			$hunting_log_line = "<- Reduced armor damage: " & $new
			gui_update_summary_dmgin()
			gui_update_logboxes()

		Case $heal = 1
			$new = StringRegExpReplace($chat_log_line, "[^0-9.\s]", "")
			$new = StringTrimRight($new, 2)
			$new = StringTrimLeft($new, 4 + 17)
			$medicals_use_count += 1
			$medicals_heal_sum += $new
			$hunting_log_line = "-> heal " & $new
			if (StringLen($equipped_item)=2) and (StringTrimRight($equipped_item, 1)="m") Then
			   heal_medical($equipped_item)
			   math_item($equipped_item)
			   gui_update_item_usage($equipped_item)
			EndIf
			gui_update_summary_medicals()
			gui_update_logboxes()

		Case $enh = 1
		   if (StringLen($equipped_item)=2) Then
			   $item_type=""
			   $enh_type=""
			   if StringRegExp($chat_log_line, "] Your enhancer Weapon Accuracy Enhancer", 0) = 1 then
				  $item_type = "w"
				  $enh_type = "acc"
			   EndIf
			   if StringRegExp($chat_log_line, "] Your enhancer Weapon Damage Enhancer", 0) = 1 then
				  $item_type = "w"
				  $enh_type = "dmg"
			   EndIf
			   if StringRegExp($chat_log_line, "] Your enhancer Weapon Economy Enhancer", 0) = 1 then
				  $item_type = "w"
				  $enh_type = "eco"
			   EndIf
			   if StringRegExp($chat_log_line, "] Your enhancer Weapon Range Enhancer", 0) = 1 then
				  $item_type = "w"
				  $enh_type = "rng"
			   EndIf
			   if StringRegExp($chat_log_line, "] Your enhancer Weapon Skill Modification Enhancer", 0) = 1 then
				  $item_type = "w"
				  $enh_type = "skl"
			   EndIf
			   if StringRegExp($chat_log_line, "] Your enhancer Medical Tool Economy Enhancer", 0) = 1 then
				  $item_type = "m"
				  $enh_type = "eco"
			   EndIf
			   if StringRegExp($chat_log_line, "] Your enhancer Medical Tool Heal Enhancer", 0) = 1 then
				  $item_type = "m"
				  $enh_type = "hea"
			   EndIf
			   if StringRegExp($chat_log_line, "] Your enhancer Medical Tool Skill Modification Enhancer", 0) = 1 then
				  $item_type = "m"
				  $enh_type = "skl"
			   EndIf
			   if (StringLen($enh_type)=3) and (StringTrimRight($equipped_item, 1)=$item_type) Then
					 Assign($equipped_item & "_enh_" & $enh_type, Eval($equipped_item & "_enh_" & $enh_type) + 1, 4)
					 gui_update_item_usage($equipped_item)
					 $hunting_log_line = $item_type & " - " & $enh_type & " enhancer broke"
			   EndIf
		  EndIf
		  gui_update_logboxes()
	EndSelect
EndFunc   ;==>read_log_line

Func dmgout_weapon($x, $fromCrit)
    if (not($fromCrit)) Then
	  if (Eval($x & "_dmg_min")=0) or ($new + 0 < Eval($x & "_dmg_min")) Then
		 Assign($x & "_dmg_min", $new + 0, 4)
	  EndIf
	  if ($new + 0 > Eval($x & "_dmg_max")) Then
		 Assign($x & "_dmg_max", $new + 0, 4)
	  EndIf
	EndIf
    Assign($x & "_dmg_sum", Eval($x & "_dmg_sum") + $new, 4)
	Assign($x & "_use_count", Eval($x & "_use_count") + 1, 4)
	Assign($x & "_hit_count", Eval($x & "_hit_count") + 1, 4)
EndFunc

Func cdmgout_weapon($x)
	dmgout_weapon($x, true)
	if (Eval($x & "_cdmg_min")=0) or ($new + 0 < Eval($x & "_cdmg_min")) Then
	   Assign($x & "_cdmg_min", $new + 0, 4)
    EndIf
	if ($new > Eval($x & "_cdmg_max")) Then
	   Assign($x & "_cdmg_max", $new + 0, 4)
    EndIf
	Assign($x & "_cdmg_sum", Eval($x & "_cdmg_sum") + $new, 4)
	Assign($x & "_crit_count", Eval($x & "_crit_count") + 1, 4)
EndFunc

Func miss_weapon($x)
	Assign($x & "_use_count", Eval($x & "_use_count") + 1, 4)
	Assign($x & "_miss_count", Eval($x & "_miss_count") + 1, 4)
EndFunc

Func math_sum_dmgout()
    if $dmgout_use_count = 0 then
	   $dmgout_hit_percent = 0
	   $dmgout_crit_percent = 0
	   $dmgout_macrit_percent = 0
    Else
	  $dmgout_hit_percent = ($dmgout_hit_count / $dmgout_use_count) * 100
	  $dmgout_crit_percent = ($dmgout_crit_count / $dmgout_use_count) * 100
	  $dmgout_macrit_percent = ($dmgout_crit_count / $dmgout_hit_count) * 100
   EndIf
EndFunc

Func math_item($x)
   local $enh_cost, $noncrit_dmg_avg, $cdmg_avg
   if (StringTrimRight($x, 1) = "w") then
	    $enh_cost = (Eval($x & "_enh_dmg") * $w_enh_dmg_cost) + (Eval($x & "_enh_acc") * $w_enh_acc_cost) + (Eval($x & "_enh_eco") * $w_enh_eco_cost) + (Eval($x & "_enh_rng") * $w_enh_rng_cost) + (Eval($x & "_enh_skl") * $w_enh_skl_cost)
		if (Eval($x & "_hit_count") = 0) Then
		   Assign($x & "_macrit_percent", 0, 4)
	    Else
		   Assign($x & "_macrit_percent", (Eval($x & "_crit_count") / Eval($x & "_hit_count")) * 100, 4)
	    EndIf
		if (Eval($x & "_use_count") = 0) Then
			Assign($x & "_dpp", 0, 4)
			Assign($x & "_hit_percent", 0, 4)
			Assign($x & "_crit_percent", 0, 4)
			Assign($x & "_dps", 0, 4)
		 Else
			Assign($x & "_dpp", (Eval($x & "_dmg_sum") / Eval($x & "_use_count")) / (Eval($x & "_decay") + Eval($x & "_amp_decay") + Eval($x & "_ammo") + Eval($x & "_amp_ammo") + ($enh_cost / Eval($x & "_use_count"))), 4)
			Assign($x & "_hit_percent", (Eval($x & "_hit_count") / Eval($x & "_use_count")) * 100, 4)
			Assign($x & "_crit_percent", (Eval($x & "_crit_count") / Eval($x & "_use_count")) * 100, 4)
			Assign($x & "_dps", (Eval($x & "_dmg_sum") / Eval($x & "_use_count")) * (Eval($x & "_upm")/60), 4)
		EndIf
		if (Eval($x & "_crit_count") = 0) or (Eval($x & "_hit_count") = 0) or (Eval($x & "_dpu") = 0) Then
		   Assign($x & "_dmg_chk_percent", 0,4)
		   Assign($x & "_crit_inc_percent", 0,4)
	    Else
		   $noncrit_dmg_avg = (Eval($x & "_dmg_sum") - Eval($x & "_cdmg_sum")) / (Eval($x & "_hit_count") - Eval($x & "_crit_count"))
		   $cdmg_avg = Eval($x & "_cdmg_sum") / Eval($x & "_crit_count")
		   Assign($x & "_dmg_chk_percent", ($noncrit_dmg_avg / Eval($x & "_dpu")) * 100, 4)
		   Assign($x & "_crit_inc_percent", (((($cdmg_avg - $noncrit_dmg_avg )) / Eval($x & "_dpu")) * 100), 4)
	    EndIf
   Else
	    $enh_cost = (Eval($x & "_enh_hea") * $m_enh_hea_cost) + (Eval($x & "_enh_eco") * $m_enh_eco_cost) + (Eval($x & "_enh_skl") * $m_enh_skl_cost)
		 if (Eval($x & "_use_count") = 0) Then
			Assign($x & "_hpp", 0, 4)
			Assign($x & "_hps", 0, 4)
		 Else
			Assign($x & "_hpp", (Eval($x & "_heal_sum") / Eval($x & "_use_count")) / (Eval($x & "_decay") + ($enh_cost / Eval($x & "_use_count"))), 4)
			Assign($x & "_hps", (Eval($x & "_heal_sum") / Eval($x & "_use_count")) * (Eval($x & "_upm")/60), 4)
		 EndIf
	endif
EndFunc

Func reset_summary_dmgout()
	$dmgout_hit_count = 0
	$dmgout_crit_count = 0
	$dmgout_miss_count = 0
	$dmgout_use_count = 0
	$dmgout_dmg_sum = 0
	$dmgout_hit_percent = 0
	$dmgout_crit_percent = 0
	$dmgout_macrit_percent = 0
	gui_update_summary_dmgout()
EndFunc

Func reset_summary_dmgin()
	$dmgin_hit_count = 0
	$dmgin_crit_count = 0
	$dmgin_dmg_sum = 0
	$dmgin_carm_count = 0
	$dmgin_reddmg_sum = 0
	gui_update_summary_dmgin()
EndFunc

Func reset_summary_medical()
	$medicals_heal_sum = 0
	$medicals_use_count = 0
	gui_update_summary_medicals()
EndFunc

Func reset_item($x)
   if (StringTrimRight($x, 1) = "w") then
		Assign($x & "_hit_count", 0, 4)
		Assign($x & "_crit_count", 0, 4)
		Assign($x & "_miss_count", 0, 4)
		Assign($x & "_use_count", 0, 4)
		Assign($x & "_dmg_sum", 0, 4)
		Assign($x & "_enh_count", 0, 4)
		Assign($x & "_hit_percent", 0, 4)
		Assign($x & "_crit_percent", 0, 4)
		Assign($x & "_macrit_percent", 0, 4)
		Assign($x & "_crit_inc_percent", 0, 4)
		Assign($x & "_dmg_chk_percent", 0, 4)
		Assign($x & "_dmg_min", 0, 4)
		Assign($x & "_dmg_max", 0, 4)
		Assign($x & "_cdmg_min", 0, 4)
		Assign($x & "_cdmg_max", 0, 4)
		Assign($x & "_cdmg_sum", 0, 4)
		Assign($x & "_enh_dmg", 0, 4)
		Assign($x & "_enh_acc", 0, 4)
		Assign($x & "_enh_eco", 0, 4)
		Assign($x & "_enh_rng", 0, 4)
		Assign($x & "_enh_skl", 0, 4)
		Assign($x & "_dpp", 0, 4)
		Assign($x & "_dps", 0, 4)
	Else
		Assign($x & "_use_count", 0, 4)
		Assign($x & "_heal_sum", 0, 4)
		Assign($x & "_hpp", 0, 4)
		Assign($x & "_hps", 0, 4)
		Assign($x & "_enh_hea", 0, 4)
		Assign($x & "_enh_eco", 0, 4)
		Assign($x & "_enh_skl", 0, 4)
	EndIf
	gui_update_item_usage($x)
EndFunc

Func heal_medical($x)
	Assign($x & "_heal_sum", Eval($x & "_heal_sum") + $new, 4)
	Assign($x & "_use_count", Eval($x & "_use_count") + 1, 4)
EndFunc

Func ini_write_settings_general()
    Local $cnt
	IniWrite($config_file, "Main Settings", "chat.log", $chat_log_location)
	for $cnt = 0 to UBound($enhcs)-1
	   IniWrite($config_file, "Enhancers", $enhcs[$cnt] & "_cost", Eval( $enhcs[$cnt] & "_cost"))
    next
EndFunc

Func ini_write_settings_items()
   Local $x
   for $x = 0 to ubound($all_items)-1
   if (StringTrimRight($all_items[$x], 1) = "w") then
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "name", Eval($all_items[$x] & "_name"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "decay", Eval($all_items[$x] & "_decay"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "ammo", Eval($all_items[$x] & "_ammo"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "amp_decay", Eval($all_items[$x] & "_amp_decay"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "amp_ammo", Eval($all_items[$x] & "_amp_ammo"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "key", Eval($all_items[$x] & "_key"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "key_code", Eval($all_items[$x] & "_key_code"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "upm", Eval($all_items[$x] & "_upm"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "dpu", Eval($all_items[$x] & "_dpu"))
   Else
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "name", Eval($all_items[$x] & "_name"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "decay", Eval($all_items[$x] & "_decay"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "key", Eval($all_items[$x] & "_key"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "key_code", Eval($all_items[$x] & "_key_code"))
	   IniWrite(Eval($all_items[$x] & "_file"), "Settings", "upm", Eval($all_items[$x] & "_upm"))
 EndIf
 next
EndFunc

 Func ini_write_usage_items()
   Local $x
   for $x = 0 to ubound($all_items)-1
   if (StringTrimRight($all_items[$x], 1) = "w") then
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "hit_count", Eval($all_items[$x] & "_hit_count"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "crit_count", Eval($all_items[$x] & "_crit_count"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "miss_count", Eval($all_items[$x] & "_miss_count"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "use_count", Eval($all_items[$x] & "_use_count"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "dmg_sum", Eval($all_items[$x] & "_dmg_sum"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "cdmg_sum", Eval($all_items[$x] & "_cdmg_sum"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "cdmg_min", Eval($all_items[$x] & "_cdmg_min"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "cdmg_max", Eval($all_items[$x] & "_cdmg_max"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "dmg_min", Eval($all_items[$x] & "_dmg_min"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "dmg_max", Eval($all_items[$x] & "_dmg_max"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "enh_dmg", Eval($all_items[$x] & "_enh_dmg"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "enh_acc", Eval($all_items[$x] & "_enh_acc"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "enh_eco", Eval($all_items[$x] & "_enh_eco"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "enh_rng", Eval($all_items[$x] & "_enh_rng"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "enh_skl", Eval($all_items[$x] & "_enh_skl"))
 Else
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "heal_sum", Eval($all_items[$x] & "_heal_sum"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "use_count", Eval($all_items[$x] & "_use_count"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "enh_eco", Eval($all_items[$x] & "_enh_eco"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "enh_hea", Eval($all_items[$x] & "_enh_hea"))
	IniWrite(Eval($all_items[$x] & "_file"), "Usage", "enh_skl", Eval($all_items[$x] & "_enh_skl"))
	EndIf
	next
EndFunc

Func ini_write_usage_summary()
	IniWrite(Eval("summary_file"), "Usage", "dmgin_hit_count", Eval("dmgin_hit_count"))
	IniWrite(Eval("summary_file"), "Usage", "dmgin_crit_count", Eval("dmgin_crit_count"))
	IniWrite(Eval("summary_file"), "Usage", "dmgin_dmg_sum", Eval("dmgin_dmg_sum"))
	IniWrite(Eval("summary_file"), "Usage", "dmgin_carm_count", Eval("dmgin_carm_count"))
	IniWrite(Eval("summary_file"), "Usage", "dmgin_reddmg_sum", Eval("dmgin_reddmg_sum"))
	IniWrite(Eval("summary_file"), "Usage", "dmgout_hit_count", Eval("dmgout_hit_count"))
	IniWrite(Eval("summary_file"), "Usage", "dmgout_crit_count", Eval("dmgout_crit_count"))
	IniWrite(Eval("summary_file"), "Usage", "dmgout_dmg_sum", Eval("dmgout_dmg_sum"))
	IniWrite(Eval("summary_file"), "Usage", "dmgout_miss_count", Eval("dmgout_miss_count"))
	IniWrite(Eval("summary_file"), "Usage", "dmgout_use_count", Eval("dmgout_use_count"))
	IniWrite(Eval("summary_file"), "Usage", "medicals_use_count", Eval("medicals_use_count"))
	IniWrite(Eval("summary_file"), "Usage", "medicals_heal_sum", Eval("medicals_heal_sum"))
EndFunc

Func ini_read_settings_general()
    Local $cnt
	$chat_log_location = IniRead($config_file, "Main Settings", "chat.log", @UserProfileDir & "\Documents\Entropia Universe\chat.log")
	for $cnt = 0 to UBound($enhcs)-1
	   Assign($enhcs[$cnt] & "_cost", IniRead($config_file, "Enhancers", $enhcs[$cnt] & "_cost", Eval($enhcs[$cnt] & "_default_cost")), 4)
    next
EndFunc

Func ini_read_settings_items()
   Local $x
   for $x = 0 to ubound($all_items)-1
   if (StringTrimRight($all_items[$x], 1) = "w") then
	   Assign($all_items[$x] & "_name", IniRead(Eval($all_items[$x] & "_file"), "Settings", "name", ""), 4)
	   Assign($all_items[$x] & "_decay", IniRead(Eval($all_items[$x] & "_file"), "Settings", "decay", 0), 4)
	   Assign($all_items[$x] & "_ammo", IniRead(Eval($all_items[$x] & "_file"), "Settings", "ammo", 0), 4)
	   Assign($all_items[$x] & "_amp_decay", IniRead(Eval($all_items[$x] & "_file"), "Settings", "amp_decay", 0), 4)
	   Assign($all_items[$x] & "_amp_ammo", IniRead(Eval($all_items[$x] & "_file"), "Settings", "amp_ammo", 0), 4)
	   Assign($all_items[$x] & "_key", IniRead(Eval($all_items[$x] & "_file"), "Settings", "key", "None"), 4)
	   Assign($all_items[$x] & "_key_code", IniRead(Eval($all_items[$x] & "_file"), "Settings", "key_code", 0), 4)
	   Assign($all_items[$x] & "_upm", IniRead(Eval($all_items[$x] & "_file"), "Settings", "upm", 0), 4)
	   Assign($all_items[$x] & "_dpu", IniRead(Eval($all_items[$x] & "_file"), "Settings", "dpu", 0), 4)
	Else
	   Assign($all_items[$x] & "_name", IniRead(Eval($all_items[$x] & "_file"), "Settings", "name", 0), 4)
	   Assign($all_items[$x] & "_decay", IniRead(Eval($all_items[$x] & "_file"), "Settings", "decay", 0), 4)
	   Assign($all_items[$x] & "_key", IniRead(Eval($all_items[$x] & "_file"), "Settings", "key", "None"), 4)
	   Assign($all_items[$x] & "_key_code", IniRead(Eval($all_items[$x] & "_file"), "Settings", "key_code", 0), 4)
	   Assign($all_items[$x] & "_upm", IniRead(Eval($all_items[$x] & "_file"), "Settings", "upm", 0), 4)
	EndIf
 next
EndFunc

Func ini_read_usage_items()
   Local $x
   for $x = 0 to ubound($all_items)-1
   if (StringTrimRight($all_items[$x], 1) = "w") then
	Assign($all_items[$x] & "_hit_count", IniRead(Eval($all_items[$x] & "_file"), "Usage", "hit_count", 0), 4)
	Assign($all_items[$x] & "_crit_count", IniRead(Eval($all_items[$x] & "_file"), "Usage", "crit_count", 0), 4)
	Assign($all_items[$x] & "_miss_count", IniRead(Eval($all_items[$x] & "_file"), "Usage", "miss_count", 0), 4)
	Assign($all_items[$x] & "_use_count", IniRead(Eval($all_items[$x] & "_file"), "Usage", "use_count", 0), 4)
	Assign($all_items[$x] & "_dmg_sum", IniRead(Eval($all_items[$x] & "_file"), "Usage", "dmg_sum", 0), 4)
	Assign($all_items[$x] & "_cdmg_sum", IniRead(Eval($all_items[$x] & "_file"), "Usage", "cdmg_sum", 0), 4)
	Assign($all_items[$x] & "_cdmg_min", IniRead(Eval($all_items[$x] & "_file"), "Usage", "cdmg_min", 0), 4)
	Assign($all_items[$x] & "_cdmg_max", IniRead(Eval($all_items[$x] & "_file"), "Usage", "cdmg_max", 0), 4)
	Assign($all_items[$x] & "_dmg_min", IniRead(Eval($all_items[$x] & "_file"), "Usage", "dmg_min", 0), 4)
	Assign($all_items[$x] & "_dmg_max", IniRead(Eval($all_items[$x] & "_file"), "Usage", "dmg_max", 0), 4)
	Assign($all_items[$x] & "_enh_dmg", IniRead(Eval($all_items[$x] & "_file"), "Usage", "enh_dmg", 0), 4)
	Assign($all_items[$x] & "_enh_acc", IniRead(Eval($all_items[$x] & "_file"), "Usage", "enh_acc", 0), 4)
	Assign($all_items[$x] & "_enh_eco", IniRead(Eval($all_items[$x] & "_file"), "Usage", "enh_eco", 0), 4)
	Assign($all_items[$x] & "_enh_rng", IniRead(Eval($all_items[$x] & "_file"), "Usage", "enh_rng", 0), 4)
	Assign($all_items[$x] & "_enh_skl", IniRead(Eval($all_items[$x] & "_file"), "Usage", "enh_skl", 0), 4)
 Else
	Assign($all_items[$x] & "_heal_sum", IniRead(Eval($all_items[$x] & "_file"), "Usage", "heal_sum", 0), 4)
	Assign($all_items[$x] & "_use_count", IniRead(Eval($all_items[$x] & "_file"), "Usage", "use_count", 0), 4)
	Assign($all_items[$x] & "_enh_eco", IniRead(Eval($all_items[$x] & "_file"), "Usage", "enh_eco", 0), 4)
	Assign($all_items[$x] & "_enh_hea", IniRead(Eval($all_items[$x] & "_file"), "Usage", "enh_hea", 0), 4)
	Assign($all_items[$x] & "_enh_skl", IniRead(Eval($all_items[$x] & "_file"), "Usage", "enh_skl", 0), 4)
 EndIf
 next
EndFunc

Func ini_read_usage_summary()
	Assign("dmgin_hit_count", IniRead(Eval("summary_file"), "Usage", "dmgin_hit_count", 0), 4)
	Assign("dmgin_crit_count", IniRead(Eval("summary_file"), "Usage", "dmgin_crit_count", 0), 4)
	Assign("dmgin_dmg_sum", IniRead(Eval("summary_file"), "Usage", "dmgin_dmg_sum", 0), 4)
	Assign("dmgin_carm_count", IniRead(Eval("summary_file"), "Usage", "dmgin_carm_count", 0), 4)
	Assign("dmgin_reddmg_sum", IniRead(Eval("summary_file"), "Usage", "dmgin_reddmg_sum", 0), 4)
	Assign("dmgout_hit_count", IniRead(Eval("summary_file"), "Usage", "dmgout_hit_count", 0), 4)
	Assign("dmgout_crit_count", IniRead(Eval("summary_file"), "Usage", "dmgout_crit_count", 0), 4)
	Assign("dmgout_miss_count", IniRead(Eval("summary_file"), "Usage", "dmgout_miss_count", 0), 4)
	Assign("dmgout_use_count", IniRead(Eval("summary_file"), "Usage", "dmgout_use_count", 0), 4)
	Assign("dmgout_dmg_sum", IniRead(Eval("summary_file"), "Usage", "dmgout_dmg_sum", 0), 4)
	Assign("medicals_use_count", IniRead(Eval("summary_file"), "Usage", "medicals_use_count", 0), 4)
	Assign("medicals_heal_sum", IniRead(Eval("summary_file"), "Usage", "medicals_heal_sum", 0), 4)
EndFunc

Func gui_read_settings_general()
    Local $cnt
	Local $test
	$chat_log_location = GUICtrlRead($gui_stgs_gen_main_chatlog_location_inp)
    for $cnt = 0 to UBound($enhcs)-1
	   $test = GUICtrlRead(Eval("gui_stgs_gen_enh_" & $enhcs[$cnt] & "_cost_inp")) + 0
	   if $test=0 then
		  msgbox(0x0 + 0x10, $enhcs[$cnt], "value should not be 0")
		  return False
	   EndIf
    Next
    for $cnt = 0 to UBound($enhcs)-1
	   Assign ($enhcs[$cnt] & "_cost", GUICtrlRead(Eval("gui_stgs_gen_enh_" & $enhcs[$cnt] & "_cost_inp")) + 0, 4)
    Next
	return True
EndFunc

Func gui_read_settings_items()
   Local $x, $tab, $test
   for $x = 0 to ubound($all_items)-1
   if (StringTrimRight($all_items[$x], 1) = "w") then
		if ($x < 4) then
			$tab = 1
		else
			$tab = 2
		 EndIf

	    if _GUICtrlHKI_GetHotKey(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_key_inp")) <> 0 Then
		 $test = StringStripWS(GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_name_inp")), $STR_STRIPALL)
		   if $test = "" then
			  MsgBox(0x0 + 0x10, $all_items[$x], "name is mandatory")
			  return False
		   EndIf
		   $test = (GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_decay_inp")) + 0)
		   $test = $test + (GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_ammo_inp")) + 0)
		   $test = $test + (GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_amp_decay_inp")) + 0)
		   $test = $test + (GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_amp_ammo_inp")) + 0)
		   if $test=0 Then
			   msgbox(0x0 + 0x10, $all_items[$x], "expense should not be 0")
			   return False
		   EndIf
		   $test = GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_upm_inp")) + 0
		   if $test=0 Then
			   msgbox(0x0 + 0x10, $all_items[$x], "upm should not be 0")
			   return False
		   EndIf
		   $test = GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_dpu_inp")) + 0
		   if $test=0 Then
			   msgbox(0x0 + 0x10, $all_items[$x], "dpu should not be 0")
			   return False
		   EndIf
	    EndIf
		Assign($all_items[$x] & "_name", GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_name_inp")), 4)
		Assign($all_items[$x] & "_decay", GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_decay_inp")) + 0, 4)
		Assign($all_items[$x] & "_ammo", GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_ammo_inp")) + 0, 4)
		Assign($all_items[$x] & "_amp_decay", GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_amp_decay_inp")) + 0, 4)
		Assign($all_items[$x] & "_amp_ammo", GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_amp_ammo_inp")) + 0, 4)
		Assign($all_items[$x] & "_upm", GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_upm_inp")) + 0, 4)
		Assign($all_items[$x] & "_dpu", GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_dpu_inp")) + 0, 4)
		Assign($all_items[$x] & "_key", GUICtrlRead(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_key_inp")), 4)
		Assign($all_items[$x] & "_key_code", _GUICtrlHKI_GetHotKey(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_key_inp")), 4)
	 else
	    if _GUICtrlHKI_GetHotKey(Eval("gui_stgs_medicals_" & $all_items[$x] & "_key_inp")) <> 0 Then
		 $test = StringStripWS(GUICtrlRead(Eval("gui_stgs_medicals_" & $all_items[$x] & "_name_inp")), $STR_STRIPALL)
		   if $test = "" then
			  MsgBox(0x0 + 0x10, $all_items[$x], "name is mandatory")
			  return False
		   EndIf
		   $test = GUICtrlRead(Eval("gui_stgs_medicals_" & $all_items[$x] & "_decay_inp")) + 0
		   if $test=0 Then
			   msgbox(0x0 + 0x10, $all_items[$x], "decay should not be 0")
			   return False
		   EndIf
		   $test = GUICtrlRead(Eval("gui_stgs_medicals_" & $all_items[$x] & "_upm_inp")) + 0
		   if $test=0 Then
			   msgbox(0x0 + 0x10, $all_items[$x], "upm should not be 0")
			   return False
		   EndIf
	    EndIf
		Assign($all_items[$x] & "_name", GUICtrlRead(Eval("gui_stgs_medicals_" & $all_items[$x] & "_name_inp")), 4)
		Assign($all_items[$x] & "_decay", GUICtrlRead(Eval("gui_stgs_medicals_" & $all_items[$x] & "_decay_inp")) + 0, 4)
		Assign($all_items[$x] & "_upm", GUICtrlRead(Eval("gui_stgs_medicals_" & $all_items[$x] & "_upm_inp")) + 0, 4)
		Assign($all_items[$x] & "_key", GUICtrlRead(Eval("gui_stgs_medicals_" & $all_items[$x] & "_key_inp")), 4)
		Assign($all_items[$x] & "_key_code", _GUICtrlHKI_GetHotKey(Eval("gui_stgs_medicals_" & $all_items[$x] & "_key_inp")), 4)
	endif
  next
  return True
EndFunc

Func gui_update_summary_dmgout()
	GUICtrlSetData($gui_main_sum_dmgout_hit_count_lbl, $gui_main_sum_dmgout_hit_count_txt & Eval("dmgout_hit_count"))
	GUICtrlSetData($gui_main_sum_dmgout_crit_count_lbl, $gui_main_sum_dmgout_crit_count_txt & Eval("dmgout_crit_count"))
	GUICtrlSetData($gui_main_sum_dmgout_use_count_lbl, $gui_main_sum_dmgout_use_count_txt & Eval("dmgout_use_count"))
	GUICtrlSetData($gui_main_sum_dmgout_dmg_sum_lbl, $gui_main_sum_dmgout_dmg_sum_txt & Round(Eval("dmgout_dmg_sum"), 2))
	GUICtrlSetData($gui_main_sum_dmgout_miss_count_lbl, $gui_main_sum_dmgout_miss_count_txt & Eval("dmgout_miss_count"))
	GUICtrlSetData($gui_main_sum_dmgout_hit_percent_lbl, $gui_main_sum_dmgout_hit_percent_txt & Round(Eval("dmgout_hit_percent"), 3) & "%")
	GUICtrlSetData($gui_main_sum_dmgout_crit_percent_lbl, $gui_main_sum_dmgout_crit_percent_txt & Round(Eval("dmgout_crit_percent"), 3) & "%")
	GUICtrlSetData($gui_main_sum_dmgout_macrit_percent_lbl, $gui_main_sum_dmgout_macrit_percent_txt & Round(Eval("dmgout_macrit_percent"), 3) & "%")
EndFunc

Func gui_update_summary_dmgin()
	GUICtrlSetData($gui_main_sum_dmgin_hit_count_lbl, $gui_main_sum_dmgin_hit_count_txt & $dmgin_hit_count)
	GUICtrlSetData($gui_main_sum_dmgin_crit_count_lbl, $gui_main_sum_dmgin_crit_count_txt & $dmgin_crit_count)
	GUICtrlSetData($gui_main_sum_dmgin_dmg_sum_lbl, $gui_main_sum_dmgin_dmg_sum_txt & Round($dmgin_dmg_sum, 2))
	GUICtrlSetData($gui_main_sum_dmgin_reddmg_sum_lbl, $gui_main_sum_dmgin_reddmg_sum_txt & Round($dmgin_reddmg_sum, 2))
	GUICtrlSetData($gui_main_sum_dmgin_carm_count_lbl, $gui_main_sum_dmgin_carm_count_txt & $dmgin_carm_count)
EndFunc

Func gui_update_summary_medicals()
	GUICtrlSetData($gui_main_sum_medicals_heal_sum_lbl, $gui_main_sum_medicals_heal_sum_txt & $medicals_heal_sum)
	GUICtrlSetData($gui_main_sum_medicals_use_count_lbl, $gui_main_sum_medicals_use_count_txt & $medicals_use_count)
EndFunc

Func gui_update_item_usage($x)
   Local $tab
   if (StringTrimRight($x, 1) = "w") then
		if ($x="w1" or $x="w2" or $x="w3") then
			$tab=1
		else
			$tab=2
		endif
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_hit_count_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_hit_count_txt") & Eval($x & "_hit_count"))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_crit_count_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_crit_count_txt") & Eval($x & "_crit_count"))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_use_count_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_use_count_txt") & Eval($x & "_use_count"))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_dmg_sum_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_dmg_sum_txt") & Round(Eval($x & "_dmg_sum"), 1))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_miss_count_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_miss_count_txt") & Eval($x & "_miss_count"))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_dpp_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_dpp_txt") & Round(Eval($x & "_dpp"), 3))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_dps_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_dps_txt") & Round(Eval($x & "_dps"), 1))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_hit_percent_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_hit_percent_txt") & Round(Eval($x & "_hit_percent"), 3) & "%")
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_crit_percent_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_crit_percent_txt") & Round(Eval($x & "_crit_percent"), 3) & "%")
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_macrit_percent_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_macrit_percent_txt") & Round(Eval($x & "_macrit_percent"), 3) & "%")
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_crit_inc_percent_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_crit_inc_percent_txt") & Round(Eval($x & "_crit_inc_percent"), 3) & "%")
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_dmg_chk_percent_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_dmg_chk_percent_txt") & Round(Eval($x & "_dmg_chk_percent"), 3) & "%")
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_cdmg_sum_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_cdmg_sum_txt") & Round(Eval($x & "_cdmg_sum"), 1))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_cdmg_min_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_cdmg_min_txt") & Round(Eval($x & "_cdmg_min"), 1))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_cdmg_max_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_cdmg_max_txt") & Round(Eval($x & "_cdmg_max"), 1))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_dmg_min_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_dmg_min_txt") & Round(Eval($x & "_dmg_min"), 1))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_dmg_max_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_dmg_max_txt") & Round(Eval($x & "_dmg_max"), 1))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_dmg_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_dmg_txt") & Eval($x & "_enh_dmg"))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_acc_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_acc_txt") & Eval($x & "_enh_acc"))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_eco_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_eco_txt") & Eval($x & "_enh_eco"))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_rng_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_rng_txt") & Eval($x & "_enh_rng"))
		GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_skl_lbl"), Eval("gui_main_wpn" & $tab & "_" & $x & "_enh_skl_txt") & Eval($x & "_enh_skl"))
	else
		GUICtrlSetData(Eval("gui_main_medicals_" & $x & "_use_count_lbl"), Eval("gui_main_medicals_" & $x & "_use_count_txt") & Eval($x & "_use_count"))
		GUICtrlSetData(Eval("gui_main_medicals_" & $x & "_heal_sum_lbl"), Eval("gui_main_medicals_" & $x & "_heal_sum_txt") & Round(Eval($x & "_heal_sum"), 1))
		GUICtrlSetData(Eval("gui_main_medicals_" & $x & "_hpp_lbl"), Eval("gui_main_medicals_" & $x & "_hpp_txt") & Round(Eval($x & "_hpp"), 3))
		GUICtrlSetData(Eval("gui_main_medicals_" & $x & "_hps_lbl"), Eval("gui_main_medicals_" & $x & "_hps_txt") & Round(Eval($x & "_hps"), 1))
		GUICtrlSetData(Eval("gui_main_medicals_" & $x & "_enh_eco_lbl"), Eval("gui_main_medicals_" & $x & "_enh_eco_txt") & Eval($x & "_enh_eco"))
		GUICtrlSetData(Eval("gui_main_medicals_" & $x & "_enh_hea_lbl"), Eval("gui_main_medicals_" & $x & "_enh_hea_txt") & Eval($x & "_enh_hea"))
		GUICtrlSetData(Eval("gui_main_medicals_" & $x & "_enh_skl_lbl"), Eval("gui_main_medicals_" & $x & "_enh_eco_txt") & Eval($x & "_enh_skl"))
	endif
EndFunc

Func gui_update_logboxes()
	GUICtrlSetData($gui_main_logbox, $hunting_log_line & @CRLF, 1)
EndFunc

Func gui_update_item_status()
   Local $x, $label, $clr
   for $x = 0 to ubound($all_items)-1
		if ($equipped_item=$all_items[$x]) Then
			$clr = 0x80FF00
			$label = "Enabled"
		Else
			$clr = 0xC0C0C0
			$label = "Disabled"
		endIf
		GUICtrlSetData(Eval("gui_main_sum_item_status_" & $all_items[$x] & "_lbl"), $label)
		GUICtrlSetBkColor(Eval("gui_main_sum_item_status_" & $all_items[$x] & "_lbl"), $clr)
   Next
EndFunc

Func gui_update_item_names()
   Local $x, $tab
   for $x = 0 to ubound($all_items)-1
		If StringLen(Eval($all_items[$x] & "_name")) > 1 Then
			GUICtrlSetData(Eval("gui_main_sum_item_status_" & $all_items[$x] & "_grp"), "[ " & StringMid(Eval($all_items[$x] & "_name"), 1, 12) & "... ]")
			if (StringTrimRight($all_items[$x], 1) = "w") then
				if ($x < 4) then
					$tab = 1
				else
					$tab = 2
				EndIf
				GUICtrlSetData(Eval("gui_main_wpn" & $tab & "_" & $all_items[$x] & "_grp"), "[ " & Eval($all_items[$x] & "_name") & " ]")
			else
				GUICtrlSetData(Eval("gui_main_medicals_" & $all_items[$x] & "_grp"), "[ " & Eval($all_items[$x] & "_name") & " ]")
			EndIf
		endif
	Next
EndFunc

Func gui_update_settings_items()
   Local $x, $tab
   for $x = 0 to ubound($all_items)-1
   		if (StringTrimRight($all_items[$x], 1) = "w") then
			if $x < 4 then
				$tab = 1
			else
				$tab = 2
			endif
			GUICtrlSetData(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_name_inp"), Eval($all_items[$x] & "_name"))
			GUICtrlSetData(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_decay_inp"), Eval($all_items[$x] & "_decay"))
			GUICtrlSetData(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_ammo_inp"), Eval($all_items[$x] & "_ammo"))
			GUICtrlSetData(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_amp_decay_inp"), Eval($all_items[$x] & "_amp_decay"))
			GUICtrlSetData(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_amp_ammo_inp"), Eval($all_items[$x] & "_amp_ammo"))
			GUICtrlSetData(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_upm_inp"), Eval($all_items[$x] & "_upm"))
			GUICtrlSetData(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_dpu_inp"), Eval($all_items[$x] & "_dpu"))
			_GUICtrlHKI_SetHotKey(Eval("gui_stgs_wpn" & $tab & "_" & $all_items[$x] & "_key_inp"), Eval($all_items[$x] & "_key_code"))
		else
			GUICtrlSetData(Eval("gui_stgs_medicals_" & $all_items[$x] & "_name_inp"), Eval($all_items[$x] & "_name"))
			GUICtrlSetData(Eval("gui_stgs_medicals_" & $all_items[$x] & "_decay_inp"), Eval($all_items[$x] & "_decay"))
			GUICtrlSetData(Eval("gui_stgs_medicals_" & $all_items[$x] & "_upm_inp"), Eval($all_items[$x] & "_upm"))
			_GUICtrlHKI_SetHotKey(Eval("gui_stgs_medicals_" & $all_items[$x] & "_key_inp"), Eval($all_items[$x] & "_key_code"))
		endif
   Next
EndFunc

Func gui_update_settings_general()
    Local $cnt
	GUICtrlSetData($gui_stgs_gen_main_chatlog_location_inp, $chat_log_location)
    for $cnt = 0 to UBound($enhcs)-1
	   GUICtrlSetData(Eval("gui_stgs_gen_enh_" & $enhcs[$cnt] & "_cost_inp"), Eval($enhcs[$cnt] & "_cost"))
    Next
EndFunc

Func GUI()
   local $gui_w=800, $gui_h=700, $tab_w=750, $tab_h=400
   local $gui_lbl_height=17, $gui_inp_height=21, $x, $y, $group_x, $group_y, $w, $cnt, $tab
	Assign("gui_main_wnd",GUICreate($window_title, $gui_w, $gui_h), 2)
	GUISetOnEvent($GUI_Event_Close, "window_events")

	$group_x = 5
	$group_y = 5
	Assign("gui_main_sum_item_status_grp_txt", "Item Status", 2)
	Assign("gui_main_sum_item_status_grp", GUICtrlCreateGroup("[ " & $gui_main_sum_item_status_grp_txt & " ]", $group_x, $group_y , $tab_w, 60), 2)
	$y = $group_y + 15
	$w = 80
	$x = $group_x + 5
	for $cnt = 1 to 6+3
	  if $cnt < 7 Then
		 Assign("gui_main_sum_item_status_w" & $cnt & "_grp", GUICtrlCreateGroup("[ Weapon "  & $cnt & " ]", $x, $y, $w, 40), 2)
		 Assign("gui_main_sum_item_status_w" & $cnt & "_lbl", GUICtrlCreateLabel("", $x + 25, $y + 15, 43, $gui_lbl_height, 0), 2)
	  Else
		 Assign("gui_main_sum_item_status_m" & ($cnt-6) & "_grp", GUICtrlCreateGroup("[ Medical "  & ($cnt-6) & " ]", $x, $y, $w, 40), 2)
		 Assign("gui_main_sum_item_status_m" & ($cnt-6) & "_lbl", GUICtrlCreateLabel("", $x + 25, $y + 15, 43, $gui_lbl_height, 0), 2)
	  EndIf
	  $x = $x + $w + 2
	  GUICtrlCreateGroup("", -99, -99, 1, 1)
   Next

    $group_x = $group_x + 15
	$group_y = $group_y + 65
	Assign("gui_main_tabs", GUICtrlCreateTab($group_x-20, $group_y, $tab_w, $tab_h), 2)
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	for $cnt = 1 to 6
	  if $cnt < 4 Then
		 $tab = 1
	  Else
		 $tab = 2
	  EndIf
	  if ($cnt=1) or ($cnt=4) Then
		 Assign("$gui_main_wpn" & $tab & "_tab", GUICtrlCreateTabItem("Weapons " & $tab), 2)
	  EndIf
	  $group_x = 20
	  if $cnt < 4 Then
		 $group_y = 100 + (120 * ($cnt - 1))
	  Else
		 $group_y = 100 + (120 * ($cnt - 3 - 1))
	  EndIf
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_grp", GUICtrlCreateGroup("[ Weapon " & $cnt & " ]", $group_x, $group_y, $tab_w-50, 120), 2)
	  $x = $group_x + 5
	  $y = $group_y + $gui_lbl_height + 5
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_reset_btn",  GUICtrlCreateButton("Reset", $tab_w-50-$w+15, $y-12, $w, 25), 2)
	  GUICtrlSetOnEvent(-1, "window_events")
	  GUICtrlSetTip(-1, "Reset")
      $w = 80
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_use_count_txt", "Uses: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_use_count_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_use_count_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_hit_count_txt", "Hits: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_hit_count_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_hit_count_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_crit_count_txt", "Crits: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_crit_count_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_crit_count_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 90
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_miss_count_txt", "Misses: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_miss_count_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_miss_count_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 110
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_sum_txt", "Dmg: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_sum_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_sum_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 110
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_cdmg_sum_txt", "CritDmg: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_cdmg_sum_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_cdmg_sum_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $group_x + 5
	  $y = $y + $gui_lbl_height + 5
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_cdmg_min_txt", "MinCrit: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_cdmg_min_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_cdmg_min_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_cdmg_max_txt", "MaxCrit: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_cdmg_max_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_cdmg_max_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_min_txt", "MinDmg: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_min_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_min_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_max_txt", "MaxDmg: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_max_lbl", GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_max_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
      $x = $group_x + 5
	  $y = $y + $gui_lbl_height + 5
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_hit_percent_txt", "Hit%: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_hit_percent_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_hit_percent_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_crit_percent_txt", "Crit%: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_crit_percent_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_crit_percent_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 80
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_macrit_percent_txt", "MACrit%: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_macrit_percent_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_macrit_percent_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 95
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_crit_inc_percent_txt", "CritInc%: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_crit_inc_percent_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_crit_inc_percent_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dpp_txt", "DPP: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dpp_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_dpp_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dps_txt", "DPS: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dps_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_dps_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  $x = $x + $w + 10
	  $w = 100
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_chk_percent_txt", "DmgChk%: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_chk_percent_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_dmg_chk_percent_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  $x = $group_x + 5
	  $y = $y + $gui_lbl_height + 5
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_dmg_txt", "EnhDmg: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_dmg_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_dmg_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_acc_txt", "EnhAcc: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_acc_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_acc_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_eco_txt", "EnhEco: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_eco_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_eco_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_rng_txt", "EnhRng: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_rng_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_rng_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_skl_txt", "EnhSkl: ", 2)
	  Assign("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_skl_lbl",  GUICtrlCreateLabel(Eval("gui_main_wpn" & $tab & "_w" & $cnt & "_enh_skl_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)
   next

    Assign("$gui_main_medicals_tab", GUICtrlCreateTabItem("Medicals"), 2)
	for $cnt = 1 to 3
	  $group_x = 20
	  $group_y = 100 + (105 * ($cnt - 1))
	  Assign("gui_main_medicals_m" & $cnt & "_grp", GUICtrlCreateGroup("[ Medical " & $cnt & " ]", $group_x, $group_y, $tab_w-50, 105), 2)
	  $x = $group_x + 5
	  $y = $group_y + $gui_lbl_height + 5
	  $w = 75
	  Assign("gui_main_medicals_m" & $cnt & "_reset_btn",  GUICtrlCreateButton("Reset", $tab_w-50-$w+15, $y-12, $w, 25), 2)
	  GUICtrlSetOnEvent(-1, "window_events")
	  GUICtrlSetTip(-1, "Reset")
      $w = 80
	  Assign("gui_main_medicals_m" & $cnt & "_use_count_txt", "Uses: ", 2)
	  Assign("gui_main_medicals_m" & $cnt & "_use_count_lbl", GUICtrlCreateLabel(Eval("gui_main_medicals_m" & $cnt & "_use_count_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 120
	  Assign("gui_main_medicals_m" & $cnt & "_heal_sum_txt", "Heal Sum: ", 2)
	  Assign("gui_main_medicals_m" & $cnt & "_heal_sum_lbl", GUICtrlCreateLabel(Eval("gui_main_medicals_m" & $cnt & "_heal_sum_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_medicals_m" & $cnt & "_hpp_txt", "HPP: ", 2)
	  Assign("gui_main_medicals_m" & $cnt & "_hpp_lbl", GUICtrlCreateLabel(Eval("gui_main_medicals_m" & $cnt & "_hpp_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_medicals_m" & $cnt & "_hps_txt", "HPS: ", 2)
	  Assign("gui_main_medicals_m" & $cnt & "_hps_lbl", GUICtrlCreateLabel(Eval("gui_main_medicals_m" & $cnt & "_hps_txt"), $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $group_x + 5
	  $y = $y + $gui_lbl_height + 5
	  $w = 75
	  Assign("gui_main_medicals_m" & $cnt & "_enh_hea_txt", "EnhHea: ", 2)
	  Assign("gui_main_medicals_m" & $cnt & "_enh_hea_lbl",  GUICtrlCreateLabel(Eval("gui_main_medicals_m" & $cnt & "_enh_hea_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_medicals_m" & $cnt & "_enh_eco_txt", "EnhEco: ", 2)
	  Assign("gui_main_medicals_m" & $cnt & "_enh_eco_lbl",  GUICtrlCreateLabel(Eval("gui_main_medicals_m" & $cnt & "_enh_eco_txt"), $x, $y, $w, $gui_lbl_height), 2)
	  $x = $x + $w + 10
	  $w = 75
	  Assign("gui_main_medicals_m" & $cnt & "_enh_skl_txt", "EnhSkl: ", 2)
	  Assign("gui_main_medicals_m" & $cnt & "_enh_skl_lbl",  GUICtrlCreateLabel(Eval("gui_main_medicals_m" & $cnt & "_enh_skl_txt"), $x, $y, $w, $gui_lbl_height), 2)
   Next

    Assign("gui_main_sum_tab", GUICtrlCreateTabItem("Statistical Summary"), 2)
 	$group_y = 100
	Assign("gui_main_sum_dmgout_grp", GUICtrlCreateGroup("[ Damage Out ]", $group_x, $group_y, $tab_w-50, 80), 2)
    $x = $group_x + 5
    $y = $group_y + $gui_lbl_height + 5
	$w = 75
    Assign("gui_main_sum_dmgout_reset_btn",  GUICtrlCreateButton("Reset", $tab_w-50-$w+15, $y-12, $w, 25), 2)
	GUICtrlSetOnEvent(-1, "window_events")
	GUICtrlSetTip(-1, "Reset")
	$w = 85
	Assign("gui_main_sum_dmgout_use_count_txt", "Uses: ", 2)
	Assign("gui_main_sum_dmgout_use_count_lbl", GUICtrlCreateLabel($gui_main_sum_dmgout_use_count_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 85
	Assign("gui_main_sum_dmgout_hit_count_txt", "Hits: ", 2)
	Assign("gui_main_sum_dmgout_hit_count_lbl", GUICtrlCreateLabel($gui_main_sum_dmgout_hit_count_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 85
	Assign("gui_main_sum_dmgout_crit_count_txt", "Crits: ", 2)
	Assign("gui_main_sum_dmgout_crit_count_lbl", GUICtrlCreateLabel($gui_main_sum_dmgout_crit_count_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 85
	Assign("gui_main_sum_dmgout_miss_count_txt", "Misses: ", 2)
	Assign("gui_main_sum_dmgout_miss_count_lbl", GUICtrlCreateLabel($gui_main_sum_dmgout_miss_count_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 120
	Assign("gui_main_sum_dmgout_dmg_sum_txt", "Damage: ", 2)
	Assign("gui_main_sum_dmgout_dmg_sum_lbl", GUICtrlCreateLabel($gui_main_sum_dmgout_dmg_sum_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
    $y = $y + $gui_lbl_height + 5
    $x = $group_x + 5
	$w = 85
	Assign("gui_main_sum_dmgout_hit_percent_txt", "Hit%: ", 2)
	Assign("gui_main_sum_dmgout_hit_percent_lbl", GUICtrlCreateLabel($gui_main_sum_dmgout_hit_percent_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 85
	Assign("gui_main_sum_dmgout_crit_percent_txt", "Crit%: ", 2)
	Assign("gui_main_sum_dmgout_crit_percent_lbl", GUICtrlCreateLabel($gui_main_sum_dmgout_crit_percent_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 85
	Assign("gui_main_sum_dmgout_macrit_percent_txt", "MACrit%: ", 2)
	Assign("gui_main_sum_dmgout_macrit_percent_lbl", GUICtrlCreateLabel($gui_main_sum_dmgout_macrit_percent_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
    GUICtrlCreateGroup("", -99, -99, 1, 1)

    $group_x = 20
 	$group_y = $group_y + 80
	Assign("gui_main_sum_dmgin_grp", GUICtrlCreateGroup("[ Damage In ]", $group_x, $group_y, $tab_w-50, 60), 2)
    $x = $group_x + 5
    $y = $group_y + $gui_lbl_height + 5
	$w = 75
    Assign("gui_main_sum_dmgin_reset_btn",  GUICtrlCreateButton("Reset", $tab_w-50-$w+15, $y-12, $w, 25), 2)
	GUICtrlSetOnEvent(-1, "window_events")
	GUICtrlSetTip(-1, "Reset")
	$w = 85
	Assign("gui_main_sum_dmgin_hit_count_txt", "Hits: ", 2)
	Assign("gui_main_sum_dmgin_hit_count_lbl", GUICtrlCreateLabel($gui_main_sum_dmgin_hit_count_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 85
	Assign("gui_main_sum_dmgin_crit_count_txt", "Crits: ", 2)
	Assign("gui_main_sum_dmgin_crit_count_lbl", GUICtrlCreateLabel($gui_main_sum_dmgin_crit_count_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 85
	Assign("gui_main_sum_dmgin_carm_count_txt", "Crits armor: ", 2)
	Assign("gui_main_sum_dmgin_carm_count_lbl", GUICtrlCreateLabel($gui_main_sum_dmgin_carm_count_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
    $x = $x + $w + 10
	$w = 120
	Assign("gui_main_sum_dmgin_dmg_sum_txt", "Damage: ", 2)
	Assign("gui_main_sum_dmgin_dmg_sum_lbl", GUICtrlCreateLabel($gui_main_sum_dmgin_dmg_sum_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 180
	Assign("gui_main_sum_dmgin_reddmg_sum_txt", "Reduced damage: ", 2)
	Assign("gui_main_sum_dmgin_reddmg_sum_lbl", GUICtrlCreateLabel($gui_main_sum_dmgin_reddmg_sum_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

    $group_x = 20
 	$group_y = $group_y + 60
	Assign("gui_main_sum_medicals_grp", GUICtrlCreateGroup("[ Medicals ]", $group_x, $group_y, $tab_w-50, 60), 2)
    $x = $group_x + 5
    $y = $group_y + $gui_lbl_height + 5
	$w = 75
    Assign("gui_main_sum_medical_reset_btn",  GUICtrlCreateButton("Reset", $tab_w-50-$w+15, $y-12, $w, 25), 2)
	GUICtrlSetOnEvent(-1, "window_events")
	GUICtrlSetTip(-1, "Reset")
	$w = 100
	Assign("gui_main_sum_medicals_use_count_txt", "Uses: ", 2)
	Assign("gui_main_sum_medicals_use_count_lbl", GUICtrlCreateLabel($gui_main_sum_medicals_use_count_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 10
	$w = 100
	Assign("gui_main_sum_medicals_heal_sum_txt", "Heal Sum: ", 2)
	Assign("gui_main_sum_medicals_heal_sum_lbl", GUICtrlCreateLabel($gui_main_sum_medicals_heal_sum_txt, $x, $y, $w, $gui_lbl_height, 0), 2)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")
	GUISwitch($gui_main_wnd)
	Assign("gui_main_logbox", GUICtrlCreateEdit("", $group_x, $tab_h + 60 + 20, $gui_w - 80, 150, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL)), 2)
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlSetBkColor($gui_main_logbox, 0xFFFFFF)
	GUICtrlSetLimit($gui_main_logbox, 0xF423F); 999,999
	Assign("gui_main_file_mnu", GUICtrlCreateMenu("&File"), 2)
	Assign("gui_main_file_exit_itm", GUICtrlCreateMenuItem("Exit", $gui_main_file_mnu), 2)
	GUICtrlSetOnEvent(-1, "window_events")
	Assign("gui_main_edit_mnu", GUICtrlCreateMenu("&Edit"), 2)
	Assign("gui_main_edit_settings_itm", GUICtrlCreateMenuItem("Settings", $gui_main_edit_mnu), 2)
	GUICtrlSetOnEvent(-1, "window_events")
	Assign("gui_main_help_mnu", GUICtrlCreateMenu("&Help"), 2)
	Assign("gui_main_help_about_itm", GUICtrlCreateMenuItem("About", $gui_main_help_mnu), 2)
	GUICtrlSetOnEvent(-1, "window_events")
	Assign("gui_main_statusbar", _GUICtrlStatusBar_Create($gui_main_wnd), 2)
	_GUICtrlStatusBar_SetText($gui_main_statusbar, $equipped_item)
    _RegEx_RestrictControl_setup (50)
	Assign("gui_stgs_wnd", GUICreate("Settings", $gui_w, $gui_h, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS), $ws_ex_mdichild, $gui_main_wnd), 2)
    $tab_h = 600
	Assign("gui_stgs_tabs", GUICtrlCreateTab(-1, -1, $tab_w, $tab_h), 2)
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	Assign("gui_stgs_gen_tab", GUICtrlCreateTabItem("General Settings"), 2)
    $group_x = 20
 	$group_y = 20
    Assign("gui_stgs_gen_main_grp", GUICtrlCreateGroup("[Main Settings]", $group_x, $group_y, $tab_w-50, 60), 2)
	$x = $group_x + 10
	$y = $group_y + 20
	$w = 100
	Assign("gui_stgs_gen_main_chatlog_location_lbl", GUICtrlCreateLabel("chat.log file location:", $x, $y, $w, $gui_lbl_height, 0), 2)
	$x = $x + $w + 5
	$w = 500
	Assign("gui_stgs_gen_main_chatlog_location_inp", GUICtrlCreateInput("", $x, $y, $w, $gui_inp_height, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY)), 2)
	$x = $x + $w + 5
	$w = 75
	Assign("gui_stgs_gen_main_chatlog_location_btn", GUICtrlCreateButton("Change", $x, $y-2, $w, $gui_inp_height + 5), 2)
	GUICtrlSetOnEvent(-1, "window_events")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
    $group_x = 20
 	$group_y = $group_y + 60 + 5
	$x = $group_x + 20
	$y = $group_y
    Assign("gui_stgs_gen_enh_grp", GUICtrlCreateGroup("[Enhancer cost (for 1 enhancer in PECs including MU)]", $group_x, $group_y, $tab_w-50, 250), 2)
	for $cnt = 0 to UBound($enhcs)-1
	  $x = $group_x + 20
	  $y = $y + $gui_lbl_height + 10
	  $w = 250
	  if (StringTrimRight($enhcs[$cnt], StringLen($enhcs[$cnt])-1)="w") Then
		 local $gui_it_type_txt = "Weapon"
	  Else
		 local $gui_it_type_txt = "Medical"
	  endIf
	  local $enh_type = StringTrimLeft($enhcs[$cnt], StringLen($enhcs[$cnt])-3)
	  Select
	  Case $enh_type = "dmg"
		 local $gui_enh_type_txt = "Damage"
	  Case $enh_type = "acc"
		 local $gui_enh_type_txt = "Accuracy"
	  Case $enh_type = "eco"
		 local $gui_enh_type_txt = "Economy"
	  Case $enh_type = "rng"
		 local $gui_enh_type_txt = "Range"
	  Case $enh_type = "skl"
		 local $gui_enh_type_txt = "Skill"
	  Case $enh_type = "hea"
		 local $gui_enh_type_txt = "Heal"
	  EndSelect
	  Assign("gui_stgs_gen_enh_" & $enhcs[$cnt] & "_cost_lbl", GUICtrlCreateLabel($gui_it_type_txt & " " & $gui_enh_type_txt & " Enhancer", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 50
	  Assign("gui_stgs_gen_enh_" & $enhcs[$cnt] & "_cost_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height), 2)
	  _RegEx_RestrictControl_add (Eval("gui_stgs_gen_enh_" & $enhcs[$cnt] & "_cost_inp"), "^[0-9]{0,4}[\.]{0,1}[0-9]{0,3}$")
    Next
    GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	for $cnt = 1 to 6
	  if $cnt < 4 Then
		 $tab = 1
	  Else
		 $tab = 2
	  EndIf
	  if ($cnt=1) or ($cnt=4) Then
		 Assign("$gui_stgs_wpn" & $tab & "_tab", GUICtrlCreateTabItem("Weapons " & $tab), 2)
	  EndIf
	  $group_x = 20
	  if $cnt < 4 Then
		 $group_y = 30 + (160 * ($cnt - 1))
	  Else
		 $group_y = 30 + (160 * ($cnt - 3 - 1))
	  EndIf
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_grp", GUICtrlCreateGroup("[Weapon " & $cnt & " ]", $group_x, $group_y, $tab_w-50, 160), 2)
	  $x = $group_x + 20
	  $y = $group_y + $gui_lbl_height + 10
	  $w = 80
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_name_lbl", GUICtrlCreateLabel("Weapon Name:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 120
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_name_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  $x = $x + $w + 10
	  $w = 70
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_decay_lbl", GUICtrlCreateLabel("Decay in PEC:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 50
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_decay_inp", GUICtrlCreateInput("", $x, $y-2, 50, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  _RegEx_RestrictControl_add (Eval("gui_stgs_wpn" & $tab & "_w" & $cnt & "_decay_inp"), "^[0-9]{0,2}[\.]{0,1}[0-9]{0,3}$")
	  $x = $x + $w + 10
	  $w = 70
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_ammo_lbl", GUICtrlCreateLabel("Ammo in PEC:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 50
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_ammo_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  _RegEx_RestrictControl_add (Eval("gui_stgs_wpn" & $tab & "_w" & $cnt & "_ammo_inp"), "^[0-9]{0,2}[\.]{0,1}[0-9]{0,3}$")
	  $x = $group_x + 20
	  $y = $y + $gui_lbl_height + 10
	  $w = 100
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_amp_decay_lbl", GUICtrlCreateLabel("Amp Decay in PEC:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 50
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_amp_decay_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  _RegEx_RestrictControl_add (Eval("gui_stgs_wpn" & $tab & "_w" & $cnt & "_amp_decay_inp"), "^[0-9]{0,2}[\.]{0,1}[0-9]{0,3}$")
	  $x = $x + $w + 10
	  $w = 100
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_amp_ammo_lbl", GUICtrlCreateLabel("Amp Ammo in PEC:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 50
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_amp_ammo_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  _RegEx_RestrictControl_add (Eval("gui_stgs_wpn" & $tab & "_w" & $cnt & "_amp_ammo_inp"), "^[0-9]{0,2}[\.]{0,1}[0-9]{0,3}$")
	  $x = $group_x + 20
	  $y = $y + $gui_lbl_height + 10
	  $w = 100
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_upm_lbl", GUICtrlCreateLabel("Uses per minute:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 50
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_upm_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  _RegEx_RestrictControl_add (Eval("gui_stgs_wpn" & $tab & "_w" & $cnt & "_upm_inp"), "^[0-9]{0,3}[\.]{0,1}[0-9]{0,2}$")
	  $x = $x + $w + 10
	  $w = 100
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_dpu_lbl", GUICtrlCreateLabel("Damage with amp:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 50
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_dpu_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  _RegEx_RestrictControl_add (Eval("gui_stgs_wpn" & $tab & "_w" & $cnt & "_dpu_inp"), "^[0-9]{0,3}[\.]{0,1}[0-9]{0,1}$")
	  $x = $group_x + 20
	  $y = $y + $gui_lbl_height + 10
	  $w = 100
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_key_lbl", GUICtrlCreateLabel("Weapon Hotkey:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 230
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_key_inp", _GUICtrlHKI_Create(0, $x, $y-2, $w, $gui_inp_height), 2)
	  $x = $x + $w + 10
	  $w = 230
	  Assign("gui_stgs_wpn" & $tab & "_w" & $cnt & "_key_about_lbl", GUICtrlCreateLabel("(press the hotkey or combination into the input)", $x, $y, $w, $gui_lbl_height, 0), 2)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)
    Next

	Assign("gui_stgs_medicals_tab", GUICtrlCreateTabItem("Medicals"), 2)
	for $cnt = 1 to 3
	  $group_x = 20
 	  $group_y = 30 + (160 * ($cnt - 1))
	  Assign("gui_stgs_medicals_m" & $cnt & "_grp", GUICtrlCreateGroup("[Medical " & $cnt & " ]", $group_x, $group_y, $tab_w-50, 160), 2)
	  $x = $group_x + 20
	  $y = $group_y + $gui_lbl_height + 10
	  $w = 100
	  Assign("gui_stgs_medicals_m" & $cnt & "_name_lbl", GUICtrlCreateLabel("Name:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 120
	  Assign("gui_stgs_medicals_m" & $cnt & "_name_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  $x = $x + $w + 10
	  $w = 80
	  Assign("gui_stgs_medicals_m" & $cnt & "_decay_lbl", GUICtrlCreateLabel("Decay in PEC:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 50
	  Assign("gui_stgs_medicals_m" & $cnt & "_decay_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  _RegEx_RestrictControl_add (Eval("gui_stgs_medicals_m" & $cnt & "_decay_inp"), "^[0-9]{0,2}[\.]{0,1}[0-9]{0,3}$")
	  $x = $group_x + 20
	  $y = $y + $gui_lbl_height + 10
	  $w = 100
	  Assign("gui_stgs_medicals_m" & $cnt & "_upm_lbl", GUICtrlCreateLabel("Uses per minute:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 50
	  Assign("gui_stgs_medicals_m" & $cnt & "_upm_inp", GUICtrlCreateInput("", $x, $y-2, $w, $gui_inp_height, $GUI_SS_DEFAULT_INPUT), 2)
	  _RegEx_RestrictControl_add (Eval("gui_stgs_medicals_m" & $cnt & "_upm_inp"), "^[0-9]{0,3}[\.]{0,1}[0-9]{0,2}$")
	  $x = $group_x + 20
	  $y = $y + $gui_lbl_height + 10
	  $w = 100
	  Assign("gui_stgs_medicals_m" & $cnt & "_key_lbl", GUICtrlCreateLabel("Medical Hotkey:", $x, $y, $w, $gui_lbl_height, 0), 2)
	  $x = $x + $w + 10
	  $w = 230
	  Assign("gui_stgs_medicals_m" & $cnt & "_key_inp", _GUICtrlHKI_Create(0, $x, $y-2, $w, $gui_inp_height), 2)
	  $x = $x + $w + 10
	  $w = 230
	  Assign("gui_stgs_medicals_m" & $cnt & "_key_about_lbl", GUICtrlCreateLabel("(press the hotkey or combination into the input)", $x, $y, $w, $gui_lbl_height, 0), 2)
      GUICtrlCreateGroup("", -99, -99, 1, 1)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)
    Next

    GUICtrlCreateTabItem("")
	Assign("gui_stgs_exit_btn", GUICtrlCreateButton("Save settings", $tab_w-175-20, $tab_h-50, 75, 25, 0), 2)
	GUICtrlSetOnEvent(-1, "window_events")
	Assign("gui_stgs_cancel_btn", GUICtrlCreateButton("Cancel", $tab_w-75-20, $tab_h-50, 75, 25, 0), 2)
	GUICtrlSetOnEvent(-1, "window_events")

	Assign("gui_about_wnd", GUICreate("About", 400, 240, -1, -1, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS), -1, $gui_main_wnd), 2)
	$w = 300
	Assign("gui_about_lbl", GUICtrlCreateLabel("Entro Stats", 90, 20, $w, 30), 2)
	GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x0000FF)
	$x = 20
	$y = 70
	Assign("gui_about_desc1_lbl", GUICtrlCreateLabel("This program is for Entropia stat addicts", $x, $y, $w, $gui_lbl_height), 2)
	$y = $y + 20
	Assign("gui_about_desc2_lbl", GUICtrlCreateLabel("Measure dpp, dps, hpp, hps, enhancer count, etc. :)", $x, $y, $w, $gui_lbl_height), 2)
	Assign("gui_about_ok_btn", GUICtrlCreateButton("Ok", 152, 200, 75, 25, 0), 2)
	GUICtrlSetOnEvent(-1, "window_events")
	GUISetState(@SW_SHOW, $gui_main_wnd)
	GUISetState(@SW_HIDE, $gui_stgs_wnd)
	GUISetState(@SW_HIDE, $gui_about_wnd)
EndFunc   ;==>GUI

Func gui_confirm_reset()
   Local $confirm
   $confirm=MsgBox(0x4 + 0x30 + 0x100, "Confirm reset", "Are you sure you want to reset?")
   if $confirm = 6 then
	  return True
   Else
	  return False
   EndIf
EndFunc

Func gui_change_file_location($initdir, $loglocation, $filename, $filter)
	Local $new_location
	$new_location = FileOpenDialog("Locate your " & $filename & " file", $initdir, $filter, 0, "", $gui_stgs_wnd)
	If $new_location = "" Then
		return False
	 Else
		Assign($loglocation, $new_location, 4)
	EndIf
	gui_update_settings_general()
	ini_write_settings_general()
EndFunc

Func _FileCountLines2($sFilePath, $CRonly = 0)
   Local $hFile = FileOpen($sFilePath)
   If $hFile = -1 Then
	  msgbox (0, "Error", "File '" & $sFilePath & "' could not be found")
	  return SetError(1, 0, 0)
   endif
   Local $iLineCount = 0, $sBuffer, $iReadBytes, $bDone
   Local Const $BUFFER_SIZE = 8 * 1024 * 1024
   Local $sTermination = @LF
   If $CRonly Then $sTermination = @CR
   Do
	  $sBuffer = FileRead($hFile, $BUFFER_SIZE)
	  $bDone = (@extended <> $BUFFER_SIZE)
	  StringRegExpReplace($sBuffer, $sTermination, "")
	  $iLineCount += @extended
   Until $bDone
   If FileGetPos($hFile) > 0 Then
	  FileSetPos($hFile, -1, 1)
	  If FileRead($hFile, 1) <> $sTermination Then $iLineCount += 1
   EndIf
   FileClose($hFile)
   Return $iLineCount
EndFunc
