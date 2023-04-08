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

procedure PostWithMiddleware_Familia(Req: THorseRequest; Resp: THorseResponse);
var LBody: TFamilia;
begin
  LBody := TJson.JsonToObject<TFamilia>(
    Req.Body<TJSONObject> // prepared by Jhonson and HorseJsonInterceptor
  );

  DoSomething(LBody);

  // Can be passed as TJsonObject or String
  //Resp.Send(TJson.ObjectToJsonObject(LBody));
  Resp.Status(201).Send(TJson.ObjectToJsonString(LBody));
  LBody.Free;
end;

procedure PostWithMiddleware_Biblioteca(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBiblioteca;
begin
  LBody := TJson.JsonToObject<TBiblioteca>(
    Req.Body<TJSONObject>
  );

  Resp.Status(201).Send(TJson.ObjectToJsonString(LBody));
  LBody.Free;
end;

procedure PostWithMiddleware_Empresa(Req: THorseRequest; Resp: THorseResponse);
var LBody: TEmpresa;
begin
  LBody := TJson.JsonToObject<TEmpresa>(
    Req.Body<TJSONObject>
  );

  Resp.Status(201).Send(TJson.ObjectToJsonString(LBody));
  LBody.Free;
end;

procedure PostWithMiddleware_Garagem(Req: THorseRequest; Resp: THorseResponse);
var LBody: TGaragem;
begin
  LBody := TJson.JsonToObject<TGaragem>(
    Req.Body<TJSONObject>
  );

  Resp.Status(201).Send(TJson.ObjectToJsonString(LBody));
  LBody.Free;
end;

procedure PostWithMiddleware_Escola(Req: THorseRequest; Resp: THorseResponse);
var LBody: TEscola;
begin
  LBody := TJson.JsonToObject<TEscola>(
    Req.Body<TJSONObject>
  );

  Resp.Status(201).Send(TJson.ObjectToJsonString(LBody));
  LBody.Free;
end;

procedure PostWithMiddleware_Pessoas(Req: THorseRequest; Resp: THorseResponse);
var LBody: TPessoas;
begin
  LBody := TJson.JsonToObject<TPessoas>(
    Req.Body<TJSONObject>
  );

  Resp.Status(201).Send(TJson.ObjectToJsonString(LBody));
  LBody.Free;
end;

procedure PostWithMiddleware_Todos(Req: THorseRequest; Resp: THorseResponse);
var LBody: TTodos;
begin
  LBody := TJson.JsonToObject<TTodos>(
    Req.Body<TJSONObject>
  );

  Resp.Status(201).Send(TJson.ObjectToJsonString(LBody));
  LBody.Free;
end;

procedure Registry;
const CContext = 'with-middleware/';
begin
  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post(CContext+'familia', PostWithMiddleware_Familia);

  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post(CContext+'biblioteca', PostWithMiddleware_Biblioteca);

  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post(CContext+'empresa', PostWithMiddleware_Empresa);

  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post(CContext+'garagem', PostWithMiddleware_Garagem);

  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post(CContext+'escola', PostWithMiddleware_Escola);

  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post(CContext+'pessoas', PostWithMiddleware_Pessoas);

  THorse
    .AddCallbacks([HorseJsonInterceptor])
    .Post(CContext+'todos', PostWithMiddleware_Todos);

end;

end.
