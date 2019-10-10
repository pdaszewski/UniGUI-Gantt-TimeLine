object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 594
  ClientWidth = 1074
  Caption = 'Gantt TimeLine Web GUI - wersja 0.0.1.0'
  OnShow = UniFormShow
  BorderStyle = bsSingle
  WindowState = wsMaximized
  OldCreateOrder = False
  BorderIcons = []
  MonitoredKeys.Keys = <>
  ClientEvents.ExtEvents.Strings = (
    
      'form.mousemove=function form.mousemove(sender, x, y, eOpts)'#13#10'{'#13#10 +
      '  ajaxRequest(sender, '#39'EventMyszki'#39', [ '#39'X='#39'+x, '#39'Y='#39'+y ]);'#13#10'}')
  OnAjaxEvent = UniFormAjaxEvent
  OnCreate = UniFormCreate
  DesignSize = (
    1074
    594)
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_top_bar: TUniPanel
    Left = 0
    Top = 0
    Width = 1074
    Height = 33
    Hint = ''
    Align = alTop
    TabOrder = 0
    Caption = ''
    DesignSize = (
      1074
      33)
    object display_date: TUniDateTimePicker
      Left = 952
      Top = 5
      Width = 112
      Hint = ''
      Enabled = False
      DateTime = 43739.000000000000000000
      DateFormat = 'dd/MM/yyyy'
      TimeFormat = 'HH:mm:ss'
      Anchors = [akTop, akRight]
      TabOrder = 1
      OnChangeValue = display_dateChangeValue
    end
  end
  object PageControl1: TUniPageControl
    Left = 0
    Top = 33
    Width = 1074
    Height = 539
    Hint = ''
    ActivePage = UniTabSheet1
    Align = alClient
    TabOrder = 1
    object UniTabSheet1: TUniTabSheet
      Hint = ''
      Caption = 'Wykres'
      object pnl_gantt: TUniPanel
        Left = 0
        Top = 0
        Width = 1066
        Height = 511
        Hint = ''
        Align = alClient
        TabOrder = 0
        BorderStyle = ubsNone
        Caption = ''
        object pnl_left: TUniPanel
          Left = 0
          Top = 0
          Width = 257
          Height = 511
          Hint = ''
          Align = alLeft
          TabOrder = 1
          Caption = ''
          object box_left: TUniScrollBox
            Left = 1
            Top = 1
            Width = 255
            Height = 509
            Hint = ''
            Align = alClient
            TabOrder = 1
          end
        end
        object pnl_right: TUniPanel
          Left = 1000
          Top = 0
          Width = 66
          Height = 511
          Hint = ''
          Align = alRight
          TabOrder = 2
          Caption = ''
        end
        object pnl_main: TUniPanel
          Left = 257
          Top = 0
          Width = 743
          Height = 511
          Hint = ''
          Align = alClient
          TabOrder = 3
          Caption = ''
          object box_main: TUniScrollBox
            Left = 1
            Top = 1
            Width = 741
            Height = 509
            Hint = ''
            Align = alClient
            TabOrder = 1
            object pointer_image: TUniImage
              Left = 24
              Top = 472
              Width = 16
              Height = 16
              Hint = ''
              Visible = False
              AutoSize = True
              Picture.Data = {
                0954506E67496D61676589504E470D0A1A0A0000000D49484452000000100000
                001008060000001FF3FF61000001AF4944415478DA636420139C9AAEA4A6A773
                EF2623259A416C920D0069D6D17A709351BB83E1DFD572D20C0069D6507B7493
                55BF8D81835F88E1CBE10CE20D006956557E7A93C3A819AC19043E1CC826CE00
                906645F91737798C2B809A0519FE032108BDDD4F8417409A65A45FDF1430CA64
                60E7E3676004E9F80F2418FF33BCD8DF81DF00906671F1F737458C2218387978
                18BE7FF9C2F0F6DC720669BB5470F03F3D301BB70120CD42429F6E4A1ABA32B0
                F37033FCFCFA95E1C5B9DD20973328D8FA83353E38BC11BB0120CD7CBCDF6ECA
                1A1831B073B331FCFCF68BE1F185B30C1AD12F19AF2F11FFAF6A6DC900F2CB9D
                23C7300D0069E6E4FC7953414F9E81838B99E1E7F7BF0CF72F3E64D04D780A56
                7B6981F47F4D4B65B0DAEBC7EFA21A00D2CCCAF2E7A68A3E2F033B0723C38FEF
                FF19EE5CFACC6094FA08AEEEDC6CB9FF3AE67C60F695939F1106803403A99B1A
                BABF809A19C08174F1342B92F18C40088E40067D93DF507936880120CD7FFE32
                DDD4D679CBC0C1F10F1CC7103D100D8CFF61428C90C40F153C7F468C8111A4F9
                D72FD69BBA3A8F18D8D9FF109B30C1E0CC594506C683FD1AFF49D2850600B65F
                9EBA79358E930000000049454E44AE426082}
            end
          end
        end
      end
    end
  end
  object StatusBar1: TUniStatusBar
    Left = 0
    Top = 572
    Width = 1074
    Hint = ''
    Panels = <
      item
        Width = 10
      end
      item
        Width = 100
      end
      item
        Width = 200
      end
      item
        Width = 50
      end>
    SizeGrip = False
    Align = alBottom
    ParentColor = False
    Color = clWindow
  end
  object pnl_trwa_ladowanie: TUniPanel
    Left = 144
    Top = 208
    Width = 849
    Height = 128
    Hint = ''
    Anchors = [akTop]
    ParentFont = False
    Font.Height = -27
    TabOrder = 3
    Caption = 'Trwa '#322'adowanie wykresu Gantta. Prosz'#281' czeka'#263'...'
    Color = 33023
  end
  object MouseTimer: TUniTimer
    Interval = 10
    Enabled = False
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = MouseTimerTimer
    Left = 565
    Top = 385
  end
  object AutoRun: TUniTimer
    Interval = 10
    Enabled = False
    RunOnce = True
    ClientEvent.Strings = (
      'function(sender)'
      '{'
      ' '
      '}')
    OnTimer = AutoRunTimer
    Left = 566
    Top = 434
  end
end
