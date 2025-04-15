
#Requires Autohotkey v2

myGui := Gui()
myGui.Show("w350 h420")

Tab := myGui.Add("Tab3", "x24 y8 w301 h340 ", ["Tab 1", "Tab 2", "Tab 3"])

Tab.UseTab(1)
myGui.Add("Text", "x48 y56 w84 h23 +0x200", "Hotel Code:")
EditHcode_pub := myGui.Add("Edit", "x144 y56 w150 h21", "")

myGui.Add("Text", "x48 y86 w84 h23 +0x200", "Hotel Name:")
EditHName_pub := myGui.Add("Edit", "x144 y86 w150 h21", "")

myGui.Add("Text", "x48 y116 w84 h23 +0x200", "Cloud:")
DropCloud_pub := myGui.Add("DropDownList", "x144 y116 w150 Choose1", ["Cloud_1", "Cloud_2", "Cloud_3", "Cloud_4", "Cloud_5", "Cloud_1_6"])

myGui.Add("Text", "x48 y146 w84 h23 +0x200", "Server:")
DropServ_pub := myGui.Add("DropDownList", "x144 y146 w150 Choose1", ["Server_1", "Server_2"])

myGui.Add("Text", "x48 y200 w120 h23 +0x200", "How to use:")
myGui.Add("Edit", "x48 y230 w232 h100 ReadOnly", "
(
ALT + Q = Hotel Code
ALT + W = Hotel Name
ALT + E = Hotel Contact
ALT + A = Path
ALT + S = Expression
ALT + D = Date SQL
)")

Tab.UseTab(2)
myGui.Add("Text", "x48 y56 w84 h23 +0x200", "Folder Number:")
EditFolder_hosted := myGui.Add("Edit", "x144 y56 w150 h21", "")

myGui.Add("Text", "x48 y86 w84 h23 +0x200", "Script:")
DropScript_hosted := myGui.Add("DropDownList", "x144 y86 w150 Choose1", ["script_1","script_2",
				"script_3","script_4", "script_5",
				"script_6"])

myGui.Add("Text", "x48 y116 w84 h23 +0x200", "Server:")
DropServ_hosted := myGui.Add("DropDownList", "x144 y116 w150 Choose1", ["Server_1", "Server_2"])

myGui.Add("Text", "x48 y220 w120 h23 +0x200", "How to use:")
myGui.Add("Edit", "x48 y250 w232 h100 ReadOnly", "
(
ALT + A = Path
ALT + S = Expression
ALT + D = Date SQL
)")

Tab.UseTab(3)

myGui.Add("Text", "x48 y56 w84 h23 +0x200", "Date Type D360")
DropDate_D360 := myGui.Add("DropDownList", "x144 y56 w150 Choose1", ["DD-MM-YY", "MM-DD-YY"])

myGui.Add("Text", "x48 y220 w120 h23 +0x200", "How to use:")
myGui.Add("Edit", "x48 y250 w232 h100 ReadOnly", "
(
ALT + S = Expression
ALT + D = Date SQL
)")

Tab.UseTab()
CheckBox_ClipboardUse := myGui.Add("CheckBox", "x28 y360 w370 h17 Checked", "Use clipboard")



SB := MyGui.AddStatusBar()
SB.SetText("          Made by Horizon :) ❤️")

Tab.OnEvent("Change", onTabChange)

myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Config Helper"

global selectedTab := Tab.value

onTabChange(*){
	global selectedTab := Tab.value
}


;Tab 1 Funcs
#HotIf selectedTab=1
!q:: Pub_Code(ControlGetText(EditHCode_pub))
!w:: Pub_Name(ControlGetText(EditHName_pub))
!e:: Pub_Contact(DropCloud_pub.Text)
!a:: All_Path(DropServ_pub.Text, selectedTab , ControlGetText(EditHCode_pub) , DropCloud_pub.value)
!s:: All_Expression(ControlGetText(EditHCode_pub) . "_", 3 , 7)
!d:: AllDateType(true)

; Tab 2  Funcs
#HotIf selectedTab=2
!a:: All_Path(DropServ_hosted.Text, selectedTab , ControlGetText(EditFolder_hosted) , DropCloud_pub.value)
!s:: All_Expression("", 4 , DropScript_hosted.Value)
!d:: AllDateType(true)

; Tab 3
#HotIf selectedTab=3
!s:: All_Expression("" , DropDate_D360.Value , 8 )
!d:: AllDateType(false)

ClipboardPaste(txt){
	A_Clipboard := txt
	Sleep(100) ; Allow clipboard to update.
	Send("^v") ; Simulate Ctrl+V.
}

ClipboardTickChecker(txt){
	if(CheckBox_ClipboardUse.Value==1){
		ClipboardPaste(txt)
	}else {
		Typewriter(txt)
	}
}

Typewriter(txt){
	i:=1
	while i <= StrLen(txt) {
		char := SubStr(txt, i, 1)	; Extract one character at a time
		Send(char)					; Send the character as a keystroke
		Sleep(1)					; Pause for 100 milliseconds between keystrokes (adjust as needed)
		i++
		}
}


Pub_Code(code){
	result := "AB-" . code . "-XY"
    ClipboardTickChecker(result)
}

Pub_Name(name){
	result := name . " ABCD"
	ClipboardTickChecker(result)
}

Pub_Contact(txt){
    if (txt){
        result:="ABCD " . txt
		ClipboardTickChecker(result)
    }
}

All_Path(server,tab_num,suffix, pub_cloud){
	; tab 1 set
	rep1_server_path := ["rep1_server_path_01", "rep1_server_path_02"]
	cloud_paths := ["Cloud_path_01","Cloud_path_02","Cloud_path_03",
				"Cloud_path_04","Cloud_path_05","Cloud_path_06"]

	;tab 2 set 
	rep2_server_path := ["rep2_server_path_01","rep2_server_path_02"]

	result := ""
	; tab 1 result paths
	if(tab_num = 1){
		if(server = "Server_1_1"){
			result := rep1_server_path[1] . "string\" . cloud_paths[pub_cloud] . "\" . suffix . "\"
		} else if (server = "Server_1_2"){
			result := rep1_server_path[2] . "string\" . cloud_paths[pub_cloud] . "\" . suffix . "\"
		}
	} else if(tab_num = 2){
		if(server = "Server_2_1"){
			result := rep2_server_path[1] . "string\" . suffix . "\"
		} else if (server = "Server_2_2"){
			result := rep2_server_path[2] . "string\" . suffix . "\"
		}
	}
	ClipboardTickChecker(result)
}

All_Expression(prefix, dateType, suffix){

	; script 90 -> tab_1,  tab_3 -> 95 , rest -> 1...89

	suffixes := ["Suffix_01", "Suffix_02", "Suffix_03",
			"Suffix_04", "Suffix_05", "Suffix_06",
			"Suffix_07", ""]
	date_types := ["Date_type_01",
			"(Date_type_02",
			"Date_type_03",
			"Date_type_04"
			]

	result := prefix . date_types[dateType] . suffixes[suffix]
	ClipboardTickChecker(result)
}

AllDateType(type){
	result:=""
	if(type){
		result := "Result_01"
	} else {
		result := "Result_02"
	}
	ClipboardTickChecker(result)
}