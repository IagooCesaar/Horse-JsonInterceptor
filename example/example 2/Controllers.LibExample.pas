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

procedure DoSomething(var ABody: TBody);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Lista.Count) do
    ABody.Lista[i].Code := ABody.Lista[i].Code * 10;
end;

procedure PostWithLib(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBody;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest> // prepared by Jhonson and HorseJsonInterceptor
    .ToObject<TBody>;

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
