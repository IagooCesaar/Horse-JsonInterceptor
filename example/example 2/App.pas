unit App;

interface

procedure Start;

implementation

uses
  System.SyncObjs,
  System.SysUtils,

  Horse,
  Horse.Jhonson,
  Horse.HandleException,

  Controllers.MiddlewareExample,
  Controllers.LibExample,
  Controllers.HelperExample;

procedure Start;
begin
  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  THorse.Use(Jhonson('UTF-8'))
        .Use(HandleException);

  Controllers.MiddlewareExample.Registry;
  Controllers.LibExample.Registry;
  Controllers.HelperExample.Registry;

  THorse.Listen(StrToIntDef(GetEnvironmentVariable('SERVER_PORT'), 9000),
    procedure(Horse: THorse)
    begin
      Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
      Readln;
    end);
end;

end.
