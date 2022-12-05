program HorseJsonInterceptor_HorseExample;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  App in 'App.pas',
  Controllers in 'Controllers.pas',
  Horse.JsonInterceptor.Example.Classes in '..\Horse.JsonInterceptor.Example.Classes.pas';

begin
  try
    App.Start;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
