program HorseJsonInterceptor_HorseExample;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  App in 'App.pas',
  Horse.JsonInterceptor.Example.Classes in '..\Horse.JsonInterceptor.Example.Classes.pas',
  Controllers.MiddlewareExample in 'Controllers.MiddlewareExample.pas',
  Controllers.LibExample in 'Controllers.LibExample.pas',
  Controllers.HelperExample in 'Controllers.HelperExample.pas';

begin
  try
    var App : TApp;
    App := TApp.Create;
    App.Start;

    App.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
