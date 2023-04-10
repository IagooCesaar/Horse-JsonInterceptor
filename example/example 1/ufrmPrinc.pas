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
  REST.Json,
  System.JSON;

{$R *.dfm}

procedure TForm1.btnObjToJsonClick(Sender: TObject);
var LFamilia: TFamilia; LJson : TJSONObject;
begin
  LFamilia := TFamilia.Create;

  LFamilia.Membros.Add(TPessoa.Create);
  LFamilia.Membros.Last.Codigo  := 10;
  LFamilia.Membros.Last.Nome    := 'John Doe';
  LFamilia.Membros.Last.Sexo    := 'Male';

  LFamilia.Membros.Add(TPessoa.Create);
  LFamilia.Membros.Last.Codigo  := 20;
  LFamilia.Membros.Last.Nome    := 'Jane Doe';
  LFamilia.Membros.Last.Sexo    := 'Female';

  LJson := TJson.ObjectToJsonObject(LFamilia);

  mmJson.Lines.Text := TJson.Format(LJson);
  mmInterceptedJson.Lines.Text := TJson.Format(THorseJsonInterceptor.RemoverListHelperArray(LJson as TJSONValue));

  LFamilia.Free;
  LJson.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var LFamilia: TFamilia; LJson: string; I: Integer;
begin
  LJson := THorseJsonInterceptor.CriarListHelperArray(
    mmInterceptedJson.Lines.Text
  );
  LFamilia := TJson.JsonToObject<TFamilia>(LJson);
  lstPessoas.Clear;
  for I := 0 to Pred(LFamilia.Membros.Count) do
    lstPessoas.Items.Add(
      Format('Name: %s - Gender: %s - Code: %d', [
        LFamilia.Membros[i].Nome,
        LFamilia.Membros[i].Sexo,
        LFamilia.Membros[i].Codigo
      ]));
  LFamilia.Free;
end;

end.
