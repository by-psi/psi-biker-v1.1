unit md_principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Edit, FMX.Dialogs, FMX.DialogService,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.Components,
  REST.Response.Adapter, REST.Types, REST.Client, Data.Bind.ObjectScope,
  Web.HTTPApp, System.JSON, FMX.Colors;

type
  TF_principal = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    ed_origem: TEdit;
    Label2: TLabel;
    bg_header: TRectangle;
    Label3: TLabel;
    ed_destino: TEdit;
    lb_distancia: TLabel;
    bt_calcular: TRectangle;
    lb_tempo: TLabel;
    Layout3: TLayout;
    Label7: TLabel;
    Label8: TLabel;
    rst_Client: TRESTClient;
    rst_Request: TRESTRequest;
    logo: TImage;
    bt_sair: TImage;
    bt_exibirrota: TRectangle;
    bt_1: TSpeedButton;
    bt_2: TSpeedButton;
    RadioButton_1: TRadioButton;
    RadioButton_2: TRadioButton;
    RadioButton_3: TRadioButton;
    Layout4: TLayout;
    Label4: TLabel;
    procedure bt_calcularClick(Sender: TObject);
    procedure bt_testeClick(Sender: TObject);
    procedure bt_sairClick(Sender: TObject);
    procedure ed_OnKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_principal: TF_principal;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.iPhone4in.fmx IOS}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TF_principal.bt_testeClick(Sender: TObject);
begin
  showmessage('Implementar aqui a API Directions do Google Maps para exibir a rota sugerida');
  Exit;
end;

procedure TF_principal.ed_OnKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if not ( KeyChar in ['0'..'9','a'..'z','A'..'Z',',','.',#32,Chr(8)] ) then KeyChar:= #0
end;

procedure TF_principal.bt_sairClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Deseja fechar o aplicativo?', TMsgDlgType.mtConfirmation,
  [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
  procedure(const AResult: TModalResult)
  begin
    if AResult = mrYes then
    F_principal.Close;
  end);
end;

procedure TF_principal.bt_calcularClick(Sender: TObject);
var
  retorno: TJSONObject;
  p_rows: TJSONPair;
  array_rows: TJSONArray;
  array_elements: TJSONArray;
  obj_rows, obj_elements, obj_distancia,
  obj_duracao: TJSONObject;

  s_distancia,
  s_duracao: string;
  v_distancia,
  v_duracao: integer;
  media_v: double;

  var key: char;

begin
//  calcula a melhor rota entre {origem} e {destino} e retorna a distância e tempo:
//  https://developers.google.com/maps/documentation/distance-matrix/overview {documentação sobre a api}
//  https://maps.googleapis.com/maps/api/distancematrix/json?origins={origem}&destinations={destino}&mode=bicycling&language=pt-BR&key={key};

//  calcula a melhor rota entre {origem} e {destino} e retorna as coordenadas para exibir o mapa da rota sugerida:
//  https://developers.google.com/maps/documentation/directions/start {documentação}
//  https://maps.googleapis.com/maps/api/directions/json?origin={origem}&destination={destino}&key=YOUR_API_KEY

  rst_Request.Resource := 'json?origins={origem}&destinations={destino}&mode={opcao}&language=pt-BR&key={my_key}';
  rst_Request.Params.AddUrlSegment('origem', ed_origem.Text);
  rst_Request.Params.AddUrlSegment('destino', ed_destino.Text);
  rst_Request.Params.AddUrlSegment('my_key', 'AIzaSyAf1qrqUe2dV9hUpE-WiAI51jzcFeqHcUw');
  if RadioButton_1.IsChecked then
  rst_Request.Params.AddUrlSegment('opcao', 'bicycling') else
  if RadioButton_2.IsChecked then
  rst_Request.Params.AddUrlSegment('opcao', 'driving') else
  if RadioButton_3.IsChecked then
  rst_Request.Params.AddUrlSegment('opcao', 'walking');
  rst_Request.Execute;

  retorno := rst_Request.Response.JSONValue as TJSONObject;

  if retorno.GetValue('status').Value <> 'OK' then
  begin
    showmessage('Ocorreu um erro ao calcular sua rota');
    Exit;
  end;

  p_rows := retorno.Get('rows');
  array_rows := p_rows.JsonValue as TJSONArray;
  obj_rows := array_rows.Items[0] as TJSONObject;
  array_elements := obj_rows.GetValue('elements') as TJSONArray;
  obj_elements := array_elements.Items[0] as TJSONObject;

  obj_distancia := obj_elements.GetValue('distance') as TJSONObject;
  obj_duracao := obj_elements.GetValue('duration') as TJSONObject;

  s_distancia := obj_distancia.GetValue('text').Value;
  v_distancia := StrToInt(obj_distancia.GetValue('value').Value);
  s_duracao   := obj_duracao.GetValue('text').Value;
  v_duracao   := StrToInt(obj_duracao.GetValue('value').Value);

  lb_distancia.Text := 'Distância a percorrer: '+s_distancia;
  lb_tempo.Text := 'Tempo: '+s_duracao;

  media_v := (v_distancia / v_duracao) * 3.6;
  Label7.Text := FormatFloat('#00.0',media_v)+' Km/h';
end;

end.
