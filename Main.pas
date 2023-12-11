unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types, Vcl.ComCtrls,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, system.JSON,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdCookieManager, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditMonto: TEdit;
    Rbt_Venta: TRadioButton;
    Label3: TLabel;
    EditITBIS: TEdit;
    Rbt_Anulacion: TRadioButton;
    Rbt_GetLast: TRadioButton;
    Rbt_Devolucion: TRadioButton;
    Btn_cierre: TButton;
    Btn_Ejecutar: TButton;
    Rte_Response: TRichEdit;
    Check_Cuotas: TCheckBox;
    EditCuotas: TEdit;
    Rbt_Tpago: TRadioButton;
    CheckIMP: TCheckBox;
    Label4: TLabel;
    EditAnulacion: TEdit;
    ProgressBar1: TProgressBar;
    IdHTTP1: TIdHTTP;
    procedure Btn_EjecutarClick(Sender: TObject);
    procedure Check_CuotasClick(Sender: TObject);
    procedure CheckIMPClick(Sender: TObject);
    procedure EditMontoChange(Sender: TObject);
    procedure Rbt_VentaClick(Sender: TObject);
    procedure Rbt_AnulacionClick(Sender: TObject);
    procedure Rbt_DevolucionClick(Sender: TObject);
    procedure Rbt_TpagoClick(Sender: TObject);
    procedure Rbt_GetLastClick(Sender: TObject);
    procedure Btn_cierreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure Configurando(Credencial1, Credencial2, IdComercio, IdTerminal: string);
    Procedure CalculandoIMP();
    procedure MostrandoValores();
    Function Ejecutar(Transaccion : ShortInt): String;
    Function TipoTransaccion : ShortInt;
    Function CreandoCuerpo(Monto, ITBIS, Cuotas : string; Transacion : ShortInt) : TJSONObject;
  end;

var
  Form1: TForm1;
  ObjetoJSON : TJSONObject;
  ArrayJSON : TJSONArray;
  ValorJSON : TJSONValue;
  URL, Auth1, Auth2, IdCom, IdTer, vCuotas, vMonto, vITBIS : string;

implementation

{$R *.dfm}

procedure TForm1.EditMontoChange(Sender: TObject);
begin
  CalculandoIMP();
end;

Function TForm1.Ejecutar(Transaccion : ShortInt): String;
 var
 Response,Texto : string;
 Body : TStringStream;
 idHttpA : TidHttp;
 IdSSL : TIdSSLIOHandlerSocketOpenSSL;
 begin

  // ==== > Asignacion

  if Check_cuotas.Checked then
   vcuotas :=  EditCuotas.Text
  else vcuotas := '0';

  if EditMonto.Text <> '' then
    if checkIMP.Checked then
      vMonto :=  FormatCurr('0.##',strToCurr(EditMonto.Text))
    else
      vMonto :=  FormatCurr('0.##', (strToCurr(EditMonto.Text) + strToCurr(EditITBIS.Text)) )
  else
  vMonto := '0.00';

  if EditITBIS.Text <> '' then
  vITBIS :=  EditITBIS.Text
  else vITBIS := '0.00';

  // ==== > Construyendo Https POST
  IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  IdSSL.SSLOptions.Method := sslvSSLv23;
  IdSSL.SSLOptions.Mode := sslmUnassigned;

  Texto := CreandoCuerpo(vMonto,vITBIS,vCuotas,Transaccion).ToString;
  idHttpA := TidHttp.create(Nil);
  idHttpA.IOHandler := IdSSL;
  idHttpA.Request.ContentType := 'application/json';
  idHttpA.Request.CustomHeaders.AddValue('Auth1',Auth1);
  idHttpA.Request.CustomHeaders.AddValue('Auth2',Auth2);
  idHttpA.Request.Host := 'pruebas.azul.com.do';

  // ==== > Ejecucion de Https
  Body := TstringStream.Create(Texto,Tencoding.UTF8);
  response := idHttpA.Post(URL,Body);
  ObjetoJSON := TJSONObject.Create;
  ObjetoJSON := TJSONObject.ParseJSONValue(response) as TJSONObject;

  if  ObjetoJSON.GetValue('ResponseCode').GetValue<String> = '1[49]' then
  begin
    ShowMessage('Transaccion Exitosa');

    if Transaccion = 0 then
      Rte_Response.Text := ObjetoJSON.GetValue('ReceiptClient').GetValue<String>;

    if Transaccion = 4 then
      Rte_Response.Text := ObjetoJSON.GetValue('SaleResponse').GetValue<String>;
    if Transaccion = 5 then
      Rte_Response.Text := ObjetoJSON.GetValue('Receipt').GetValue<String>;

    //Rte_Response.Text := idHttpA.ResponseText;
  end
  else
  begin
    ShowMessage('Error en La transaccion -- Respuesta Erronea');
    Rte_Response.Text := ObjetoJSON.GetValue('ResponseCode').GetValue<String>;
  end;

  // ==== > Liberando Https
  idHttpA.Free;
  idSSL.Free;

 end;

