unit Controllers.MiddlewareExample;

interface

procedure Registry;

implementation

uses
  Horse,
  REST.Json,
  System.Json,

  Horse.JsonInterceptor,
  Horse.JsonInterceptor.Example.Classes;

procedure DoSomething(var ABody: TFamilia);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Membros.Count) do
    ABody.Membros[i].Codigo := ABody.Membros[i].Codigo * 10;
end;

procedure PostWithMiddleware(Req: THorseRequest; Resp: THorseResponse);
var LBody: TFamilia;
begin
  LBody := TJson.JsonToObject<TFamilia>(
    Req.Body<TJSONObject> // prepared by Jhonson and HorseJsonInterceptor
  );

  DoSomething(LBody);

  // Can be passed as TJsonObject or String
  //Resp.Send(TJson.ObjectToJsonObject(LBody));
  Resp.Send(TJson.ObjectToJsonString(LBody));
  LBody.Free;
end;

procedure Registry;
const CContext = 'with-middleware/';
begin
  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post(CContext+'familia', PostWithMiddleware);
end;

end.
