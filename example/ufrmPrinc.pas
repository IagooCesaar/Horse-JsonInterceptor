unit ufrmPrinc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    mmJson: TMemo;
    btnObjToJson: TButton;
    GroupBox2: TGroupBox;
    mmInterceptedJson: TMemo;
    GroupBox3: TGroupBox;
    Button1: TButton;
    lstPessoas: TListBox;
    procedure btnObjToJsonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Horse.JsonInterceptor.Example.Classes,
  Horse.JsonInterceptor.Core,

  System.Generics.Collections,
  REST.Json;

{$R *.dfm}

procedure TForm1.btnObjToJsonClick(Sender: TObject);
var LBody: TBody; LJson : string;
begin
  LBody := TBody.Create;
  LBody.Lista := TObjectList<TPessoa>.Create;

  LBody.Lista.Add(TPessoa.Create);
  LBody.Lista.Last.Code   := 10;
  LBody.Lista.Last.Name   := 'John Doe';
  LBody.Lista.Last.Gender := 'Male';

  LBody.Lista.Add(TPessoa.Create);
  LBody.Lista.Last.Code   := 20;
  LBody.Lista.Last.Name   := 'Jane Doe';
  LBody.Lista.Last.Gender := 'Female';

  LJson := TJson.ObjectToJsonString(LBody);

  mmJson.Lines.Text := LJson;
  mmInterceptedJson.Lines.Text := THorseJsonInterceptor.TratarResponseBody(LJson);

  LBody.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var LBody: TBody; LJson: string; I: Integer;
begin
  LJson := THorseJsonInterceptor.TratarRequestBody(
    mmInterceptedJson.Lines.Text
  );
  LBody := TJson.JsonToObject<TBody>(LJson);
  lstPessoas.Clear;
  for I := 0 to Pred(LBody.Lista.Count) do
    lstPessoas.Items.Add(
      Format('Name: %s - Gender: %s - Code: %d', [
        LBody.Lista[i].Name,
        LBody.Lista[i].Gender,
        LBody.Lista[i].Code
      ]));
end;

end.
