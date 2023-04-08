unit Controllers.LibExample;

interface

procedure Registry;

implementation

uses
  Horse,
  REST.Json,
  System.Json,

  Horse.JsonInterceptor.Core,
  Horse.JsonInterceptor.Example.Classes;

procedure DoSomething(var ABody: TFamilia);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Membros.Count) do
    ABody.Membros[i].Codigo := ABody.Membros[i].Codigo * 10;
end;

procedure PostWithLib(Req: THorseRequest; Resp: THorseResponse);
var LBody: TFamilia;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest> // prepared by Jhonson and HorseJsonInterceptor
    .ToObject<TFamilia>;

  DoSomething(LBody);

  Resp.Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );
end;

procedure Registry;
begin
  THorse
    .Post('with-lib', PostWithLib)
end;

end.
