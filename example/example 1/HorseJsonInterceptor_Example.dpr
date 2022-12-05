program HorseJsonInterceptor_Example;

uses
  Vcl.Forms,
  ufrmPrinc in 'ufrmPrinc.pas' {Form1},
  Horse.JsonInterceptor.Example.Classes in '..\Horse.JsonInterceptor.Example.Classes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
