unit Horse.JsonInterceptor.CustomAttributes;

interface

uses
  System.Classes,
  REST.Json,
  REST.Json.Types,
  REST.JsonReflect;

type
  // Fonte: https://en.delphipraxis.net/topic/900-tjson-strip-tdatetime-property-where-value-is-0/

  TSuppressZeroDateInterceptor  = class(TJSONInterceptor)
  public
    function StringConverter(Data: TObject; Field: string): string; override;
    procedure StringReverter(Data: TObject; Field: string; Arg: string); override;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.TypInfo,
  System.Rtti;

{ TSuppressZeroDateInterceptor }

function TSuppressZeroDateInterceptor.StringConverter(Data: TObject; Field: string): string;
var
  ctx: TRTTIContext;
  date: TDateTime;
begin
  date := ctx.GetType(Data.ClassType).GetField(Field).GetValue(Data).AsType<TDateTime>;
  if date = 0
  then begin
    result := EmptyStr;//'null';
  end
  else
  begin
    result := DateToISO8601(date, True);
  end;
end;

procedure TSuppressZeroDateInterceptor.StringReverter(Data: TObject; Field, Arg: string);
var
  ctx: TRTTIContext;
  date: TDateTime;
begin
  if (Arg.IsEmpty) or (Arg = 'null')
  then begin
    date := 0;
  end
  else
  begin
    date := ISO8601ToDate(Arg, True);
  end;
  ctx.GetType(Data.ClassType).GetField(Field).SetValue(Data, date);
end;

end.
