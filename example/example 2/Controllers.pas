unit Controllers;

interface

procedure Registry;

implementation

uses
  Horse,
  REST.Json,
  System.Json,

  Horse.JsonInterceptor,
  Horse.JsonInterceptor.Core,

  Horse.JsonInterceptor.Example.Classes;

procedure DoSomething(var ABody: TBody);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Lista.Count) do
    ABody.Lista[i].Code := ABody.Lista[i].Code * 10;
end;

procedure PostWithMiddleware(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBody;
begin
  LBody := TJson.JsonToObject<TBody>(
    Req.Body<TJSONObject> // prepared by Jhonson and HorseJsonInterceptor
  );

  DoSomething(LBody);

  // Can be passed as TJsonObject or String
  //Resp.Send(TJson.ObjectToJsonObject(LBody));
  Resp.Send(TJson.ObjectToJsonString(LBody));
end;

procedure PostWithLib(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBody;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest>
    .ToObject<TBody>;

  DoSomething(LBody);

  Resp.Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );
end;

procedure Registry;
begin
  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post('with-middleware', PostWithMiddleware);

  THorse
    .Post('with-lib', PostWithLib)
end;

end.
