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

procedure PostWithLib_Familia(Req: THorseRequest; Resp: THorseResponse);
var LBody: TFamilia;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest> // prepared by Jhonson and HorseJsonInterceptor
    .ToObject<TFamilia>;

  DoSomething(LBody);

  Resp.Status(201).Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );

  LBody.Free;
end;

procedure PostWithLib_Biblioteca(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBiblioteca;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest>
    .ToObject<TBiblioteca>;

  Resp.Status(201).Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );

  LBody.Free;
end;

procedure PostWithLib_Empresa(Req: THorseRequest; Resp: THorseResponse);
var LBody: TEmpresa;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest>
    .ToObject<TEmpresa>;

  Resp.Status(201).Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );

  LBody.Free;
end;

procedure PostWithLib_Garagem(Req: THorseRequest; Resp: THorseResponse);
var LBody: TGaragem;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest>
    .ToObject<TGaragem>;

  Resp.Status(201).Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );

  LBody.Free;
end;

procedure PostWithLib_Escola(Req: THorseRequest; Resp: THorseResponse);
var LBody: TEscola;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest>
    .ToObject<TEscola>;

  Resp.Status(201).Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );

  LBody.Free;
end;

procedure PostWithLib_Pessoas(Req: THorseRequest; Resp: THorseResponse);
var LBody: TPessoas;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest>
    .ToObject<TPessoas>;

  Resp.Status(201).Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );

  LBody.Free;
end;

procedure PostWithLib_Todos(Req: THorseRequest; Resp: THorseResponse);
var LBody: TTodos;
begin
  LBody := Req
    .Body<THorseJsonInterceptorRequest>
    .ToObject<TTodos>;

  Resp.Status(201).Send(
    THorseJsonInterceptorResponse(LBody).ToString
  );

  LBody.Free;
end;

procedure Registry;
const CContext = 'with-lib/';
begin
  THorse
    .Post(CContext+'familia', PostWithLib_Familia)
    .Post(CContext+'biblioteca', PostWithLib_Biblioteca)
    .Post(CContext+'empresa', PostWithLib_Empresa)
    .Post(CContext+'garagem', PostWithLib_Garagem)
    .Post(CContext+'escola', PostWithLib_Escola)
    .Post(CContext+'pessoas', PostWithLib_Pessoas)
    .Post(CContext+'todos', PostWithLib_Todos)
end;

end.
