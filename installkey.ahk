#SingleInstance force
StyleCris := {Border:6
    , Rounded:12
    , BorderColor:0xff393e46
    , TextColor:0xffeeeeee
    , FontSize:20
    , FontStyle:"Bold"
    , Font:"Segoe UI"
        , BackgroundColorLinearGradientStart:0xff134E5E
        , BackgroundColorLinearGradientEnd:0xff326f69
        , BackgroundColorLinearGradientAngle:0
    , BackgroundColorLinearGradientMode:1}

    count = 0
    JoyMultiplier = 0.2
    JoyThreshold = 3
    JoyThresholdUpper := 50 + JoyThreshold
    JoyThresholdLower := 50 - JoyThreshold
    YAxisMultiplier = -1
    SetCapsLockState, AlwaysOff 
    SetTimer, WatchKeyboard, off ;启动时关闭模拟鼠标
    Hotkey, e, ButtonLeft
    Hotkey, r, ButtonRight
    Hotkey, w, empty
    Hotkey, s, empty
    Hotkey, a, empty
    Hotkey, d, empty
    Hotkey, f, empty
    Hotkey, g, empty

    Hotkey, e, Off
    Hotkey, r, Off
    Hotkey, w, Off
    Hotkey, s, Off
    Hotkey, a, Off
    Hotkey, d, Off
    Hotkey, f, Off
    Hotkey, g, Off

    empty:
    Return
    WatchKeyboard:

        if (GetKeyState("ctrl", "P")) 
        {
            return
        }

        moveSpd = 6
        MouseNeedsToBeMoved := false ; Set default.
        ;JoyMultiplier+=0.01
        SetFormat, float, 03
        i:=GetKeyState("w","p")
        k:=GetKeyState("s","p")
        j:=GetKeyState("a","p")
        l:=GetKeyState("d","p")

        f:=GetKeyState("f","p")
        if (f) 
        {
            moveSpd = 25
            JoyMultiplier = 1.0
        }

        if(l)
        {
            MouseNeedsToBeMoved := true
            DeltaX := moveSpd
        }
        else if(j)
        {
            MouseNeedsToBeMoved := true
            DeltaX := -moveSpd
        }
        else
            DeltaX = 0
        if (i)
        {
            MouseNeedsToBeMoved := true
            DeltaY := moveSpd
        }
        else if (k)
        {
            MouseNeedsToBeMoved := true
            DeltaY := -moveSpd
        }
        else
            DeltaY = 0
        if MouseNeedsToBeMoved
        {
            SetMouseDelay, -1 ; Makes movement smoother.
            MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
        }

        If(count>5){
            JoyMultiplier = 0.20
            count=0
        }

    return

    ButtonLeft:
        SetMouseDelay, -1 ; Makes movement smoother.
        MouseClick, left,,, 1, 0, D ; Hold down the left mouse button.
        SetTimer, WaitForLeftButtonUp, 10
    return

    ButtonRight:
        SetMouseDelay, -1 ; Makes movement smoother.
        MouseClick, right,,, 1, 0, D ; Hold down the right mouse button.
        SetTimer, WaitForRightButtonUp, 10
    return

    WaitForLeftButtonUp:
        if GetKeyState("e")
            return ; The button is still, down, so keep waiting.
        ; Otherwise, the button has been released.
        SetTimer, WaitForLeftButtonUp, off
        SetMouseDelay, -1 ; Makes movement smoother.
        MouseClick, left,,, 1, 0, U ; Release the mouse button.
    return

    WaitForRightButtonUp:
        if GetKeyState("r")
            return ; The button is still, down, so keep waiting.
        ; Otherwise, the button has been released.
        SetTimer, WaitForRightButtonUp, off
        MouseClick, right,,, 1, 0, U ; Release the mouse button.
    return

    CapsLock & Esc::
        If GetKeyState("CapsLock", "T") = 1
            SetCapsLockState, AlwaysOff
        Else
            SetCapsLockState, AlwaysOn

    RemoveToolTip:
        SetTimer, RemoveToolTip, Off
        btt()
    return

    CapsLock::
        editState := !editState
        if (editState) {
            #Persistent
            ; 获取多显示器各自 DPI 缩放比例
            CoordMode, ToolTip, Screen
            DisplayX := MouseX
            , DisplayY := MouseY
            Monitors := MDMF_Enum()
            , hMonitor := MDMF_FromPoint(DisplayX, DisplayY, MONITOR_DEFAULTTONEAREST:=2)
            , TargetLeft := Monitors[hMonitor].Left
            , TargetTop := Monitors[hMonitor].Top
            , TargetRight := Monitors[hMonitor].Right
            , TargetBottom := Monitors[hMonitor].Bottom
            , TargetWidth := TargetRight-TargetLeft
            , TargetHeight := TargetBottom-TargetTop
            ; 开启watchKeyBoard
            SetTimer, WatchKeyboard,10
            Hotkey, e, On
            Hotkey, r, On
            Hotkey, w, On
            Hotkey, s, On
            Hotkey, a, On
            Hotkey, d, On
            Hotkey, f, On
            Hotkey, g, On
            btt("[ ]Edit Mode`n[x]Cursor Mode`n",TargetWidth/2-100,100,, "StyleCris",{Transparent:v})​
            SetTimer, RemoveToolTip, 1500
        } else {
            #Persistent
            CoordMode, ToolTip, Screen
            DisplayX := MouseX
            , DisplayY := MouseY
            Monitors := MDMF_Enum()
            , hMonitor := MDMF_FromPoint(DisplayX, DisplayY, MONITOR_DEFAULTTONEAREST:=2)
            , TargetLeft := Monitors[hMonitor].Left
            , TargetTop := Monitors[hMonitor].Top
            , TargetRight := Monitors[hMonitor].Right
            , TargetBottom := Monitors[hMonitor].Bottom
            , TargetWidth := TargetRight-TargetLeft
            , TargetHeight := TargetBottom-TargetTop
            , DPIScale	 := Monitors[hMonitor].DPIScale
            SetTimer, WatchKeyboard, Off
            Hotkey, e, Off
            Hotkey, r, Off
            Hotkey, w, Off
            Hotkey, s, Off
            Hotkey, a, Off
            Hotkey, d, Off
            Hotkey, f, Off
            Hotkey, g, Off
            btt("[x]Edit Mode`n[ ]Cursor Mode`n",TargetWidth/2-100,100,, "StyleCris",{Transparent:v})​
            SetTimer, RemoveToolTip, 1500
        } Return

        #if editState
            ; 定义方向键映射，只有在空格键没有按下时才触发
        i::Up
        j::Left
        k::Down
        l::Right 
        8::+Home
        9::+End
        u::Home
        o::End
        ;选中当前行
    h::
        Send {Home}{ShiftDown}{End}{ShiftUp}
    return
    ;选中当前
    m::
        Send {RControl down}{Left}{RControl up}{RControl down}{RShift down}{Right}{RControl up}{RShift up} 
    return
    2::
        Send {XButton2}
    return
    1::
        Send {XButton1}
    return
    ;滑动
    t::send,{WheelUp}
    y::send,{WheelDown}
    ;e::PgUp
    ;e::PgDn

    #if
    CapsLock & `::
    ClipTemp = %clipboard%
    clipboard=[Cris]:%A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%
    Send,^{v}
    Sleep 100
    clipboard=%ClipTemp%
return
CapsLock & 2::
    Send {XButton2}
return
CapsLock & 1::
    Send {XButton1}
return
CapsLock & i::Up
CapsLock & j::Left
CapsLock & k::Down
CapsLock & l::Right
CapsLock & 8::+Home
CapsLock & 9::+End
CapsLock & u::Home
CapsLock & o::End
;选中当前行
CapsLock & h::
    Send {Home}{ShiftDown}{End}{ShiftUp}
return
;跳到行尾换行
CapsLock & Enter::
    Send {End}{Enter}
return
;选中当前
CapsLock & m::
    Send {RControl down}{Left}{RControl up}{RControl down}{RShift down}{Right}{RControl up}{RShift up} 
return
;滑动
CapsLock & t::send,{WheelUp}
CapsLock & y::send,{WheelDown}

;需求是多爱英提出，我用了面向对象的ahk来实现的。
;~ 按一下热键(win+z)
SetTitleMatchMode, 3
event_index:=-1
CapsLock & z::
    WinGetTitle, current_win, A
    if (current_win!=old_win)
        event_index=-1

    {
        old_win:=current_win
        ; WinGetPos, X, Y, current_Width, current_Height, %current_win% ;这里A应该改成目标窗口，只获取一次某窗口的大小
        ; 这里修改成获取鼠标所在监视器大小
        ; 设置鼠标坐标模式为屏幕坐标（全局坐标）
        CoordMode, Mouse, Screen
        MouseGetPos, MouseX, MouseY ; 获取鼠标的当前位置

        ; 遍历所有监视器, 默认监视器1
        curMonitorIdx = 1
        SysGet, MonitorCount, MonitorCount
        Loop, %MonitorCount%
        {
            SysGet, Monitor, Monitor, %A_Index% ; 获取第 A_Index 个监视器的坐标
            SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
            if (MouseX >= MonitorLeft and MouseX <= MonitorRight and MouseY >= MonitorTop and MouseY <= MonitorBottom)
            {
                ; 获取所在监视器宽度和高度
                curMonitorIdx = %A_Index%
                break
            }
        }
        ;若针对窗体而不是屏幕则解除上面注释 并给窗体值
        ;用SysGet, MonitorWorkArea，而未用A_ScreenWidth A_ScreenHeight 避免任务条的影响
        ;MsgBox, Monitor:`t`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)
        quarter := new quarter(MonitorWorkAreaRight - MonitorWorkAreaLeft, MonitorWorkAreaBottom - MonitorWorkAreaTop)
        one_third:= new one_third(MonitorWorkAreaRight - MonitorWorkAreaLeft, MonitorWorkAreaBottom - MonitorWorkAreaTop)
        two_third:= new two_third(MonitorWorkAreaRight - MonitorWorkAreaLeft, MonitorWorkAreaBottom - MonitorWorkAreaTop)
    }
    event_index+=1
    event_index:=Mod(event_index, 3) ;3个状态循环，模3，模运算得出 0，1，2
    commandArray := ["one_third","quarter","two_third"]
    runner:=commandArray[event_index+1] ;因为ahk的数组是从1开始的，对于索引为0时是空值，加一避免此问题
    %runner%.zoom()
    ;TrayTip, %current_win%缩放%runner%,% "w=" %runner%.getNewWidth()  ",h="  %runner%.getNewHeight() , 10,
    NewWidth:=%runner%.getNewWidth() 
    NewHeight:=%runner%.getNewHeight()
    WinMove, %current_win%,,MonitorWorkAreaLeft + (MonitorWorkAreaRight - MonitorWorkAreaLeft - NewWidth)/2,MonitorWorkAreaTop + (MonitorWorkAreaBottom - MonitorWorkAreaTop-NewHeight)/2,NewWidth,NewHeight
Return

class WinSize
{
    Width :=0
    Height := 0
    NewWidth:=0
    NewHeight:=0
    ;SetWidth(val){
    ;   Width := val ; Can set the color using a function of the class
    ;}
    ;SetHeight(val){
    ;   Height := val ; Can set the color using a function of the class
    ;}
    GetWidth(){
        Return this.Width ;需要增加this
    }

    GetHeight(){
        Return this.Height ;需要增加this
    }

    GetNewWidth(){
        Return this.NewWidth ;需要增加this
    }
    GetNewHeight(){
        Return this.NewHeight ;需要增加this
    }
    __New(w="",h=""){
        if (w="")
            this.Width :=A_ScreenWidth
        Else
            this.Width :=w		
        if (h="")	
            this.Height:=A_ScreenHeight
        Else
            this.Height := h
    }
}

Class half extends WinSize{
    zoom()
    {
        this.NewWidth:= this.Width//2 ;向下舍除 (//)
        this.NewHeight:= this.Height
    }
}

Class quarter extends WinSize{
    zoom()
    {
        this.NewWidth:= this.Width/9*5
        this.NewHeight:= this.Height/5*4
    }
}

Class one_third extends WinSize{
    zoom()
    {
        this.NewWidth:= this.Width/3*2
        this.NewHeight:= this.Height/4*3
    }
}

Class two_third extends WinSize{
    zoom()
    {
        this.NewWidth:= this.Width//3
        this.NewHeight:= this.Height
    }	
}