procedure TForm1.Rbt_AnulacionClick(Sender: TObject);
begin
  EditAnulacion.Enabled := true;
  EditMonto.Enabled := False;
  check_cuotas.Enabled := false;
end;

procedure TForm1.Rbt_DevolucionClick(Sender: TObject);
begin
  EditAnulacion.Enabled := false;
  EditMonto.Enabled := true;
  check_cuotas.Enabled := false;
end;

procedure TForm1.Rbt_GetLastClick(Sender: TObject);
begin
  EditAnulacion.Enabled := false;
  EditMonto.Enabled := false;
  check_cuotas.Enabled := false;
end;

procedure TForm1.Rbt_TpagoClick(Sender: TObject);
begin
  EditAnulacion.Enabled := false;
  EditMonto.Enabled := true;
  check_cuotas.Enabled := true;
end;

procedure TForm1.Rbt_VentaClick(Sender: TObject);
begin
  EditAnulacion.Enabled := false;
  EditMonto.Enabled := true;
  check_cuotas.Enabled := true;
end;

Function Tform1.TipoTransaccion : ShortInt;
 begin
    if Rbt_Venta.Checked = true then
      Result := 0;
    if Rbt_Devolucion.Checked = true then
      Result := 1;
    if Rbt_Anulacion.Checked = true then
      Result := 2;
    if Rbt_Tpago.Checked = true then
      Result := 3;
    if Rbt_GetLast.Checked = true then
      Result := 4;
 end;

 procedure TForm1.Btn_cierreClick(Sender: TObject);
begin
  Configurando('merit','merit','39036630010','01290010');
  Ejecutar(5);
end;

procedure TForm1.Btn_EjecutarClick(Sender: TObject);
begin
  // Parametros por defecto Credenciales,IDcomercio,IDterminal
  Configurando('merit','merit','39036630010','01290010');
  Ejecutar(TipoTransaccion());
end;

