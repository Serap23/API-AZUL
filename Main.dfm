object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 676
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 260
    Height = 33
    Caption = 'Ambiente Prueba Azul'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 140
    Width = 52
    Height = 23
    Caption = 'Monto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 194
    Top = 140
    Width = 47
    Height = 23
    Caption = 'ITBIS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 263
    Top = 211
    Width = 61
    Height = 23
    Caption = 'No Doc'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object EditMonto: TEdit
    Left = 98
    Top = 140
    Width = 79
    Height = 21
    TabOrder = 0
    OnChange = EditMontoChange
  end
  object Rbt_Venta: TRadioButton
    Left = 16
    Top = 71
    Width = 113
    Height = 17
    Caption = 'Venta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Rbt_VentaClick
  end
  object EditITBIS: TEdit
    Left = 251
    Top = 142
    Width = 79
    Height = 21
    Enabled = False
    TabOrder = 2
  end
  object Rbt_Anulacion: TRadioButton
    Left = 128
    Top = 71
    Width = 113
    Height = 17
    Caption = 'Anulacion'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Rbt_AnulacionClick
  end
  object Rbt_GetLast: TRadioButton
    Left = 128
    Top = 101
    Width = 113
    Height = 17
    Caption = 'GetLast'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Rbt_GetLastClick
  end
  object Rbt_Devolucion: TRadioButton
    Left = 263
    Top = 71
    Width = 130
    Height = 17
    Caption = 'Devolucion'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = Rbt_DevolucionClick
  end
  object Btn_cierre: TButton
    Left = 8
    Top = 584
    Width = 177
    Height = 73
    Caption = 'Cierre'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = Btn_cierreClick
  end
  object Btn_Ejecutar: TButton
    Left = 232
    Top = 584
    Width = 177
    Height = 73
    Caption = 'Ejecutar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = Btn_EjecutarClick
  end
  object Rte_Response: TRichEdit
    Left = 8
    Top = 240
    Width = 401
    Height = 306
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 8
    Zoom = 100
  end
  object Check_Cuotas: TCheckBox
    Left = 16
    Top = 217
    Width = 113
    Height = 17
    Caption = 'Ventas por Cuotas ?'
    TabOrder = 9
    OnClick = Check_CuotasClick
  end
  object EditCuotas: TEdit
    Left = 135
    Top = 213
    Width = 42
    Height = 21
    Enabled = False
    NumbersOnly = True
    TabOrder = 10
  end
  object Rbt_Tpago: TRadioButton
    Left = 16
    Top = 94
    Width = 106
    Height = 31
    Caption = 'Tpago'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = Rbt_TpagoClick
  end
  object CheckIMP: TCheckBox
    Left = 16
    Top = 167
    Width = 137
    Height = 17
    Caption = 'Precio incluye impuesto ?'
    TabOrder = 12
    OnClick = CheckIMPClick
  end
  object EditAnulacion: TEdit
    Left = 330
    Top = 211
    Width = 79
    Height = 21
    Enabled = False
    TabOrder = 13
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 552
    Width = 401
    Height = 17
    TabOrder = 14
  end
  object IdHTTP1: TIdHTTP
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
    Left = 384
    Top = 144
  end
end
