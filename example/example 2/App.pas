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

  Controllers;

procedure Start;
begin
  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  THorse.Use(Jhonson('UTF-8'))
        .Use(HandleException);

  Controllers.Registry;

  THorse.Listen(StrToIntDef(GetEnvironmentVariable('SERVER_PORT'), 9000),
    procedure(Horse: THorse)
    begin
      Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
      Readln;
    end);

end;

end.