Function Tform1.CreandoCuerpo(Monto, ITBIS, Cuotas : string; Transacion : ShortInt) : TJSONObject;
 var
 NumeroCuotas : SmallInt;
 begin

  objetoJSON := TJSONObject.Create;
  case Transacion  of
    {Ventas} 0 :
    begin
      URL := 'https://pruebas.azul.com.do/POSWebServices/JSON/default.aspx?Sale';

      objetoJSON.AddPair('Amount',Monto);
      objetoJSON.AddPair('Installment',Cuotas);
      objetoJSON.AddPair('Itbis',ITBIS);
      objetoJSON.AddPair('MerchantId',IdCom);
      objetoJSON.AddPair('OrderNumber','1');
      objetoJSON.AddPair('PromoData','');
      objetoJSON.AddPair('TerminalId',IdTer);
      objetoJSON.AddPair('UseMultiMessaging','0');
    end;
    {Devolucion} 1:
    begin
      URL := 'https://pruebas.azul.com.do/POSWebServices/JSON/default.aspx?Refund';

      objetoJSON.AddPair('Amount',Monto);
      objetoJSON.AddPair('Itbis',ITBIS);
      objetoJSON.AddPair('MerchantId',IdCom);
      objetoJSON.AddPair('OrderNumber','1');
      objetoJSON.AddPair('TerminalId',IdTer);

    end;
    {Anulacion} 2:
    begin
      URL := 'https://pruebas.azul.com.do/POSWebServices/JSON/default.aspx?SaleCancellation';

      objetoJSON.AddPair('Amount',Monto);
      objetoJSON.AddPair('AuthorizationNumber','');
      objetoJSON.AddPair('Itbis',ITBIS);
      objetoJSON.AddPair('MerchantId',IdCom);
      objetoJSON.AddPair('OrderNumber','1');
      objetoJSON.AddPair('TerminalId',IdTer);

    end;
    {Tpago} 3:
    begin
      URL := 'https://pruebas.azul.com.do/POSWebServices/JSON/default.aspx?MobilePayment';

       objetoJSON.AddPair('Amount',Monto);
       objetoJSON.AddPair('Installment',Cuotas);
       objetoJSON.AddPair('Itbis',ITBIS);
       objetoJSON.AddPair('MerchantId',IdCom);
       objetoJSON.AddPair('OrderNumber','1');
       objetoJSON.AddPair('TerminalId',IdTer);
       objetoJSON.AddPair('UseMultiMessaging','0');

    end;
    {GetLast} 4:
    begin
      URL := 'https://pruebas.azul.com.do/POSWebServices/JSON/default.aspx?GetLastTrx';

      objetoJSON.AddPair('MerchantId',IdCom);
      objetoJSON.AddPair('TerminalId',IdTer);
      objetoJSON.AddPair('TrxType','Sale');

    end;
    {Cierre} 5:
    begin
      URL := 'https://pruebas.azul.com.do/POSWebServices/JSON/default.aspx?PINPadSettle';

      objetoJSON.AddPair('MerchantId',IdCom);
      objetoJSON.AddPair('TerminalId',IdTer);

    end;
  end;
  result := objetoJSON;

 end;

 procedure TForm1.CheckIMPClick(Sender: TObject);
begin
 CalculandoIMP();
end;

procedure TForm1.Check_CuotasClick(Sender: TObject);
begin
  if Check_Cuotas.checked = true then
  begin
    EditCuotas.Enabled := true;
  end;
end;

procedure Tform1.MostrandoValores();
begin
  //'ResponseFields' objeto que contienes los valoes por separado
  Rte_Response.Lines.Add(ObjetoJSON.GetValue<string>('ResponseFields[4].Name'));
  Rte_Response.Lines.Add(ObjetoJSON.GetValue<string>('ResponseFields[4].Value'));
end;

Procedure Tform1.Configurando(Credencial1, Credencial2, IdComercio, IdTerminal: string);
 begin
   Auth1 := Credencial1;
   Auth2 := Credencial2;
   IdCom := Idcomercio;
   IdTer := Idterminal;
 end;

Procedure Tform1.CalculandoIMP();
var Monto, ITBIS: Currency;
begin
  Monto := StrtoCurr(EditMonto.Text);

  if EditMonto.text = null then
   EditITBIS.Text := '0'
  else
  begin
    if checkIMP.Checked = true then
    begin
      ITBIS := Monto - (Monto / 1.18);
      EditITBIS.Text := FormatCurr('0.##',ITBIS);
    end
    else
    begin
      ITBIS := Monto * 0.18;
      EditITBIS.Text := FormatCurr('0.##',ITBIS);
    end;
  end;
end;

end.
