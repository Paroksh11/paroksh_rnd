object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 406
  ClientWidth = 788
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FileName: TLabel
    Left = 552
    Top = 341
    Width = 53
    Height = 16
    Caption = 'FileName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 103
    Width = 665
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Pushl_backup: TButton
    Left = 689
    Top = 129
    Width = 91
    Height = 25
    Caption = 'Push and Backup'
    TabOrder = 1
    OnClick = Pushl_backupClick
  end
  object Memo4: TMemo
    Left = 8
    Top = 8
    Width = 665
    Height = 89
    Lines.Strings = (
      'Memo4')
    TabOrder = 2
  end
  object Open: TButton
    Left = 689
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 3
    OnClick = OpenClick
  end
  object Pull: TButton
    Left = 689
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Pull'
    TabOrder = 4
    OnClick = PullClick
  end
  object Edit1: TEdit
    Left = 552
    Top = 314
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object Memo5: TMemo
    Left = 192
    Top = 350
    Width = 354
    Height = 48
    Lines.Strings = (
      'Memo5')
    TabOrder = 6
  end
  object location: TButton
    Left = 552
    Top = 363
    Width = 75
    Height = 25
    Caption = 'location'
    TabOrder = 7
    OnClick = locationClick
  end
  object Button1: TButton
    Left = 689
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 8
  end
  object CheckBox1: TCheckBox
    Left = 576
    Top = 240
    Width = 97
    Height = 17
    Caption = 'Trace It'
    TabOrder = 9
    OnClick = CheckBox1Click
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 16
    Top = 336
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 80
    Top = 336
  end
  object OpenDialog1: TOpenDialog
    Left = 144
    Top = 336
  end
end
