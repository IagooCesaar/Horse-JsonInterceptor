object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 467
  ClientWidth = 1545
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 63
    Width = 481
    Height = 362
    Caption = 'Original JSON'
    TabOrder = 0
    object mmJson: TMemo
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 471
      Height = 339
      Align = alClient
      Lines.Strings = (
        'mmJson')
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object btnObjToJson: TButton
    Left = 8
    Top = 9
    Width = 161
    Height = 48
    Caption = 'btnObjToJson'
    TabOrder = 1
    OnClick = btnObjToJsonClick
  end
  object GroupBox2: TGroupBox
    Left = 495
    Top = 63
    Width = 481
    Height = 362
    Caption = 'Modified JSON'
    TabOrder = 2
    object mmInterceptedJson: TMemo
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 471
      Height = 339
      Align = alClient
      Lines.Strings = (
        'mmJson')
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 982
    Top = 63
    Width = 476
    Height = 357
    Caption = 'Modified JSON to Object'
    TabOrder = 3
    object Button1: TButton
      Left = 16
      Top = 18
      Width = 121
      Height = 41
      Caption = 'JsonToObject'
      TabOrder = 0
      OnClick = Button1Click
    end
    object lstPessoas: TListBox
      Left = 16
      Top = 65
      Width = 457
      Height = 272
      ItemHeight = 13
      TabOrder = 1
    end
  end
end
